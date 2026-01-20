class Admin::MotorInsurancesController < Admin::ApplicationController
  include ConfigurablePagination
  before_action :set_motor_insurance, only: [:show, :edit, :update, :destroy]
  before_action :load_form_data, only: [:new, :edit, :create, :update]

  def index
    @motor_insurances = MotorInsurance.includes(:customer, :sub_agent, :agency_code, :broker)

    # Search functionality
    if params[:search].present?
      @motor_insurances = @motor_insurances.search_motor_policies(params[:search])
    end

    # Filter by status
    case params[:status]
    when 'active'
      @motor_insurances = @motor_insurances.active
    when 'expired'
      @motor_insurances = @motor_insurances.expired
    when 'expiring_soon'
      @motor_insurances = @motor_insurances.expiring_soon
    end

    # Filter by insurance type
    if params[:insurance_type].present?
      @motor_insurances = @motor_insurances.where(insurance_type: params[:insurance_type])
    end

    # Filter by policy type
    if params[:policy_type].present?
      @motor_insurances = @motor_insurances.where(policy_type: params[:policy_type])
    end

    # Filter by insurance company
    if params[:company].present?
      @motor_insurances = @motor_insurances.where(insurance_company_name: params[:company])
    end

    @motor_insurances = paginate_records(@motor_insurances.order(created_at: :desc))
  end

  def show
  end

  def new
    @motor_insurance = MotorInsurance.new(
      policy_booking_date: Date.current,
      policy_start_date: Date.current,
      policy_end_date: Date.current + 1.year,
      gst_percentage: 18.0,
      is_admin_added: true
    )

    # Pre-fill customer data if coming from customer page
    if params[:customer_id].present?
      @selected_customer = Customer.find(params[:customer_id])
      @motor_insurance.customer_id = @selected_customer.id

      # Auto-select customer's existing affiliate if they have one
      if @selected_customer.affiliate.present?
        @motor_insurance.sub_agent_id = @selected_customer.affiliate.id
        @auto_select_affiliate = @selected_customer.affiliate.id
      else
        # Set 'Self' as default affiliate (no sub_agent)
        @auto_select_affiliate = 'self'
      end

      # Auto-populate family members as policy holder options
      @customer_family_members = @selected_customer.family_members.includes(:customer)
    end
  end

  def edit
  end

  def create
    processed_params = process_broker_params(motor_insurance_params)
    @motor_insurance = MotorInsurance.new(processed_params)

    # Set admin tracking fields for policies created from admin panel
    @motor_insurance.policy_added_by_admin = true
    @motor_insurance.is_admin_added = true
    @motor_insurance.is_customer_added = false
    @motor_insurance.is_agent_added = false

    set_distributor_from_affiliate(@motor_insurance)

    if @motor_insurance.save
      redirect_to admin_motor_insurance_path(@motor_insurance), notice: 'Motor insurance policy was successfully created.'
    else
      load_form_data
      render :new, status: :unprocessable_entity
    end
  end

  def update
    processed_params = process_broker_params(motor_insurance_params)
    @motor_insurance.assign_attributes(processed_params)
    set_distributor_from_affiliate(@motor_insurance)

    if @motor_insurance.save
      redirect_to admin_motor_insurance_path(@motor_insurance), notice: 'Motor insurance policy was successfully updated.'
    else
      load_form_data
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @motor_insurance.destroy
    redirect_to admin_motor_insurances_path, notice: 'Motor insurance policy was successfully deleted.'
  end

  def renew
    @motor_insurance = MotorInsurance.find(params[:id])

    # Create a new policy with data from the existing policy
    @renewed_policy = @motor_insurance.dup

    # Set renewal-specific attributes
    @renewed_policy.policy_type = 'Renewal'
    @renewed_policy.policy_number = nil  # Will be generated new
    @renewed_policy.policy_booking_date = Date.current

    # Calculate new policy dates based on the original policy end date
    @renewed_policy.policy_start_date = @motor_insurance.policy_end_date + 1.day

    # Set end date to 1 year from new start date (motor insurance is typically annual)
    @renewed_policy.policy_end_date = @renewed_policy.policy_start_date + 1.year - 1.day

    # Clear any ID fields to ensure a new record is created
    @renewed_policy.id = nil
    @renewed_policy.created_at = nil
    @renewed_policy.updated_at = nil

    # Copy over vehicle details
    @renewed_policy.registration_number = @motor_insurance.registration_number
    @renewed_policy.engine_number = @motor_insurance.engine_number
    @renewed_policy.chassis_number = @motor_insurance.chassis_number
    @renewed_policy.vehicle_idv = @motor_insurance.vehicle_idv
    @renewed_policy.make = @motor_insurance.make
    @renewed_policy.model = @motor_insurance.model
    @renewed_policy.variant = @motor_insurance.variant
    @renewed_policy.mfy = @motor_insurance.mfy

    # Load form data for the view
    load_form_data

    # Pre-select customer and affiliate data
    @selected_customer = @motor_insurance.customer
    @customer_family_members = @selected_customer&.family_members&.includes(:customer)

    render :renew
  end

  def create_renewal
    @renewed_policy = MotorInsurance.new(motor_insurance_params)

    # Set admin tracking fields for renewal policies
    @renewed_policy.policy_added_by_admin = true
    @renewed_policy.is_admin_added = true
    @renewed_policy.is_customer_added = false
    @renewed_policy.is_agent_added = false
    @renewed_policy.policy_type = 'Renewal'

    set_distributor_from_affiliate(@renewed_policy)

    if @renewed_policy.save
      redirect_to admin_motor_insurance_path(@renewed_policy),
                  notice: 'Motor insurance renewal policy was successfully created.'
    else
      load_form_data
      @selected_customer = @renewed_policy.customer
      @customer_family_members = @selected_customer&.family_members&.includes(:customer)
      render :renew, status: :unprocessable_entity
    end
  end

  def policy_holder_options
    customer = Customer.find(params[:customer_id]) if params[:customer_id].present?
    options = [['Self', 'Self']]
    if customer&.family_members&.any?
      customer.family_members.each do |member|
        options << [member.full_name, member.id.to_s]
      end
    end
    render json: { options: options }
  end

  # AJAX endpoint for getting customer affiliate information
  def customer_affiliate_info
    customer = Customer.find(params[:customer_id]) if params[:customer_id].present?

    response = {
      customer_name: customer&.display_name,
      affiliate_id: nil,
      affiliate_name: nil
    }

    if customer&.sub_agent_id.present?
      sub_agent = SubAgent.find_by(id: customer.sub_agent_id)
      if sub_agent
        response[:affiliate_id] = sub_agent.id
        response[:affiliate_name] = sub_agent.display_name
      end
    end

    render json: response
  end

  # API endpoints for dynamic dropdowns
  def agency_codes_for_broker_type
    broker_type = params[:broker_type]

    case broker_type
    when 'direct'
      # FLOW 1: Direct mode - Fetch agents for motor insurance
      # API response format: { agent1: company_name_1, agent2: company_name_2 }
      agency_codes = AgencyCode.where('insurance_type ILIKE ?', '%motor%')
                               .select(:id, :agent_name, :code, :company_name)
                               .order(:agent_name)

      # Transform to required format for dropdown
      agents_data = agency_codes.map { |ac|
        {
          id: ac.id,
          text: ac.agent_name,  # Show only agent name in dropdown
          agent_name: ac.agent_name,
          code: ac.code,
          company_name: ac.company_name
        }
      }

      render json: {
        success: true,
        data: agents_data
      }

    when 'broking'
      # FLOW 2: Broking mode - Fetch all brokers for motor insurance
      # API response format: { broker1, broker2 }
      brokers = Broker.active.order(:name)

      brokers_data = brokers.map { |broker|
        {
          id: "broker_#{broker.id}",  # Use broker_X format for proper processing
          text: broker.name,  # Show broker name in dropdown
          broker_name: broker.name
        }
      }

      render json: {
        success: true,
        data: brokers_data
      }

    else
      render json: { success: false, message: 'Invalid broker type. Use "direct" or "broking".' }
    end
  end

  # API endpoint for getting company name by agent selection (Direct mode only)
  def company_name_by_agent
    agency_code_id = params[:agency_code_id]

    if agency_code_id.present?
      agency_code = AgencyCode.find_by(id: agency_code_id)

      if agency_code
        # Get all companies for this agent name in motor insurance
        agent_name = agency_code.agent_name
        company_names = AgencyCode.where(
          agent_name: agent_name
        ).where('insurance_type ILIKE ?', '%motor%').pluck(:company_name).compact.uniq

        if company_names.length == 1
          # Single company - return as before for compatibility
          render json: {
            success: true,
            data: {
              company_name: company_names.first,
              agent_name: agent_name
            }
          }
        else
          # Multiple companies - return all options
          render json: {
            success: true,
            data: {
              company_names: company_names,
              agent_name: agent_name,
              multiple_companies: true
            }
          }
        end
      else
        render json: { success: false, message: 'Agency code not found' }
      end
    else
      render json: { success: false, message: 'Agency code ID is required' }
    end
  end

  # API endpoint for insurance companies (independent for Broking mode)
  def insurance_companies_for_type
    # FLOW 2: Broking mode - Fetch all motor insurance companies
    # API response format: { company1, company2 }

    # For motor insurance, use the motor/general insurance companies
    companies = InsuranceCompany.where('insurance_type ILIKE ?', '%general%').pluck(:name)

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

  # API endpoint for getting insurance companies by agency code
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

        company_names.each do |agency_company_name|
          # Try exact match first
          exact_match = all_insurance_companies.find_by(name: agency_company_name)
          if exact_match
            matching_companies << exact_match
          else
            # Try fuzzy matching - look for companies that contain similar words
            agency_words = agency_company_name.downcase.split.reject { |w| w.length < 4 }
            fuzzy_matches = all_insurance_companies.select do |company|
              company_words = company.name.downcase.split.reject { |w| w.length < 4 }
              # Check if main company words match (require at least 2 significant word matches)
              common_words = agency_words & company_words
              common_words.length >= 2 ||
              (agency_words.include?('bajaj') && company_words.include?('bajaj')) ||
              (agency_words.include?('tata') && company_words.include?('tata')) ||
              (agency_words.include?('hdfc') && company_words.include?('hdfc'))
            end
            matching_companies.concat(fuzzy_matches)
          end
        end

        companies_data = matching_companies.uniq.map do |company|
          {
            id: company.id,
            name: company.name
          }
        end
      end

    when 'broking'
      # For broking mode: Show all motor insurance companies
      insurance_companies = InsuranceCompany.where('insurance_type ILIKE ?', '%general%')

      companies_data = insurance_companies.map do |company|
        {
          id: company.id,
          name: company.name
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

  def process_broker_params(params)
    # Handle agency_code_id when it contains broker_X format
    if params[:agency_code_id].present? && params[:agency_code_id].start_with?('broker_')
      # Extract broker ID from broker_X format
      broker_id = params[:agency_code_id].gsub('broker_', '').to_i
      # Set broker_id and clear agency_code_id for broking type
      if broker_id > 0
        params[:broker_id] = broker_id
        params[:agency_code_id] = nil
      end
    end
    params
  end

  def set_motor_insurance
    @motor_insurance = MotorInsurance.find(params[:id])
  end

  def load_form_data
    @customers = Customer.active.order(:first_name, :last_name)
    @sub_agents = SubAgent.active.order(:first_name, :last_name)
    @distributors = Distributor.active.order(:first_name, :last_name)
    @investors = Investor.active.order(:first_name, :last_name)
    @agency_codes = AgencyCode.where(insurance_type: 'Motor Insurance')
    @brokers = Broker.active.order(:name)
    # Load only motor/general insurance companies
    @insurance_companies = MotorInsurance.general_insurance_companies.map { |company| company[:name] }
    @vehicle_types = MotorInsurance::VEHICLE_TYPES
    @class_of_vehicles = MotorInsurance::CLASS_OF_VEHICLES
    @insurance_types = MotorInsurance::INSURANCE_TYPES
    @policy_types = MotorInsurance::POLICY_TYPES
    @payout_options = MotorInsurance::PAYOUT_OPTIONS
  end

  def motor_insurance_params
    params.require(:motor_insurance).permit(
      # Client & Agent Details
      :customer_id, :policy_holder, :sub_agent_id, :distributor_id, :investor_id, :reference_by_name,

      # Policy Details
      :insurance_company_name, :agency_code_id, :broker_id, :broker_code_type, :vehicle_type,
      :class_of_vehicle, :insurance_type, :policy_type, :policy_booking_date,
      :policy_start_date, :policy_end_date, :policy_number, :registration_number,
      :registration_date, :tp_premium, :net_premium, :gst_percentage, :total_premium,

      # Vehicle Details
      :vehicle_idv, :cng_idv, :total_idv, :engine_number, :chassis_number,
      :mfy, :make, :model, :variant, :seating_capacity, :ncb, :discount_loading_percent,

      # Advance Details
      :broker_name, :previous_policy_number, :extra_note,

      # Commission Details
      :payout_od, :payout_tp, :payout_net, :main_agent_commission_percent,
      :main_agent_commission_amount, :main_agent_tds_percent, :main_agent_tds_amount,
      :after_tds_value,

      # Enhanced Commission Structure
      :main_agent_commission_percentage, :commission_amount, :tds_percentage, :tds_amount,
      :sub_agent_commission_percentage, :sub_agent_commission_amount, :sub_agent_tds_percentage,
      :sub_agent_tds_amount, :sub_agent_after_tds_value,
      :distributor_commission_percentage, :distributor_commission_amount, :distributor_tds_percentage,
      :distributor_tds_amount, :distributor_after_tds_value,
      :investor_commission_percentage, :investor_commission_amount, :investor_tds_percentage,
      :investor_tds_amount, :investor_after_tds_value,
      :ambassador_commission_percentage, :ambassador_commission_amount, :ambassador_tds_percentage,
      :ambassador_tds_amount, :ambassador_after_tds_value,
      :total_distribution_percentage, :company_expenses_percentage, :profit_percentage, :profit_amount,

      # Legal Liability & Optional Covers
      :legal_liability, :electrical_accessories, :non_electrical_accessories,
      :zero_depreciation, :roadside_assistance, :engine_protector, :key_replacement,
      :return_to_invoice, :consumable_cover, :personal_accident_cover, :financier
    )
  end

  def set_distributor_from_affiliate(insurance_record)
    # If affiliate is selected but distributor is not set, auto-assign distributor
    if insurance_record.sub_agent_id.present? && insurance_record.distributor_id.blank?
      sub_agent = SubAgent.find(insurance_record.sub_agent_id)

      # Use direct distributor relationship first, then fall back to assignment
      distributor_id = sub_agent.distributor_id || sub_agent.assigned_distributor&.id

      insurance_record.distributor_id = distributor_id if distributor_id.present?
    end
  rescue StandardError => e
    # Log error but don't fail the form submission
    Rails.logger.error "Failed to set distributor from affiliate: #{e.message}"
  end
end