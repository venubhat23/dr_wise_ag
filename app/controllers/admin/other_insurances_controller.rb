class Admin::OtherInsurancesController < Admin::ApplicationController
  before_action :set_other_insurance, only: [:show, :edit, :update, :destroy, :renew, :create_renewal]
  before_action :load_form_data, only: [:new, :edit, :create, :update, :renew]
  skip_before_action :verify_authenticity_token, only: [:all_agency_codes, :all_brokers, :insurance_companies_for_type, :insurance_companies_by_agency]

  def index
    @current_tab = params[:tab] || 'drwise'

    # Base query
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

    # Tab-based filtering using DrWise/Non-DrWise classification
    if @current_tab == 'drwise'
      @other_insurances = @other_insurances.where(
        is_admin_added: true,
        is_customer_added: false,
        is_agent_added: false
      )
    else
      @other_insurances = @other_insurances.where(
        '(is_customer_added = ? AND is_admin_added = ? AND is_agent_added = ?) OR (is_agent_added = ? AND is_customer_added = ? AND is_admin_added = ?)',
        true, false, false, true, false, false
      )
    end

    # Add counters for tabs based on DrWise/Non-DrWise classification
    @drwise_count = OtherInsurance.where(
      is_admin_added: true,
      is_customer_added: false,
      is_agent_added: false
    ).count
    @non_drwise_count = OtherInsurance.where(
      '(is_customer_added = ? AND is_admin_added = ? AND is_agent_added = ?) OR (is_agent_added = ? AND is_customer_added = ? AND is_admin_added = ?)',
      true, false, false, true, false, false
    ).count

    @other_insurances = @other_insurances.order(created_at: :desc).page(params[:page])

    # Calculate statistics for tabs
    drwise_policies = OtherInsurance.where(
      is_admin_added: true,
      is_customer_added: false,
      is_agent_added: false
    )
    non_drwise_policies = OtherInsurance.where(
      '(is_customer_added = ? AND is_admin_added = ? AND is_agent_added = ?) OR (is_agent_added = ? AND is_customer_added = ? AND is_admin_added = ?)',
      true, false, false, true, false, false
    )

    @drwise_premium = drwise_policies.sum(:total_premium) || 0
    @drwise_coverage = drwise_policies.sum(:sum_insured) || 0
    @non_drwise_premium = non_drwise_policies.sum(:total_premium) || 0
    @non_drwise_coverage = non_drwise_policies.sum(:sum_insured) || 0

    # Set current tab statistics
    if @current_tab == 'drwise'
      @total_policies = @drwise_count
      @total_premium = @drwise_premium
      @total_coverage = @drwise_coverage
    else
      @total_policies = @non_drwise_count
      @total_premium = @non_drwise_premium
      @total_coverage = @non_drwise_coverage
    end
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

    # Set admin tracking fields for policies created from admin panel
    @other_insurance.is_admin_added = true
    @other_insurance.is_customer_added = false
    @other_insurance.is_agent_added = false

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
    companies = InsuranceCompany.where(insurance_type: "motor_other").pluck(:name)

    companies_data = companies.map { |name|
      {
        id: name,
        text: name
      }
    }

    render json: {
      success: true,
      data: companies_data
    }

  end

  # API endpoint for getting insurance companies by agency/broker selection
  # def insurance_companies_by_agency
  #   agency_id = params[:agency_id]
  #   broker_code = params[:broker_code]

  #   companies_data = []

  #   case params[:broker_type]
  #   when 'direct'
  #     # For direct mode: Get company from selected agency
  #     if agency_id.present?
  #       agency = AgencyCode.find_by(id: agency_id)
  #       companies_data = [{
  #         id: agency&.insurance_company,
  #         text: agency&.insurance_company || 'Unknown Company'
  #       }]
  #     end

  #   when 'broking'
  #     # For broking mode: Return all general insurance companies
  #     general_companies = ['New India Assurance', 'Oriental Insurance', 'National Insurance',
  #                         'United India Insurance', 'ICICI Lombard', 'Bajaj Allianz',
  #                         'Reliance General', 'Tata AIG', 'SBI General']

  #     companies_data = general_companies.map { |name|
  #       { id: name, text: name }
  #     }
  #   end

  #   render json: {
  #     success: true,
  #     data: companies_data
  #   }
  # end

  def renew
    # Check if policy expires within 60 days
    if @other_insurance.policy_end_date.blank? || @other_insurance.policy_end_date > 60.days.from_now
      redirect_to admin_other_insurances_path, alert: "This policy is not eligible for renewal yet."
      return
    end

    # Create a new other insurance object with ALL data from the original policy
    @renewed_policy = @other_insurance.dup

    # Keep all the original policy data but update specific fields for renewal
    @renewed_policy.id = nil
    @renewed_policy.created_at = nil
    @renewed_policy.updated_at = nil

    # Set policy type to Renewal
    @renewed_policy.policy_type = 'Renewal'

    # Store original policy number for display
    @original_policy_number = @other_insurance.policy_number

    # Clear policy number (user needs to enter new one)
    @renewed_policy.policy_number = nil

    # Set booking date to current date
    @renewed_policy.policy_booking_date = Date.current

    # Calculate new policy dates based on payment mode
    if @other_insurance.policy_end_date.present?
      # Start date is day after current policy ends
      @renewed_policy.policy_start_date = @other_insurance.policy_end_date + 1.day

      # Calculate end date based on payment mode
      case @other_insurance.payment_mode
      when 'Yearly', 'Annual'
        @renewed_policy.policy_end_date = @renewed_policy.policy_start_date + 1.year - 1.day
      when 'Half Yearly', 'Semi-Annual'
        @renewed_policy.policy_end_date = @renewed_policy.policy_start_date + 6.months - 1.day
      when 'Quarterly'
        @renewed_policy.policy_end_date = @renewed_policy.policy_start_date + 3.months - 1.day
      when 'Monthly'
        @renewed_policy.policy_end_date = @renewed_policy.policy_start_date + 1.month - 1.day
      else
        # Default to yearly if payment mode is not recognized
        @renewed_policy.policy_end_date = @renewed_policy.policy_start_date + 1.year - 1.day
      end
    end

    # Auto-fill installment autopay dates based on new policy dates
    if @renewed_policy.policy_start_date.present? && @renewed_policy.policy_end_date.present?
      @renewed_policy.installment_autopay_start_date = @renewed_policy.policy_start_date
      @renewed_policy.installment_autopay_end_date = @renewed_policy.policy_end_date
    end

    # Clear commission tracking fields (these will be recalculated)
    @renewed_policy.main_agent_commission_received = nil
    @renewed_policy.main_agent_commission_transaction_id = nil
    @renewed_policy.main_agent_commission_paid_date = nil
    @renewed_policy.main_agent_commission_notes = nil

    # Clear lead_id and original_policy_id for new policy
    @renewed_policy.lead_id = nil
    @renewed_policy.original_policy_id = @other_insurance.id

    # Clear renewal flag
    @renewed_policy.is_renewed = false

    # Load form data for the renewal form
    load_form_data

    # Set up family members for Policy Holder dropdown
    @customer_family_members = []
    if @other_insurance.customer.present?
      @customer_family_members = @other_insurance.customer.family_members.to_a
    end

    # Auto-set affiliate based on original policy or customer
    if @renewed_policy.sub_agent_id.present?
      @auto_select_affiliate = @renewed_policy.sub_agent_id
    elsif @renewed_policy.customer.present? && @renewed_policy.customer.sub_agent_id.present?
      @renewed_policy.sub_agent_id = @renewed_policy.customer.sub_agent_id
      @auto_select_affiliate = @renewed_policy.customer.sub_agent_id
    else
      @auto_select_affiliate = 'self'
    end

    # Assign to instance variable for form
    @other_insurance = @renewed_policy
  end

  def create_renewal
    # Check if policy expires within 60 days
    if @other_insurance.policy_end_date.blank? || @other_insurance.policy_end_date > 60.days.from_now
      redirect_to admin_other_insurances_path, alert: "This policy is not eligible for renewal yet."
      return
    end

    # Create new policy with renewal data
    @renewed_policy = OtherInsurance.new(other_insurance_params)
    @renewed_policy.policy_type = 'Renewal'
    @renewed_policy.original_policy_id = @other_insurance.id

    # Set admin added flags for renewal (same as original)
    @renewed_policy.is_admin_added = @other_insurance.is_admin_added
    @renewed_policy.is_customer_added = @other_insurance.is_customer_added
    @renewed_policy.is_agent_added = @other_insurance.is_agent_added

    # Calculate commission fields if net_premium is present
    if @renewed_policy.net_premium.present?
      net_premium = @renewed_policy.net_premium
      if @renewed_policy.main_agent_commission_percentage.present?
        @renewed_policy.commission_amount = (net_premium * @renewed_policy.main_agent_commission_percentage) / 100
        if @renewed_policy.tds_percentage.present?
          @renewed_policy.tds_amount = (@renewed_policy.commission_amount * @renewed_policy.tds_percentage) / 100
          @renewed_policy.after_tds_value = @renewed_policy.commission_amount - @renewed_policy.tds_amount
        end
      end
    end

    if @renewed_policy.save
      # Mark original policy as renewed
      @other_insurance.update_column(:is_renewed, true)

      redirect_to admin_other_insurance_path(@renewed_policy),
                  notice: 'Other insurance renewal policy was successfully created.'
    else
      # Reload form data for error display
      load_form_data
      @customer_family_members = @renewed_policy.customer&.family_members || []

      # Set up affiliate selection
      if @renewed_policy.customer.present?
        if @renewed_policy.customer.sub_agent_id.present?
          @auto_select_affiliate = @renewed_policy.customer.sub_agent_id
        else
          @auto_select_affiliate = 'self'
        end
      end

      # Assign to instance variable for form
      @other_insurance = @renewed_policy
      render :renew, status: :unprocessable_entity
    end
  end

  def insurance_companies_by_agency
    broker_code = params[:broker_code]
    agency_code_id = params[:agency_code_id]
    if broker_code.blank? || agency_code_id.blank?
      render json: {
        success: false,
        message: 'Broker code and agency code ID are required'
      }
      return
    end

    companies_data = []

    case broker_code
    when 'direct'
      # For direct mode: Get companies mapped to the selected agency
      company_names = AgencyCode.where(
        id: agency_code_id
      ).where('insurance_type ILIKE ?', '%motor%').pluck(:company_name).compact.uniq

      if company_names.any?
        # Find insurance companies with fuzzy matching
        all_insurance_companies = InsuranceCompany.where('insurance_type ILIKE ?', '%general%')
        matching_companies = []

        # company_names.each do |agency_company_name|
        #   # Try exact match first
        #   exact_match = all_insurance_companies.find_by(name: agency_company_name)
        #   if exact_match
        #     matching_companies << exact_match
        #   else
        #     # Try fuzzy matching - look for companies that contain similar words
        #     agency_words = agency_company_name.downcase.split.reject { |w| w.length < 4 }
        #     fuzzy_matches = all_insurance_companies.select do |company|
        #       company_words = company.name.downcase.split.reject { |w| w.length < 4 }
        #       # Check if main company words match (require at least 2 significant word matches)
        #       common_words = agency_words & company_words
        #       common_words.length >= 2 ||
        #       (agency_words.include?('bajaj') && company_words.include?('bajaj')) ||
        #       (agency_words.include?('tata') && company_words.include?('tata')) ||
        #       (agency_words.include?('hdfc') && company_words.include?('hdfc'))
        #     end
        #     matching_companies.concat(fuzzy_matches)
        #   end
        # end
        insurance_companies = InsuranceCompany.where(name: company_names )
        companies_data = insurance_companies.uniq.map do |company|
          {
            id: company.id,
            text: company.name  # Changed from 'name' to 'text' to match frontend expectations
          }
        end
      end

    when 'broking'
      # For broking mode: Show all motor insurance companies
      insurance_companies = InsuranceCompany.where('insurance_type ILIKE ?', '%general%')

      companies_data = insurance_companies.map do |company|
        {
          id: company.id,
          text: company.name  # Changed from 'name' to 'text' to match frontend expectations
        }
      end

    else
      render json: {
        success: false,
        message: 'Invalid broker code. Use "direct" or "broking".'
      }
      return
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
      policy_documents: [], documents: [], additional_documents: [],
      uploaded_documents_attributes: [:id, :title, :description, :document_type, :file, :uploaded_by, :_destroy]
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
