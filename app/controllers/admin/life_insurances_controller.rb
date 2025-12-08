class Admin::LifeInsurancesController < Admin::ApplicationController
  before_action :set_life_insurance, only: [:show, :edit, :update, :destroy]

  # GET /admin/insurance/life
  def index
    @life_insurances = LifeInsurance.includes(:customer, :sub_agent, :agency_code, :broker)

    # Search functionality
    if params[:search].present?
      @life_insurances = @life_insurances.search_life_policies(params[:search])
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

    @life_insurances = @life_insurances.order(created_at: :desc).page(params[:page])
  end

  # GET /admin/insurance/life/1
  def show
  end

  # GET /admin/insurance/life/new
  def new
    @life_insurance = LifeInsurance.new
    set_form_data
  end

  # GET /admin/insurance/life/1/edit
  def edit
    set_form_data
  end

  # POST /admin/insurance/life
  def create
    @life_insurance = LifeInsurance.new(life_insurance_params)

    if @life_insurance.save
      redirect_to admin_life_insurances_path,
                  notice: 'Life insurance policy was successfully created.'
    else
      set_form_data
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/insurance/life/1
  def update
    if @life_insurance.update(life_insurance_params)
      redirect_to admin_life_insurances_path,
                  notice: 'Life insurance policy was successfully updated.'
    else
      set_form_data
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/insurance/life/1
  def destroy
    @life_insurance.destroy
    redirect_to admin_life_insurances_path,
                notice: 'Life insurance policy was successfully deleted.'
  end

  # GET /admin/insurance/life/policy_holder_options
  def policy_holder_options
    customer = Customer.find(params[:customer_id]) if params[:customer_id].present?
    options = [{ label: 'Self', value: 'Self' }]

    if customer&.family_members&.any?
      customer.family_members.each do |member|
        options << {
          label: member.full_name,
          value: member.id.to_s,
          relationship: member.relationship,
          age: member.age
        }
      end
    end

    render json: { options: options }
  end

  private

  def set_life_insurance
    @life_insurance = LifeInsurance.find(params[:id])
  end

  def set_form_data
    @customers = Customer.active.order(:first_name, :last_name, :company_name)
    @sub_agents = SubAgent.active.order(:first_name, :last_name)
    @agency_codes = AgencyCode.where(insurance_type: 'Life')
    @brokers = Broker.active.order(:name)
    @insurance_companies = InsuranceCompanyHelper.company_names
    @policy_types = LifeInsurance::POLICY_TYPES
    @payment_modes = LifeInsurance::PAYMENT_MODES
    @relationships = LifeInsurance::RELATIONSHIPS
    @account_types = LifeInsurance::ACCOUNT_TYPES
    @document_types = LifeInsurance::DOCUMENT_TYPES
  end

  def life_insurance_params
    params.require(:life_insurance).permit(
      :customer_id, :sub_agent_id, :agency_code_id, :broker_id,
      :policy_holder, :insured_name, :insurance_company_name, :policy_type,
      :payment_mode, :policy_number, :policy_booking_date, :policy_start_date,
      :policy_end_date, :risk_start_date, :policy_term, :premium_payment_term,
      :plan_name, :sum_insured, :net_premium, :first_year_gst_percentage,
      :second_year_gst_percentage, :third_year_gst_percentage, :total_premium,
      :term_rider_amount, :term_rider_note, :critical_illness_rider_amount,
      :critical_illness_rider_note, :accident_rider_amount, :accident_rider_note,
      :pwb_rider_amount, :pwb_rider_note, :other_rider_amount, :other_rider_note,
      :nominee_name, :nominee_relationship, :nominee_age, :bank_name,
      :account_type, :account_number, :ifsc_code, :account_holder_name,
      :reference_by_name, :broker_name, :bonus, :fund, :extra_note,
      :main_agent_commission_percentage, :commission_amount, :tds_percentage,
      :tds_amount, :after_tds_value, :installment_autopay_start_date,
      :installment_autopay_end_date, :active,
      policy_documents: [], documents: []
    )
  end
end