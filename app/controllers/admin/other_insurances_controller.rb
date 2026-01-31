class Admin::OtherInsurancesController < Admin::ApplicationController
  before_action :set_other_insurance, only: [:show, :edit, :update, :destroy]
  before_action :load_form_data, only: [:new, :edit, :create, :update]
  skip_before_action :verify_authenticity_token, only: [:all_agency_codes, :all_brokers, :insurance_companies_for_type, :insurance_companies_by_agency]

  def index
    @other_insurances = OtherInsurance.includes(:customer)

    # Search functionality
    if params[:search].present?
      search_term = params[:search]
      @other_insurances = @other_insurances.joins(:customer).where(
        "other_insurances.policy_number ILIKE ? OR other_insurances.insurance_company_name ILIKE ? OR customers.first_name ILIKE ? OR customers.last_name ILIKE ? OR customers.company_name ILIKE ?",
        "%#{search_term}%", "%#{search_term}%", "%#{search_term}%", "%#{search_term}%", "%#{search_term}%"
      )
    end

    # Policy type filter
    if params[:policy_type].present?
      case params[:policy_type]
      when 'travel'
        @other_insurances = @other_insurances.where(insurance_type: 'Travel Insurance')
      when 'property'
        @other_insurances = @other_insurances.where(insurance_type: 'Property Insurance')
      when 'cyber'
        @other_insurances = @other_insurances.where(insurance_type: 'Cyber Insurance')
      when 'professional'
        @other_insurances = @other_insurances.where(insurance_type: 'Professional Indemnity')
      end
    end

    # Status filter (based on policy end date since there's no status column)
    if params[:status].present?
      case params[:status]
      when 'active'
        @other_insurances = @other_insurances.where('policy_end_date IS NULL OR policy_end_date >= ?', Date.current)
      when 'expired'
        @other_insurances = @other_insurances.where('policy_end_date < ?', Date.current)
      when 'pending'
        # For policies without end date or future start date
        @other_insurances = @other_insurances.where('policy_start_date > ?', Date.current)
      end
    end

    @other_insurances = @other_insurances.order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def new
    @other_insurance = OtherInsurance.new

    # Pre-fill customer data if coming from customer page
    if params[:customer_id].present?
      @selected_customer = Customer.find(params[:customer_id])
      @other_insurance.customer_id = @selected_customer.id

      # Load family members for policy holder dropdown
      @customer_family_members = @selected_customer.family_members if @selected_customer

      # Auto-select affiliate based on customer
      @auto_select_affiliate = @selected_customer.sub_agent_id || 'self' if @selected_customer
    else
      @customer_family_members = []
    end
  end

  def edit
  end

  def create
    @other_insurance = OtherInsurance.new(other_insurance_params)

    # Log the parameters for debugging
    Rails.logger.info "Creating OtherInsurance with params: #{other_insurance_params.inspect}"

    # Set calculated fields
    calculate_commission_fields if @other_insurance.net_premium.present?

    if @other_insurance.save
      Rails.logger.info "Successfully created OtherInsurance ##{@other_insurance.id}"
      redirect_to admin_other_insurance_path(@other_insurance), notice: 'General insurance policy was successfully created.'
    else
      Rails.logger.error "Failed to create OtherInsurance: #{@other_insurance.errors.full_messages.join(', ')}"
      # Reload form data for re-rendering
      load_form_data
      @selected_customer = Customer.find(@other_insurance.customer_id) if @other_insurance.customer_id
      @customer_family_members = @selected_customer.family_members if @selected_customer
      render :new, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error "Exception in OtherInsurance#create: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    flash[:error] = "An error occurred: #{e.message}"
    redirect_to new_admin_other_insurance_path
  end

  def update
    if @other_insurance.update(other_insurance_params)
      redirect_to admin_other_insurance_path(@other_insurance), notice: 'Other insurance policy was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @other_insurance.destroy
    redirect_to admin_other_insurances_path, notice: 'Other insurance policy was successfully deleted.'
  end

  # API endpoint for getting all agency codes (for Direct selection)
  def all_agency_codes
    agency_codes = AgencyCode.where(insurance_type: ['Motor and Other Insurance', 'General Insurance', 'Other']).order(:agent_name, :code)
    render json: {
      agency_codes: agency_codes.map { |a| { id: a.id, name: "#{a.agent_name} - #{a.code}" } }
    }
  end

  # API endpoint for getting all brokers (for Broking selection)
  def all_brokers
    brokers = defined?(Broker) ? Broker.active.order(:name) : []
    render json: {
      brokers: brokers.map { |b| { id: b.id, name: b.name } }
    }
  end

  # API endpoint for getting insurance companies by type
  def insurance_companies_for_type
    insurance_type = params[:insurance_type] || 'General Insurance'

    # Get companies for general/other insurance
    companies = case insurance_type.downcase
    when 'general insurance', 'other'
      ['New India Assurance', 'Oriental Insurance', 'National Insurance', 'United India Insurance',
       'ICICI Lombard', 'Bajaj Allianz', 'Reliance General', 'Tata AIG', 'SBI General']
    else
      []
    end

    render json: {
      companies: companies.map { |c| { id: c, name: c } }
    }
  end

  # API endpoint for getting insurance companies by agency/broker selection
  def insurance_companies_by_agency
    agency_id = params[:agency_id]
    broker_code = params[:broker_code]

    companies_data = []

    case params[:broker_type]
    when 'direct'
      # For direct mode: Get company from selected agency
      if agency_id.present?
        agency = AgencyCode.find_by(id: agency_id)
        companies_data = [{
          id: agency&.insurance_company,
          text: agency&.insurance_company || 'Unknown Company'
        }]
      end

    when 'broking'
      # For broking mode: Return all general insurance companies
      general_companies = ['New India Assurance', 'Oriental Insurance', 'National Insurance',
                          'United India Insurance', 'ICICI Lombard', 'Bajaj Allianz',
                          'Reliance General', 'Tata AIG', 'SBI General']

      companies_data = general_companies.map { |name|
        { id: name, text: name }
      }
    end

    render json: {
      success: true,
      data: companies_data
    }
  end

  private

  def set_other_insurance
    @other_insurance = OtherInsurance.find(params[:id])
  end

  def load_form_data
    @customers = Customer.active.order(:first_name, :last_name, :company_name)
    @sub_agents = SubAgent.active.order(:first_name, :last_name)
    @distributors = Distributor.active.order(:first_name, :last_name)
    @investors = Investor.active.order(:first_name, :last_name)
    @agency_codes = AgencyCode.where(insurance_type: ['Motor and Other Insurance', 'General Insurance', 'Other']).order(:agent_name)
    @brokers = Broker.active.order(:name) if defined?(Broker)
    @insurance_companies = ['New India Assurance', 'Oriental Insurance', 'National Insurance', 'United India Insurance',
                           'ICICI Lombard', 'Bajaj Allianz', 'Reliance General', 'Tata AIG', 'SBI General']

    # Load customer family members if customer is selected
    if @other_insurance&.customer_id.present?
      @selected_customer = Customer.find(@other_insurance.customer_id)
      @customer_family_members = @selected_customer.family_members
      @auto_select_affiliate = @selected_customer.sub_agent_id || 'self'
    else
      @customer_family_members = []
    end
  end

  def other_insurance_params
    params.require(:other_insurance).permit(
      :customer_id, :policy_holder, :sub_agent_id, :broker_code_type, :agency_code_id,
      :broker_id, :insurance_company_name, :policy_type, :insurance_type, :payment_mode,
      :policy_number, :policy_booking_date, :policy_start_date, :policy_end_date,
      :plan_name, :sum_insured, :net_premium, :gst_percentage, :total_premium,
      :policy_term, :claim_process,
      :main_agent_commission_percentage, :commission_amount, :tds_percentage,
      :tds_amount, :after_tds_value,
      :sub_agent_commission_percentage, :sub_agent_commission_amount,
      :sub_agent_tds_percentage, :sub_agent_tds_amount, :sub_agent_after_tds_value,
      :investor_commission_percentage, :investor_commission_amount,
      :investor_tds_percentage, :investor_tds_amount, :investor_after_tds_value,
      :ambassador_commission_percentage, :ambassador_commission_amount,
      :ambassador_tds_percentage, :ambassador_tds_amount, :ambassador_after_tds_value,
      :company_expenses_percentage, :total_distribution_percentage,
      :profit_percentage, :profit_amount,
      :installment_autopay_start_date, :installment_autopay_end_date,
      policy_documents: [], additional_documents: []
    )
  end

  def calculate_commission_fields
    return unless @other_insurance.net_premium.present?

    net_premium = @other_insurance.net_premium

    # Calculate main agent commission
    if @other_insurance.main_agent_commission_percentage.present?
      @other_insurance.commission_amount = (net_premium * @other_insurance.main_agent_commission_percentage) / 100

      if @other_insurance.tds_percentage.present?
        @other_insurance.tds_amount = (@other_insurance.commission_amount * @other_insurance.tds_percentage) / 100
        @other_insurance.after_tds_value = @other_insurance.commission_amount - @other_insurance.tds_amount
      end
    end

    # Similar calculations for other commissions can be added here
  end

end
