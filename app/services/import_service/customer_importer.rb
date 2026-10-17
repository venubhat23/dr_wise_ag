require 'csv'
require 'roo'

module ImportService
  # Bulk customer import covering every field of the admin "New Client" form
  # (admin/customers/new), including family members (individual) and corporate
  # members (corporate) as numbered column groups: family_member_1_first_name,
  # corporate_member_2_mobile, ... Template, preview and import all use the
  # column lists below.
  class CustomerImporter
    INDIVIDUAL_COLUMNS = %w[
      customer_type* first_name* middle_name last_name* mobile* email sub_agent_mobile
      state city address pincode birth_place birth_date* anniversary_date gender
      height_feet weight_kg education marital_status business_job business_name
      type_of_duty annual_income pan_no additional_information
      bank_name account_no ifsc_code
      nominee_name* nominee_relation* nominee_date_of_birth* status
    ].freeze

    CORPORATE_COLUMNS = %w[
      customer_type* company_name* mobile* email* sub_agent_mobile
      state city address pincode annual_income pan_no gst_no* additional_information status
    ].freeze

    FAMILY_MEMBER_FIELDS = %w[
      first_name middle_name last_name relationship birth_date gender mobile pan_no
      height_feet weight_kg additional_information
    ].freeze

    CORPORATE_MEMBER_FIELDS = %w[
      company_name mobile email state city address annual_income pan_no gst_no additional_information
    ].freeze

    # Member slots included in the downloadable template (the importer reads any number)
    TEMPLATE_MEMBER_SLOTS = 2

    GENDERS = %w[male female other].freeze
    MARITAL_STATUSES = %w[single married divorced widowed].freeze
    BUSINESS_JOBS = %w[salaried self_employed business professional student retired unemployed other].freeze

    attr_reader :file, :imported_count, :skipped_count, :errors

    def self.template_headers(client_type)
      family = member_headers('family_member', FAMILY_MEMBER_FIELDS)
      corporate = member_headers('corporate_member', CORPORATE_MEMBER_FIELDS)

      case client_type
      when 'individual' then INDIVIDUAL_COLUMNS + family
      when 'corporate' then CORPORATE_COLUMNS + corporate
      else
        # Both types: drop the type-specific "*" markers since each applies to one type only
        base = (INDIVIDUAL_COLUMNS + CORPORATE_COLUMNS).map { |h| %w[customer_type* mobile*].include?(h) ? h : h.delete('*') }.uniq
        base + family + corporate
      end
    end

    def self.member_headers(prefix, fields)
      (1..TEMPLATE_MEMBER_SLOTS).flat_map { |n| fields.map { |f| "#{prefix}_#{n}_#{f}" } }
    end

    def initialize(file)
      @file = file
      @imported_count = 0
      @skipped_count = 0
      @errors = []
    end

    def import
      each_row do |row, row_number|
        customer, row_errors = build_and_check(row)
        if row_errors.any?
          @errors << "Row #{row_number}: #{row_errors.join(', ')}"
          @skipped_count += 1
          next
        end

        Customer.transaction do
          customer.save!
          # Same as the New Client form: always create the mobile login when there is an email
          customer.create_login_user! if customer.email.present?
        end
        @imported_count += 1
      rescue ActiveRecord::RecordInvalid => e
        @errors << "Row #{row_number}: #{e.record.errors.full_messages.join(', ')}"
        @skipped_count += 1
      rescue => e
        @errors << "Row #{row_number}: #{e.message}"
        @skipped_count += 1
      end

      { success: true, imported_count: @imported_count, skipped_count: @skipped_count, errors: @errors }
    rescue => e
      { success: false, error: e.message, imported_count: @imported_count, skipped_count: @skipped_count, errors: @errors }
    end

    # Validates every row without saving; returns [{ row:, data:, errors:, valid: }]
    def preview
      seen_mobiles = Set.new
      seen_emails = Set.new
      results = []

      each_row do |row, row_number|
        customer, row_errors = build_and_check(row)
        mobile = customer&.mobile # normalised by Customer's before_validation
        email = customer&.email
        row_errors << 'Mobile number repeated in this file' if mobile.present? && !seen_mobiles.add?(mobile)
        row_errors << 'Email repeated in this file' if email.present? && !seen_emails.add?(email)

        results << { row: row_number - 1, data: row.transform_values { |v| cell(v) }, errors: row_errors.uniq, valid: row_errors.empty? }
      end

      results
    end

    private

    def each_row
      spreadsheet = open_spreadsheet(@file)
      header = spreadsheet.row(1).map { |h| h.to_s.strip }
      validate_headers(header)

      (2..spreadsheet.last_row).each do |i|
        values = spreadsheet.row(i)
        next if values.all? { |v| cell(v).blank? }

        yield Hash[header.zip(values)], i
      end
    end

    def open_spreadsheet(file)
      case File.extname(file.original_filename).downcase
      when '.csv' then Roo::CSV.new(file.path)
      when '.xls' then Roo::Excel.new(file.path)
      when '.xlsx' then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
      end
    end

    def validate_headers(header)
      normalized = header.map { |h| h.downcase.delete('*') }
      missing = %w[mobile] - normalized
      raise "Missing required headers: #{missing.join(', ')}" if missing.any?
    end

    # Header keys without "*" markers, lowercased; values as trimmed strings
    def normalize_keys(row)
      row.each_with_object({}) do |(key, value), h|
        h[key.to_s.downcase.delete('*').strip] = cell(value).presence
      end
    end

    # Excel returns numbers as floats (9876543210.0) and dates as Date objects
    def cell(value)
      case value
      when Float then value == value.to_i ? value.to_i.to_s : value.to_s
      when Date, DateTime, Time then value.to_date.iso8601
      else value.to_s.strip
      end
    end

    def build_and_check(row)
      data = normalize_keys(row)
      errors = []

      type = (data['customer_type'] || 'individual').downcase # column optional; defaults to individual
      unless %w[individual corporate].include?(type)
        return [nil, ["customer_type must be 'individual' or 'corporate'"]]
      end

      attrs = customer_attributes(data, type, errors)
      attrs[:sub_agent_id] = find_sub_agent_id(data, errors)

      if type == 'individual'
        attrs[:family_members_attributes] = member_attributes(data, 'family_member', FAMILY_MEMBER_FIELDS) do |m|
          m['relationship'] = m['relationship']&.downcase
          m['gender'] = m['gender']&.downcase
          m['birth_date'] = parse_date(m['birth_date'], "family member birth_date", errors)
          m['pan_no'] = m['pan_no']&.upcase
        end
      else
        attrs[:corporate_members_attributes] = member_attributes(data, 'corporate_member', CORPORATE_MEMBER_FIELDS) do |m|
          m['email'] = m['email']&.downcase
          m['annual_income'] = parse_number(m['annual_income'])
          m['pan_no'] = m['pan_no']&.upcase
          m['gst_no'] = m['gst_no']&.upcase
        end
      end

      customer = Customer.new(attrs.compact)
      errors.concat(customer.errors.full_messages) unless customer.valid?

      if customer.email.present? && Customer.exists?(email: customer.email)
        errors << "Customer with email '#{customer.email}' already exists"
      end

      [customer, errors.uniq]
    end

    def customer_attributes(data, type, errors)
      gender = data['gender']&.downcase
      errors << "gender must be one of #{GENDERS.join('/')}" if gender && !GENDERS.include?(gender.to_s)
      gender = nil unless GENDERS.include?(gender.to_s)
      marital = data['marital_status']&.downcase
      errors << "marital_status must be one of #{MARITAL_STATUSES.join('/')}" if marital && !MARITAL_STATUSES.include?(marital.to_s)
      marital = nil unless MARITAL_STATUSES.include?(marital.to_s)
      business_job = data['business_job']&.downcase&.tr(' ', '_')
      if business_job && !BUSINESS_JOBS.include?(business_job)
        errors << "business_job must be one of #{BUSINESS_JOBS.join('/')}"
      end

      common = {
        customer_type: type,
        mobile: data['mobile'],
        email: data['email']&.downcase,
        state: data['state'],
        city: data['city'],
        address: data['address'],
        pincode: data['pincode'],
        annual_income: parse_number(data['annual_income']),
        pan_no: data['pan_no']&.upcase,
        additional_information: data['additional_information'] || data['notes'],
        status: parse_status(data['status']),
        added_by: 'bulk_import'
      }

      return common.merge(company_name: data['company_name'], gst_no: data['gst_no']&.upcase) if type == 'corporate'

      common.merge(
        first_name: data['first_name'],
        middle_name: data['middle_name'],
        last_name: data['last_name'],
        birth_place: data['birth_place'],
        birth_date: parse_date(data['birth_date'], 'birth_date', errors),
        anniversary_date: parse_date(data['anniversary_date'], 'anniversary_date', errors),
        gender: gender,
        height_feet: data['height_feet'],
        weight_kg: parse_number(data['weight_kg']),
        education: data['education'],
        marital_status: marital,
        business_job: business_job,
        business_name: data['business_name'],
        type_of_duty: data['type_of_duty'],
        occupation: data['occupation'],
        job_name: data['job_name'],
        bank_name: data['bank_name'],
        account_no: data['account_no'],
        ifsc_code: data['ifsc_code']&.upcase,
        nominee_name: data['nominee_name'],
        nominee_relation: data['nominee_relation']&.downcase,
        nominee_date_of_birth: parse_date(data['nominee_date_of_birth'], 'nominee_date_of_birth', errors)
      )
    end

    # Collects family_member_N_* / corporate_member_N_* groups that have any value
    def member_attributes(data, prefix, fields)
      slots = data.keys.filter_map { |k| k[/\A#{prefix}_(\d+)_/, 1]&.to_i }.uniq.sort
      members = slots.filter_map do |n|
        member = fields.to_h { |f| [f, data["#{prefix}_#{n}_#{f}"]] }
        next if member.values.all?(&:blank?)

        yield member
        member.compact
      end
      members.presence
    end

    # Affiliate by mobile (preferred) or by full name (older templates)
    def find_sub_agent_id(data, errors)
      if (mobile = data['sub_agent_mobile']).present?
        id = SubAgent.where(mobile: mobile.gsub(/\D/, '').last(10)).pick(:id)
        errors << "Affiliate with mobile #{mobile} not found" unless id
        id
      elsif (name = data['sub_agent_name']).present?
        id = SubAgent.where("LOWER(CONCAT_WS(' ', first_name, NULLIF(middle_name, ''), last_name)) = ?", name.downcase.squish).pick(:id) ||
             SubAgent.where("LOWER(CONCAT_WS(' ', first_name, last_name)) = ?", name.downcase.squish).pick(:id)
        errors << "Affiliate '#{name}' not found" unless id
        id
      end
    end

    def parse_status(value)
      return true if value.blank?

      !%w[false 0 no inactive n].include?(value.to_s.downcase)
    end

    def parse_date(value, field, errors)
      return nil if value.blank?

      Date.parse(value.to_s)
    rescue ArgumentError
      errors << "Invalid #{field} '#{value}' (use YYYY-MM-DD)"
      nil
    end

    def parse_number(value)
      return nil if value.blank?

      value.to_s.gsub(/[^\d.]/, '').presence&.to_f
    end
  end
end
