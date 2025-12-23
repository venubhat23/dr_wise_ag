class Admin::CustomersController < Admin::ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy, :policy_chart, :trace_commission]

  # GET /admin/customers
  def index
    # Check if policies_count column exists for optimized queries
    has_counter_cache = Customer.column_names.include?('policies_count')

    # Check if search is active first
    search_active = params[:search].present? && params[:search].strip.length >= 4

    if search_active
      # When search is active, use simpler query without select optimization to avoid pg_search conflicts
      @customers = Customer.all
    else
      # Use standard query and rely on counter cache for policy counts
      @customers = Customer.all
    end

    # Search functionality - only search if 4+ characters or empty
    if params[:search].present?
      search_term = params[:search].strip
      if search_term.length >= 4
        @customers = @customers.search_customers(search_term)
      elsif search_term.length > 0
        # Return empty result if search term is too short
        @customers = @customers.none
      end
    end

    # Filter by customer type
    if params[:customer_type].present?
      @customers = @customers.where(customer_type: params[:customer_type])
    end

    # Filter by status
    case params[:status]
    when 'active'
      @customers = @customers.where(status: true)
    when 'inactive'
      @customers = @customers.where(status: false)
    end

    # Order and paginate
    @customers = @customers.order(created_at: :desc).page(params[:page]).per(25)

    # Calculate statistics
    # Create a separate scope for statistics to avoid pg_search GROUP BY issues
    stats_scope = Customer.all

    # Apply filters but handle search differently for stats
    if params[:search].present? && params[:search].strip.length >= 4
      # For statistics, use a simple where clause instead of pg_search to avoid GROUP BY issues
      search_term = params[:search].strip
      stats_scope = stats_scope.where(
        "first_name ILIKE ? OR last_name ILIKE ? OR company_name ILIKE ? OR email ILIKE ? OR mobile ILIKE ? OR pan_number ILIKE ?",
        "%#{search_term}%", "%#{search_term}%", "%#{search_term}%", "%#{search_term}%", "%#{search_term}%", "%#{search_term}%"
      )
    end

    if params[:customer_type].present?
      stats_scope = stats_scope.where(customer_type: params[:customer_type])
    end

    case params[:status]
    when 'active'
      stats_scope = stats_scope.where(status: true)
    when 'inactive'
      stats_scope = stats_scope.where(status: false)
    end

    # Calculate filtered stats using simple queries to avoid GROUP BY issues
    @stats = if params[:search].present? && params[:search].strip.length >= 4
      # When search is active, use simpler aggregation
      {
        total_customers: stats_scope.count,
        active_customers: stats_scope.where(status: true).count,
        individual_customers: stats_scope.where(customer_type: 'individual').count,
        corporate_customers: stats_scope.where(customer_type: 'corporate').count
      }
    else
      # When no search, can use GROUP BY safely
      stats_data = stats_scope.group(:customer_type, :status).count
      stats_data.each_with_object(Hash.new(0)) do |(key, count), stats|
        customer_type, status = key

        stats[:total_customers] += count
        stats[:active_customers] += count if status == true
        stats[:individual_customers] += count if customer_type == 'individual'
        stats[:corporate_customers] += count if customer_type == 'corporate'
      end.tap do |stats|
        stats[:total_customers] = stats_scope.count if stats[:total_customers] == 0
      end
    end

    @total_customers = @stats[:total_customers]
    @active_customers = @stats[:active_customers]
    @individual_customers = @stats[:individual_customers]
    @corporate_customers = @stats[:corporate_customers]

    # Handle AJAX requests
    respond_to do |format|
      format.html # Regular HTML request
      format.json { render json: { customers: @customers, stats: @stats } }
    end
  end

  # GET /admin/customers/1
  def show
    @family_members = @customer.family_members.order(:created_at)
    @policies = @customer.policies.includes(:insurance_company).order(created_at: :desc)
  end

  # GET /admin/customers/:id/policy_chart
  def policy_chart
    # Get all policy types and their status for this customer
    @policy_status = {
      'Health Insurance' => {
        exists: HealthInsurance.exists?(customer_id: @customer.id),
        count: HealthInsurance.where(customer_id: @customer.id).count,
        icon: 'bi-heart-pulse',
        color: 'info',
        policies: HealthInsurance.where(customer_id: @customer.id).includes(:customer)
      },
      'Life Insurance' => {
        exists: LifeInsurance.exists?(customer_id: @customer.id),
        count: LifeInsurance.where(customer_id: @customer.id).count,
        icon: 'bi-shield-check',
        color: 'primary',
        policies: LifeInsurance.where(customer_id: @customer.id).includes(:customer)
      },
      'Motor Insurance' => {
        exists: MotorInsurance.exists?(customer_id: @customer.id),
        count: MotorInsurance.where(customer_id: @customer.id).count,
        icon: 'bi-car-front',
        color: 'warning',
        policies: MotorInsurance.where(customer_id: @customer.id).includes(:customer)
      },
      'Other Insurance' => {
        exists: defined?(OtherInsurance) && OtherInsurance.exists?(customer_id: @customer.id),
        count: defined?(OtherInsurance) ? OtherInsurance.where(customer_id: @customer.id).count : 0,
        icon: 'bi-grid-3x3',
        color: 'secondary',
        policies: defined?(OtherInsurance) ? OtherInsurance.where(customer_id: @customer.id).includes(:customer) : []
      }
    }

    # Calculate totals
    @total_policies = @policy_status.values.sum { |policy| policy[:count] }
    @policy_types_with_coverage = @policy_status.count { |_, policy| policy[:exists] }
    @coverage_percentage = @policy_types_with_coverage > 0 ? (@policy_types_with_coverage.to_f / @policy_status.keys.count * 100).round(1) : 0
  end

  # GET /admin/customers/:id/trace_commission
  def trace_commission
    # Get all policy types and their status for this customer
    @policy_status = {
      'Health Insurance' => {
        opted: HealthInsurance.exists?(customer_id: @customer.id),
        count: HealthInsurance.where(customer_id: @customer.id).count,
        icon: 'bi-heart-pulse',
        color: 'success',
        policies: HealthInsurance.where(customer_id: @customer.id),
        total_premium: HealthInsurance.where(customer_id: @customer.id).sum(:total_premium) || 0,
        latest_policy: HealthInsurance.where(customer_id: @customer.id).order(:created_at).last
      },
      'Life Insurance' => {
        opted: LifeInsurance.exists?(customer_id: @customer.id),
        count: LifeInsurance.where(customer_id: @customer.id).count,
        icon: 'bi-shield-check',
        color: 'primary',
        policies: LifeInsurance.where(customer_id: @customer.id),
        total_premium: LifeInsurance.where(customer_id: @customer.id).sum(:total_premium) || 0,
        latest_policy: LifeInsurance.where(customer_id: @customer.id).order(:created_at).last
      },
      'Motor Insurance' => {
        opted: MotorInsurance.exists?(customer_id: @customer.id),
        count: MotorInsurance.where(customer_id: @customer.id).count,
        icon: 'bi-car-front',
        color: 'warning',
        policies: MotorInsurance.where(customer_id: @customer.id),
        total_premium: MotorInsurance.where(customer_id: @customer.id).sum(:total_premium) || 0,
        latest_policy: MotorInsurance.where(customer_id: @customer.id).order(:created_at).last
      }
    }

    # Get comprehensive product status (handling cases where tables might not exist yet)
    @product_status = {}

    # Insurance Products
    @product_status['Life'] = @policy_status['Life Insurance'][:opted]
    @product_status['Health'] = @policy_status['Health Insurance'][:opted]
    @product_status['Motor'] = @policy_status['Motor Insurance'][:opted]
    @product_status['General'] = false # Placeholder for General Insurance
    @product_status['Travel Insurance'] = false # Placeholder for Travel Insurance

    # Investment Products (check if tables exist)
    begin
      @product_status['Mutual Fund'] = @customer.respond_to?(:investments) ?
        @customer.investments.where(investment_type: 'Mutual Fund').exists? : false
      @product_status['Gold'] = @customer.respond_to?(:investments) ?
        @customer.investments.where(investment_type: 'Gold').exists? : false
      @product_status['NPS'] = @customer.respond_to?(:investments) ?
        @customer.investments.where(investment_type: 'NPS').exists? : false
      @product_status['Bonds'] = @customer.respond_to?(:investments) ?
        @customer.investments.where(investment_type: 'Bonds').exists? : false
    rescue
      @product_status['Mutual Fund'] = false
      @product_status['Gold'] = false
      @product_status['NPS'] = false
      @product_status['Bonds'] = false
    end

    # Loan Products
    begin
      @product_status['Personal'] = @customer.respond_to?(:loans) ?
        @customer.loans.where(loan_type: 'Personal').exists? : false
      @product_status['Home'] = @customer.respond_to?(:loans) ?
        @customer.loans.where(loan_type: 'Home').exists? : false
      @product_status['Business'] = @customer.respond_to?(:loans) ?
        @customer.loans.where(loan_type: 'Business').exists? : false
    rescue
      @product_status['Personal'] = false
      @product_status['Home'] = false
      @product_status['Business'] = false
    end

    # Tax Services
    begin
      @product_status['ITR'] = @customer.respond_to?(:tax_services) ?
        @customer.tax_services.where(service_type: 'ITR Filing').exists? : false
    rescue
      @product_status['ITR'] = false
    end

    # Travel Services
    begin
      @product_status['Domestic'] = @customer.respond_to?(:travel_packages) ?
        @customer.travel_packages.where(travel_type: 'Domestic').exists? : false
      @product_status['International'] = @customer.respond_to?(:travel_packages) ?
        @customer.travel_packages.where(travel_type: 'International').exists? : false
    rescue
      @product_status['Domestic'] = false
      @product_status['International'] = false
    end

    # Additional placeholder products for future expansion
    @product_status['Additional 1'] = false
    @product_status['Additional 2'] = false

    # Calculate comprehensive commission data based on all 17 products
    total_policies = 0
    total_premium = 0
    opted_count = @product_status.values.count(true)

    # Count actual policies and premiums from existing insurance types
    total_policies += @policy_status.values.sum { |policy| policy[:count] }
    total_premium += @policy_status.values.sum { |policy| policy[:total_premium] }

    # Add counts from other product types (when they have data)
    begin
      if @customer.respond_to?(:investments)
        total_policies += @customer.investments.count
        total_premium += @customer.investments.sum(:investment_amount) || 0
      end

      if @customer.respond_to?(:loans)
        total_policies += @customer.loans.count
        total_premium += @customer.loans.sum(:loan_amount) || 0
      end

      if @customer.respond_to?(:tax_services)
        total_policies += @customer.tax_services.count
        total_premium += @customer.tax_services.sum(:amount) || 0
      end

      if @customer.respond_to?(:travel_packages)
        total_policies += @customer.travel_packages.count
        total_premium += @customer.travel_packages.sum(:package_amount) || 0
      end
    rescue
      # Handle cases where tables don't exist yet
    end

    @commission_summary = {
      total_premium: total_premium,
      total_policies: total_policies,
      opted_count: opted_count,
      total_products: 17, # Total number of product types available
      coverage_percentage: (opted_count.to_f / 17 * 100).round(1)
    }

    # Get commission payouts for this customer's policies
    @commission_payouts = CommissionPayout.joins(
      "LEFT JOIN health_insurances ON commission_payouts.policy_type = 'health' AND commission_payouts.policy_id = health_insurances.id
       LEFT JOIN life_insurances ON commission_payouts.policy_type = 'life' AND commission_payouts.policy_id = life_insurances.id
       LEFT JOIN motor_insurances ON commission_payouts.policy_type = 'motor' AND commission_payouts.policy_id = motor_insurances.id"
    ).where(
      "(commission_payouts.policy_type = 'health' AND health_insurances.customer_id = ?) OR
       (commission_payouts.policy_type = 'life' AND life_insurances.customer_id = ?) OR
       (commission_payouts.policy_type = 'motor' AND motor_insurances.customer_id = ?)",
      @customer.id, @customer.id, @customer.id
    ).includes(:payout_audit_logs)
  end

  # GET /admin/customers/new
  def new
    @customer = Customer.new
    @customer.status = true
    @customer.sub_agent = "Self"
  end

  # GET /admin/customers/1/edit
  def edit
  end

  # POST /admin/customers
  def create
    @customer = Customer.new(customer_params)

    # Handle password creation if provided
    password = params[:customer][:password]
    password_confirmation = params[:customer][:password_confirmation]

    begin
      ActiveRecord::Base.transaction do
        if @customer.save
          # Create User account if password is provided
          if password.present? && password_confirmation.present?
            if password == password_confirmation
              User.create!(
                first_name: @customer.first_name,
                last_name: @customer.last_name || @customer.company_name,
                email: @customer.email,
                mobile: @customer.mobile,
                password: password,
                password_confirmation: password_confirmation,
                user_type: 'customer',
                status: true
              )
              redirect_to admin_customer_path(@customer), notice: 'Customer and login account created successfully.'
            else
              @customer.destroy
              @customer.errors.add(:password_confirmation, "doesn't match Password")
              render :new, status: :unprocessable_entity
              return
            end
          else
            redirect_to admin_customer_path(@customer), notice: 'Customer was successfully created.'
          end
        else
          render :new, status: :unprocessable_entity
        end
      end
    rescue => e
      @customer.errors.add(:base, "Failed to create login account: #{e.message}")
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/customers/1
  def update
    if @customer.update(customer_params)
      redirect_to admin_customer_path(@customer), notice: 'Customer was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/customers/1
  def destroy
    if @customer.policies.exists?
      redirect_to admin_customers_path, alert: 'Cannot delete customer with existing policies.'
    else
      @customer.destroy
      redirect_to admin_customers_path, notice: 'Customer was successfully deleted.'
    end
  end

  # PATCH /admin/customers/1/toggle_status
  def toggle_status
    @customer.update(status: !@customer.status)
    status_text = @customer.status? ? 'activated' : 'deactivated'
    redirect_to admin_customers_path, notice: "Customer was successfully #{status_text}."
  end

  # GET /admin/customers/export
  def export
    @customers = Customer.includes(:policies)

    # Apply same filters as index
    if params[:search].present?
      @customers = @customers.search_customers(params[:search])
    end

    if params[:customer_type].present?
      @customers = @customers.where(customer_type: params[:customer_type])
    end

    case params[:status]
    when 'active'
      @customers = @customers.active
    when 'inactive'
      @customers = @customers.inactive
    end

    @customers = @customers.order(:created_at)

    respond_to do |format|
      format.csv do
        send_data generate_customers_csv(@customers), filename: "customers_#{Date.current}.csv"
      end
      # format.xlsx do
      #   send_data generate_customers_xlsx(@customers), filename: "customers_#{Date.current}.xlsx"
      # end
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(
      :customer_type, :first_name, :middle_name, :last_name, :company_name, :email, :mobile,
      :address, :state, :city, :pincode, :pan_no, :gst_no, :birth_date,
      :gender, :occupation, :annual_income, :nominee_name, :nominee_relation,
      :nominee_date_of_birth, :status, :birth_place, :height_feet, :weight_kg, :education,
      :marital_status, :business_job, :business_name, :type_of_duty, :additional_information,
      :added_by, :sub_agent, :age,
      profile_image: [],
      documents_attributes: [:id, :document_type, :file, :_destroy],
      family_members_attributes: [
        :id, :first_name, :middle_name, :last_name, :birth_date, :age, :height_feet, :weight_kg,
        :gender, :relationship, :pan_no, :mobile, :additional_information, :_destroy,
        documents_attributes: [:id, :document_type, :file, :_destroy]
      ],
      corporate_members_attributes: [
        :id, :company_name, :mobile, :email, :state, :city, :address, :annual_income,
        :pan_no, :gst_no, :additional_information, :_destroy,
        documents_attributes: [:id, :document_type, :file, :_destroy]
      ]
    )
  end

  def generate_customers_csv(customers)
    require 'csv'

    CSV.generate(headers: true) do |csv|
      csv << %w[
        ID CustomerType FirstName LastName CompanyName Email Mobile
        Address State City Pincode BirthDate Gender Height Weight
        Education MaritalStatus Occupation JobName TypeOfDuty AnnualIncome
        PANNumber GSTNumber BirthPlace NomineeName NomineeRelation
        NomineeDOB Status AddedBy CreatedAt
      ]

      customers.find_each do |customer|
        csv << [
          customer.id,
          customer.customer_type&.humanize,
          customer.first_name,
          customer.last_name,
          customer.company_name,
          customer.email,
          customer.mobile,
          customer.address,
          customer.state,
          customer.city,
          customer.pincode,
          customer.birth_date,
          customer.gender&.humanize,
          customer.height,
          customer.weight,
          customer.education,
          customer.marital_status&.humanize,
          customer.occupation,
          customer.job_name,
          customer.type_of_duty,
          customer.annual_income,
          customer.pan_number,
          customer.gst_number,
          customer.birth_place,
          customer.nominee_name,
          customer.nominee_relation,
          customer.nominee_date_of_birth,
          customer.status? ? 'Active' : 'Inactive',
          customer.added_by&.humanize,
          customer.created_at.strftime('%Y-%m-%d %H:%M:%S')
        ]
      end
    end
  end

  def generate_customers_xlsx(customers)
    require 'rubyXL'

    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]
    worksheet.sheet_name = 'Customers'

    # Headers
    headers = %w[
      ID CustomerType FirstName LastName CompanyName Email Mobile
      Address State City Pincode BirthDate Gender Height Weight
      Education MaritalStatus Occupation JobName TypeOfDuty AnnualIncome
      PANNumber GSTNumber BirthPlace NomineeName NomineeRelation
      NomineeDOB Status AddedBy CreatedAt
    ]

    headers.each_with_index do |header, index|
      worksheet.add_cell(0, index, header)
      worksheet.sheet_data[0][index].change_font_bold(true)
    end

    # Data rows
    customers.each_with_index do |customer, row_index|
      row = row_index + 1
      data = [
        customer.id,
        customer.customer_type&.humanize,
        customer.first_name,
        customer.last_name,
        customer.company_name,
        customer.email,
        customer.mobile,
        customer.address,
        customer.state,
        customer.city,
        customer.pincode,
        customer.birth_date,
        customer.gender&.humanize,
        customer.height,
        customer.weight,
        customer.education,
        customer.marital_status&.humanize,
        customer.occupation,
        customer.job_name,
        customer.type_of_duty,
        customer.annual_income,
        customer.pan_number,
        customer.gst_number,
        customer.birth_place,
        customer.nominee_name,
        customer.nominee_relation,
        customer.nominee_date_of_birth,
        customer.status? ? 'Active' : 'Inactive',
        customer.added_by&.humanize,
        customer.created_at.strftime('%Y-%m-%d %H:%M:%S')
      ]

      data.each_with_index do |value, col_index|
        worksheet.add_cell(row, col_index, value)
      end
    end

    workbook.stream.string
  end
end