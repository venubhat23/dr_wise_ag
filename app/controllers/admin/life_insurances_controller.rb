class Admin::LifeInsurancesController < Admin::ApplicationController
  include ConfigurablePagination
  before_action :set_life_insurance, only: [:show, :edit, :update, :destroy, :commission_details, :renew, :create_renewal]

  # GET /admin/insurance/life
  def index
    @life_insurances = LifeInsurance.includes(:customer, :sub_agent, :agency_code, :broker)

    # Tab-based filtering for DrWise vs Non-DrWise policies
    @current_tab = params[:tab] || 'drwise'

    case @current_tab
    when 'drwise'
      # DrWise policies: Admin added policies (is_admin_added: true AND others false)
      @life_insurances = @life_insurances.where(
        is_admin_added: true,
        is_customer_added: false,
        is_agent_added: false
      )
    when 'non_drwise'
      # Non-DrWise policies: Customer or Agent added policies
      @life_insurances = @life_insurances.where(
        '(is_customer_added = ? AND is_admin_added = ? AND is_agent_added = ?) OR (is_agent_added = ? AND is_customer_added = ? AND is_admin_added = ?)',
        true, false, false, true, false, false
      )
    end

    # Search functionality (within current tab)
    if params[:search].present?
      @life_insurances = @life_insurances.search_life_policies(params[:search])
    end

    # Filter by payment mode
    if params[:payment_mode].present?
      @life_insurances = @life_insurances.where(payment_mode: params[:payment_mode])
    end

    # Filter by status
    case params[:status]
    when 'active'
      @life_insurances = @life_insurances.active
    when 'expired'
      @life_insurances = @life_insurances.expired
    when 'expiring_soon'
      @life_insurances = @life_insurances.expiring_soon
    end

    # Filter by policy type
    if params[:policy_type].present?
      @life_insurances = @life_insurances.where(policy_type: params[:policy_type])
    end

    # Filter by insurance company
    if params[:company].present?
      @life_insurances = @life_insurances.where(insurance_company_name: params[:company])
    end

    # Calculate statistics for current tab (before pagination)
    calculate_tab_statistics

    @life_insurances = paginate_records(@life_insurances.order(created_at: :desc))
  end

  # GET /admin/insurance/life/1
  def show
  end

  # GET /admin/insurance/life/new
  def new
    @life_insurance = LifeInsurance.new
    set_form_data

    # Set default commission percentage from system settings
    @life_insurance.main_agent_commission_percentage = SystemSetting.default_main_agent_commission

    # Pre-fill customer data if coming from customer page
    if params[:customer_id].present?
      @selected_customer = Customer.find(params[:customer_id])
      @life_insurance.customer_id = @selected_customer.id

      # Auto-select customer's existing affiliate if they have one
      if @selected_customer.affiliate.present?
        @life_insurance.sub_agent_id = @selected_customer.affiliate.id
        @auto_select_affiliate = @selected_customer.affiliate.id
      else
        # Set 'Self' as default affiliate (no sub_agent)
        @auto_select_affiliate = 'self'
      end

      # Auto-populate family members as policy holder options
      @customer_family_members = @selected_customer.family_members.includes(:customer)
    end
  end

  # GET /admin/insurance/life/1/edit
  def edit
    set_form_data

    # Load customer family members for policy holder dropdown if customer is selected
    if @life_insurance.customer_id.present?
      @selected_customer = @life_insurance.customer
      @customer_family_members = @selected_customer.family_members.includes(:customer)
    else
      @customer_family_members = []
    end

    # Set auto_select_affiliate for the form
    if @life_insurance.sub_agent_id.present?
      @auto_select_affiliate = @life_insurance.sub_agent_id
    else
      @auto_select_affiliate = 'self'
    end

    # For broking type policies, determine the correct agency_code selection
    # Since we store broker_id but the form expects broker_X format for broking
    if @life_insurance.broker_code_type == 'broking' && @life_insurance.broker_id.present?
      # Find the broker code that matches this broker
      broker_code = BrokerCode.find_by(broker_id: @life_insurance.broker_id)
      if broker_code
        @selected_broker_code = "broker_#{broker_code.id}"
      end
    end
  end

  # POST /admin/insurance/life
  def create
    processed_params = process_broker_params(life_insurance_params)
    @life_insurance = LifeInsurance.new(processed_params)

    # Set admin tracking fields for policies created from admin panel
    @life_insurance.policy_added_by_admin = true
    @life_insurance.is_admin_added = true
    @life_insurance.is_customer_added = false
    @life_insurance.is_agent_added = false

    # Auto-set affiliate from customer if not already set
    if @life_insurance.sub_agent_id.blank? && @life_insurance.customer_id.present?
      customer = Customer.find(@life_insurance.customer_id)
      if customer.sub_agent_id.present?
        @life_insurance.sub_agent_id = customer.sub_agent_id
      elsif customer.lead_id.present?
        lead = Lead.find_by(lead_id: customer.lead_id)
        @life_insurance.sub_agent_id = lead.affiliate_id if lead&.affiliate_id.present?
      end
    end

    set_distributor_from_affiliate(@life_insurance)

    begin
      # Ensure distributor is set before saving (double-check)
      set_distributor_from_affiliate(@life_insurance)

      if @life_insurance.save
        redirect_to admin_life_insurances_path,
                    notice: 'Life insurance policy was successfully created.'
      else
        set_form_data
        preserve_form_state_on_error
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique => e
      if e.message.include?('policy_number')
        @life_insurance.errors.add(:policy_number, 'has already been taken')
      else
        @life_insurance.errors.add(:base, 'A record with similar details already exists')
      end
      set_form_data
      preserve_form_state_on_error
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/insurance/life/1
  def update
    processed_params = process_broker_params(life_insurance_params)
    @life_insurance.assign_attributes(processed_params)
    set_distributor_from_affiliate(@life_insurance)

    begin
      if @life_insurance.save
        redirect_to admin_life_insurances_path,
                    notice: 'Life insurance policy was successfully updated.'
      else
        set_form_data
        render :edit, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique => e
      if e.message.include?('policy_number')
        @life_insurance.errors.add(:policy_number, 'has already been taken')
      else
        @life_insurance.errors.add(:base, 'A record with similar details already exists')
      end
      set_form_data
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/insurance/life/1
  def destroy
    begin
      # Store policy details for feedback message
      policy_number = @life_insurance.policy_number
      customer_name = @life_insurance.customer&.display_name

      # Delete all related records in proper order
      Rails.logger.info "Deleting Life Insurance Policy #{policy_number} and all related records..."

      # 1. Delete commission payouts
      commission_payouts = CommissionPayout.where(policy_type: 'life', policy_id: @life_insurance.id)
      commission_payouts_count = commission_payouts.count
      commission_payouts.destroy_all
      Rails.logger.info "Deleted #{commission_payouts_count} commission payouts"

      # 2. Delete renewal relationships
      if @life_insurance.renewal_policy_id.present?
        renewal_policy = LifeInsurance.find_by(id: @life_insurance.renewal_policy_id)
        if renewal_policy
          renewal_policy.update!(original_policy_id: nil)
          Rails.logger.info "Cleared renewal relationship"
        end
      end

      # If this is a renewal policy, clear the original policy's renewal reference
      if @life_insurance.original_policy_id.present?
        original_policy = LifeInsurance.find_by(id: @life_insurance.original_policy_id)
        if original_policy
          original_policy.update!(renewal_policy_id: nil, is_renewed: false)
          Rails.logger.info "Cleared original policy renewal reference"
        end
      end

      # 3. Delete Active Storage attachments (documents)
      if @life_insurance.documents.attached?
        documents_count = @life_insurance.documents.count
        @life_insurance.documents.purge
        Rails.logger.info "Deleted #{documents_count} attached documents"
      end

      if @life_insurance.policy_documents.attached?
        policy_docs_count = @life_insurance.policy_documents.count
        @life_insurance.policy_documents.purge
        Rails.logger.info "Deleted #{policy_docs_count} policy documents"
      end

      # 4. Delete associated model records (if they exist)
      begin
        if @life_insurance.respond_to?(:life_insurance_nominees) && @life_insurance.life_insurance_nominees.any?
          nominees_count = @life_insurance.life_insurance_nominees.count
          @life_insurance.life_insurance_nominees.destroy_all
          Rails.logger.info "Deleted #{nominees_count} nominees"
        end
      rescue => e
        Rails.logger.warn "Could not delete nominees: #{e.message}"
      end

      begin
        if @life_insurance.respond_to?(:life_insurance_bank_detail) && @life_insurance.life_insurance_bank_detail.present?
          @life_insurance.life_insurance_bank_detail.destroy
          Rails.logger.info "Deleted bank detail"
        end
      rescue => e
        Rails.logger.warn "Could not delete bank detail: #{e.message}"
      end

      begin
        if @life_insurance.respond_to?(:life_insurance_documents) && @life_insurance.life_insurance_documents.any?
          docs_count = @life_insurance.life_insurance_documents.count
          @life_insurance.life_insurance_documents.destroy_all
          Rails.logger.info "Deleted #{docs_count} document records"
        end
      rescue => e
        Rails.logger.warn "Could not delete document records: #{e.message}"
      end

      # 5. Finally delete the life insurance record itself
      @life_insurance.destroy!

      Rails.logger.info "Successfully deleted Life Insurance Policy #{policy_number} and all related records"

      redirect_to admin_life_insurances_path,
                  notice: "Life insurance policy '#{policy_number}' for #{customer_name} and all related records (payouts, documents) have been successfully deleted."

    rescue => e
      Rails.logger.error "Failed to delete Life Insurance Policy: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")

      redirect_to admin_life_insurances_path,
                  alert: "Failed to delete life insurance policy: #{e.message}"
    end
  end

  # Policy holder options method removed - now using simple text input


  # GET /admin/insurance/life/1/commission_details
  def commission_details
    # This will render the commission details view
  end

  # API endpoint for getting brokers by insurance company
  def brokers_by_company
    company_name = params[:company_name]
    brokers = if company_name.present?
                # First get insurance_company by name, then get brokers
                insurance_company = InsuranceCompany.find_by(name: company_name)
                if insurance_company
                  Broker.where(insurance_company: insurance_company).active.order(:name)
                else
                  Broker.none
                end
              else
                Broker.none
              end

    render json: {
      brokers: brokers.map { |b| { id: b.id, name: b.name } }
    }
  end

  # API endpoint for getting agency codes by broker
  def agency_codes_by_broker
    broker_id = params[:broker_id]
    agency_codes = if broker_id.present?
                     AgencyCode.where(broker_id: broker_id, insurance_type: 'Life').order(:code)
                   else
                     AgencyCode.none
                   end

    render json: {
      agency_codes: agency_codes.map { |a| { id: a.id, name: "#{a.company_name} - #{a.code}" } }
    }
  end

  # API endpoint for getting all agency codes (for Direct selection)
  def all_agency_codes
    agency_codes = AgencyCode.where(
      "insurance_type = ? OR insurance_type = ? OR insurance_type IS NULL",
      'Life Insurance', 'All'
    ).order(:agent_name, :code)

    render json: {
      success: true,
      agents: agency_codes.map { |a| {
        id: a.id,
        agent_name: a.agent_name,
        code: a.code,
        company_name: a.company_name
      } }
    }
  end

  # API endpoint for getting all brokers (for Broking selection)
  def all_brokers
    brokers = Broker.active.order(:name)

    render json: {
      brokers: brokers.map { |b| { id: b.id, name: b.name } }
    }
  end

  # API endpoint for getting customer family members for policy holder options
  def customer_family_members
    customer_id = params[:customer_id]

    if customer_id.present?
      begin
        customer = Customer.find(customer_id)
        family_members = customer.family_members.includes(:customer)

        # Build policy holder options
        policy_holder_options = [{ value: 'Self', text: 'Self' }]

        family_members.each do |member|
          # Only add if member has a valid name and it's not empty/numeric only
          if member.name.present? && member.name.strip.length > 0 && !member.name.strip.match?(/^\d+$/)
            display_name = "#{member.name} (#{member.relationship.humanize})"
            # Use name as value, display name as text - this ensures the database stores just the name
            policy_holder_options << {
              value: member.name,
              text: display_name
            }
          end
        end

        render json: {
          success: true,
          options: policy_holder_options,
          customer_name: customer.display_name
        }
      rescue ActiveRecord::RecordNotFound
        render json: {
          success: false,
          message: 'Customer not found',
          options: [{ value: 'Self', text: 'Self' }]
        }
      end
    else
      render json: {
        success: false,
        message: 'Customer ID is required',
        options: [{ value: 'Self', text: 'Self' }]
      }
    end
  end

  # GET /admin/insurance/life/:id/renew
  def renew
    # Check if policy expires within 60 days
    if @life_insurance.policy_end_date.blank? || @life_insurance.policy_end_date > 60.days.from_now
      redirect_to admin_life_insurances_path, alert: "This policy is not eligible for renewal yet."
      return
    end

    # Create a new life insurance object with pre-filled data from the original policy
    @renewed_policy = @life_insurance.dup

    # Clear fields that should be reset for renewal
    @renewed_policy.policy_number = nil
    @renewed_policy.policy_booking_date = nil
    @renewed_policy.policy_start_date = nil
    @renewed_policy.policy_end_date = nil
    @renewed_policy.risk_start_date = nil
    @renewed_policy.policy_type = 'Renewal'
    @renewed_policy.created_at = nil
    @renewed_policy.updated_at = nil
    @renewed_policy.id = nil

    # Set default dates for renewal
    @renewed_policy.policy_booking_date = Date.current
    @renewed_policy.policy_start_date = @life_insurance.policy_end_date + 1.day
    @renewed_policy.policy_end_date = @renewed_policy.policy_start_date + 1.year
    @renewed_policy.risk_start_date = @renewed_policy.policy_start_date

    # Store original policy for reference
    @original_policy = @life_insurance

    # Get available options for dropdowns
    set_form_data

    # Load customer family members for policy holder dropdown
    if @renewed_policy.customer_id.present?
      @customer_family_members = Customer.find(@renewed_policy.customer_id).family_members.includes(:customer)
    else
      @customer_family_members = []
    end

    # Ensure distributor is set for affiliate
    set_distributor_from_affiliate(@renewed_policy)
  end

  # POST /admin/insurance/life/:id/create_renewal
  def create_renewal
    # Check if policy expires within 60 days
    if @life_insurance.policy_end_date.blank? || @life_insurance.policy_end_date > 60.days.from_now
      redirect_to admin_life_insurances_path, alert: "This policy is not eligible for renewal yet."
      return
    end

    # Create new policy with renewal data
    processed_params = process_broker_params(life_insurance_params)
    @renewed_policy = LifeInsurance.new(processed_params)
    @renewed_policy.policy_type = 'Renewal'

    # Set admin added flags for renewal (same as original)
    @renewed_policy.is_admin_added = @life_insurance.is_admin_added
    @renewed_policy.is_customer_added = @life_insurance.is_customer_added
    @renewed_policy.is_agent_added = @life_insurance.is_agent_added

    # Ensure distributor is set from affiliate before saving
    set_distributor_from_affiliate(@renewed_policy)

    if @renewed_policy.save
      # Set renewal relationships
      @renewed_policy.update!(original_policy_id: @life_insurance.id)
      @life_insurance.update!(renewal_policy_id: @renewed_policy.id, is_renewed: true)

      # Update commission calculations (if needed for other fields)
      set_distributor_from_affiliate(@renewed_policy)
      redirect_to admin_life_insurance_path(@renewed_policy),
                  notice: "Life insurance policy renewed successfully! New Policy ID: #{@renewed_policy.policy_number}"
    else
      @original_policy = @life_insurance
      set_form_data

      # Load customer family members for policy holder dropdown on error
      if @renewed_policy.customer_id.present?
        @customer_family_members = Customer.find(@renewed_policy.customer_id).family_members.includes(:customer)
      else
        @customer_family_members = []
      end

      render :renew, status: :unprocessable_entity
    end
  end

  # API endpoints for dynamic dropdowns
  def agency_codes_for_broker_type
    broker_type = params[:broker_type]

    if broker_type == 'direct'
      # Load agency codes for Life Insurance
      agency_codes = AgencyCode.where(insurance_type: 'Life Insurance')
                               .select(:id, :agent_name, :code, :company_name)

      render json: {
        success: true,
        data: agency_codes.map { |ac|
          {
            id: ac.id,
            text: "#{ac.agent_name} (#{ac.code})",
            company_name: ac.company_name
          }
        }
      }
    elsif broker_type == 'broking'
      # Load broker codes with associated broker info
      broker_codes = BrokerCode.includes(:broker).active

      render json: {
        success: true,
        data: broker_codes.map { |bc|
          {
            id: "broker_#{bc.broker_id}",
            text: "#{bc.broker.name} (#{bc.broker_code})",
            broker_id: bc.broker_id
          }
        }
      }
    else
      render json: { success: false, message: 'Invalid broker type' }
    end
  end

  def insurance_companies_for_type
    # Get life insurance companies from model constant
    begin
      companies = LifeInsurance.life_insurance_companies.map { |company| company[:name] || company['name'] }
    rescue => e
      Rails.logger.error "Error loading life insurance companies: #{e.message}"
      companies = [
        'ICICI Prudential Life Insurance Co Ltd',
        'SBI Life Insurance Co Ltd',
        'LIC India',
        'HDFC Standard Life Insurance Co Ltd',
        'Max Life Insurance Co Ltd',
        'Bajaj Allianz Life Insurance Co Ltd'
      ]
    end

    render json: {
      success: true,
      data: companies.sort_by(&:downcase).map { |name| { id: name, text: name } }
    }
  end

  # API endpoint to load customer nominees for auto-population
  def load_customer_nominees
    customer_id = params[:customer_id]

    if customer_id.present?
      begin
        customer = Customer.find(customer_id)
        family_members = customer.family_members.includes(:customer)

        # Build nominee options from family members
        nominee_options = []

        family_members.each do |member|
          if member.name.present? && member.name.strip.length > 0 && !member.name.strip.match?(/^\d+$/)
            nominee_options << {
              nominee_name: member.name,
              relationship: member.relationship&.downcase || 'other',
              age: member.age || 0
            }
          end
        end

        render json: {
          success: true,
          nominees: nominee_options,
          customer_name: customer.display_name
        }
      rescue ActiveRecord::RecordNotFound
        render json: {
          success: false,
          message: 'Customer not found',
          nominees: []
        }
      end
    else
      render json: {
        success: false,
        message: 'Customer ID is required',
        nominees: []
      }
    end
  end

  private

  def set_life_insurance
    @life_insurance = LifeInsurance.find(params[:id])
  end

  def set_form_data
    @customers = Customer.active.order(:first_name, :last_name, :company_name)
    @sub_agents = SubAgent.active.order(:first_name, :last_name)
    @distributors = Distributor.active.order(:first_name, :last_name)
    @investors = Investor.active.order(:first_name, :last_name)

    # Load agency codes for Life Insurance (include both specific and general codes)
    @agency_codes = AgencyCode.where(
      "insurance_type = ? OR insurance_type = ? OR insurance_type IS NULL",
      'Life Insurance', 'All'
    ).order(:agent_name, :code)

    # Load brokers if needed
    @brokers = Broker.active.order(:name)

    # Load life insurance companies from the database
    begin
      # Get life insurance companies from the InsuranceCompany model
      @insurance_companies = InsuranceCompany.where("name ILIKE ?", "%life%")
                                           .or(InsuranceCompany.where("name ILIKE ?", "%LIC%"))
                                           .distinct
                                           .order(:name)
                                           .pluck(:name)

      # Fallback to constants if database is empty
      if @insurance_companies.empty?
        @insurance_companies = LifeInsurance.life_insurance_companies.map { |company| company[:name] || company['name'] }.sort
      end

      # Ensure current life insurance company is in the options (for edit forms)
      if defined?(@life_insurance) && @life_insurance&.insurance_company_name.present?
        unless @insurance_companies.include?(@life_insurance.insurance_company_name)
          @insurance_companies << @life_insurance.insurance_company_name
          @insurance_companies.sort!
        end
      end
    rescue => e
      Rails.logger.error "Error loading life insurance companies: #{e.message}"
      @insurance_companies = [
        'ICICI Prudential Life Insurance Co Ltd',
        'SBI Life Insurance Co Ltd',
        'LIC India',
        'HDFC Standard Life Insurance Co Ltd',
        'Max Life Insurance Co Ltd',
        'Bajaj Allianz Life Insurance Co Ltd'
      ]
    end

    @policy_types = LifeInsurance::POLICY_TYPES
    @payment_modes = LifeInsurance::PAYMENT_MODES
    @relationships = LifeInsurance::RELATIONSHIPS
    @account_types = LifeInsurance::ACCOUNT_TYPES
    @document_types = LifeInsurance::DOCUMENT_TYPES
  end

  def preserve_form_state_on_error
    # Load customer family members if a customer was selected
    if @life_insurance.customer_id.present?
      begin
        customer = Customer.find(@life_insurance.customer_id)
        @customer_family_members = customer.family_members.includes(:customer)
        @selected_customer = customer
      rescue ActiveRecord::RecordNotFound
        @customer_family_members = []
        @selected_customer = nil
      end
    else
      @customer_family_members = []
      @selected_customer = nil
    end

    # Set affiliate selection state for Select2 dropdown
    if @life_insurance.sub_agent_id.present?
      @auto_select_affiliate = @life_insurance.sub_agent_id
    else
      @auto_select_affiliate = 'self'
    end

    # Set flag to preserve form state in JavaScript
    @has_validation_errors = @life_insurance.errors.any?
    @preserve_selections = true

    # For broking type policies, determine the correct agency_code selection
    # Since we store broker_id but the form expects broker_X format for broking
    if @life_insurance.broker_code_type == 'broking' && @life_insurance.broker_id.present?
      # Find the broker code that matches this broker
      broker_code = BrokerCode.find_by(broker_id: @life_insurance.broker_id)
      if broker_code
        @selected_broker_code = "broker_#{broker_code.id}"
      end
    end

    # Store selected values for JavaScript to use
    @selected_values = {
      customer_id: @life_insurance.customer_id,
      sub_agent_id: @life_insurance.sub_agent_id,
      policy_holder: @life_insurance.policy_holder,
      broker_code_type: @life_insurance.broker_code_type,
      agency_code_id: @life_insurance.broker_code_type == 'broking' ? @selected_broker_code : @life_insurance.agency_code_id,
      insurance_company_name: @life_insurance.insurance_company_name,
      selected_broker_code: @selected_broker_code
    }
  end

  def process_broker_params(params)
    # Handle agency_code_id when it contains broker_X format
    if params[:agency_code_id].present? && params[:agency_code_id].start_with?('broker_')
      # Extract broker code ID from broker_X format
      broker_code_id = params[:agency_code_id].gsub('broker_', '').to_i

      # Find the broker code and set the actual broker_id
      if broker_code_id > 0
        broker_code = BrokerCode.find_by(id: broker_code_id)
        if broker_code
          params[:broker_id] = broker_code.broker_id
          params[:agency_code_id] = nil
          Rails.logger.info "Processed broker_#{broker_code_id} -> broker_id: #{broker_code.broker_id} (#{broker_code.broker.name})"
        else
          Rails.logger.warn "BrokerCode with ID #{broker_code_id} not found"
          params[:broker_id] = nil
          params[:agency_code_id] = nil
        end
      end
    end

    params
  end

  def life_insurance_params
    params.require(:life_insurance).permit(
      :customer_id, :sub_agent_id, :distributor_id, :agency_code_id, :broker_id, :broker_code_type,
      :policy_holder, :insured_name, :insurance_company_name, :policy_type,
      :payment_mode, :policy_number, :policy_booking_date, :policy_start_date,
      :policy_end_date, :risk_start_date, :policy_term, :premium_payment_term,
      :plan_name, :sum_insured, :sum_insured_text, :net_premium, :first_year_gst_percentage,
      :second_year_gst_percentage, :third_year_gst_percentage, :total_premium,
      :nominee_name, :nominee_relationship, :nominee_age, :bank_name,
      :account_type, :account_number, :ifsc_code, :account_holder_name,
      :reference_by_name, :broker_name, :bonus, :fund, :extra_note,
      :main_agent_commission_percentage, :commission_amount, :tds_percentage,
      :tds_amount, :after_tds_value, :installment_autopay_start_date,
      :installment_autopay_end_date, :active,
      # Renewal tracking fields
      :original_policy_id, :renewal_policy_id, :is_renewed,
      # New commission fields - All commission details
      :sub_agent_commission_percentage, :sub_agent_commission_amount, :sub_agent_tds_percentage, :sub_agent_tds_amount, :sub_agent_after_tds_value,
      :distributor_commission_percentage, :distributor_commission_amount, :distributor_tds_percentage, :distributor_tds_amount, :distributor_after_tds_value,
      :ambassador_commission_percentage, :ambassador_commission_amount, :ambassador_tds_percentage, :ambassador_tds_amount, :ambassador_after_tds_value,
      :investor_commission_percentage, :investor_commission_amount, :investor_tds_percentage, :investor_tds_amount, :investor_after_tds_value,
      :main_income_percentage, :main_income_amount,
      # Company expenses and profit fields
      :company_expenses_percentage, :company_expenses_amount, :total_distribution_percentage,
      :profit_percentage, :profit_amount,
      policy_documents: [], documents: [],
      uploaded_documents_attributes: [:id, :title, :description, :document_type, :file, :uploaded_by, :_destroy]
    )
  end

  def set_distributor_from_affiliate(insurance_record)
    # If affiliate is selected but distributor is not set, auto-assign distributor
    if insurance_record.sub_agent_id.present? && insurance_record.distributor_id.blank?
      sub_agent = SubAgent.find_by(id: insurance_record.sub_agent_id)

      if sub_agent
        # Use direct distributor relationship first, then fall back to assignment
        distributor_id = sub_agent.distributor_id || sub_agent.assigned_distributor&.id

        if distributor_id.present?
          insurance_record.distributor_id = distributor_id
          Rails.logger.info "Set distributor_id #{distributor_id} from sub_agent #{sub_agent.id}"
        else
          Rails.logger.warn "No distributor found for sub_agent #{sub_agent.id} (#{sub_agent.display_name})"
          # If no distributor is found, use a default one or the first active distributor
          default_distributor = Distributor.active.first
          if default_distributor
            insurance_record.distributor_id = default_distributor.id
            Rails.logger.info "Using default distributor #{default_distributor.id} for sub_agent #{sub_agent.id}"
          else
            Rails.logger.error "No active distributors found in the system"
          end
        end
      else
        Rails.logger.error "SubAgent with id #{insurance_record.sub_agent_id} not found"
      end
    end
  rescue StandardError => e
    # Log error but don't fail the form submission
    Rails.logger.error "Failed to set distributor from affiliate: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end

  def calculate_tab_statistics
    # Calculate statistics for all DrWise policies
    drwise_policies = LifeInsurance.where(
      is_admin_added: true,
      is_customer_added: false,
      is_agent_added: false
    )

    @drwise_count = drwise_policies.count
    @drwise_premium = drwise_policies.sum(:total_premium) || 0
    @drwise_coverage = drwise_policies.sum(:sum_insured) || 0

    # Calculate statistics for all Non-DrWise policies
    non_drwise_policies = LifeInsurance.where(
      '(is_customer_added = ? AND is_admin_added = ? AND is_agent_added = ?) OR (is_agent_added = ? AND is_customer_added = ? AND is_admin_added = ?)',
      true, false, false, true, false, false
    )

    @non_drwise_count = non_drwise_policies.count
    @non_drwise_premium = non_drwise_policies.sum(:total_premium) || 0
    @non_drwise_coverage = non_drwise_policies.sum(:sum_insured) || 0

    # Set current tab statistics
    if @current_tab == 'drwise'
      @total_policies_count = @drwise_count
      @total_premium_amount = @drwise_premium
      @total_coverage_amount = @drwise_coverage
      @covered_lives_count = drwise_policies.joins(:customer).distinct.count('customers.id')
    else
      @total_policies_count = @non_drwise_count
      @total_premium_amount = @non_drwise_premium
      @total_coverage_amount = @non_drwise_coverage
      @covered_lives_count = non_drwise_policies.joins(:customer).distinct.count('customers.id')
    end
  end
end