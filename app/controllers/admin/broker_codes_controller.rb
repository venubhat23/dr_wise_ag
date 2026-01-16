class Admin::BrokerCodesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_broker_code, only: [:show, :edit, :update, :destroy, :toggle_status]
  before_action :set_broker, only: [:index, :new, :create], if: :broker_context?

  def index
    @broker_codes = if @broker
                      @broker.broker_codes.includes(:broker)
                    else
                      BrokerCode.includes(:broker).all
                    end

    # Apply search if present
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @broker_codes = @broker_codes.joins(:broker).where(
        "broker_code ILIKE ? OR company_name ILIKE ? OR brokers.name ILIKE ?",
        search_term, search_term, search_term
      )
    end

    # Apply status filter
    if params[:status].present? && params[:status] != 'all'
      @broker_codes = @broker_codes.where(status: params[:status] == 'active')
    end

    @broker_codes = @broker_codes.joins(:broker).order('brokers.name')

    # Get all brokers and companies for dropdowns
    @brokers = Broker.active.order(:name)
    @companies = get_unique_companies
  end

  def new
    @broker_code = @broker ? @broker.broker_codes.build : BrokerCode.new
    @brokers = Broker.active.order(:name)
    @companies = get_unique_companies
  end

  def create
    @broker_code = @broker ? @broker.broker_codes.build(broker_code_params) : BrokerCode.new(broker_code_params)

    if @broker_code.save
      # Always redirect to brokers page with #broker-code anchor after successful creation
      redirect_to admin_brokers_path(anchor: 'broker-code'), notice: "Broker code created successfully!"
    else
      @brokers = Broker.active.order(:name)
      @companies = get_unique_companies
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @brokers = Broker.active.order(:name)
    @companies = get_unique_companies
  end

  def update
    if @broker_code.update(broker_code_params)
      # Redirect to brokers page with #broker-code anchor after successful update
      redirect_to admin_brokers_path(anchor: 'broker-code'), notice: "Broker code updated successfully!"
    else
      @brokers = Broker.active.order(:name)
      @companies = get_unique_companies
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @broker_code.destroy
    # Redirect to brokers page with #broker-code anchor after successful deletion
    redirect_to admin_brokers_path(anchor: 'broker-code'), notice: "Broker code deleted successfully!"
  end

  def toggle_status
    @broker_code.update(status: !@broker_code.status)
    status_text = @broker_code.status? ? 'activated' : 'deactivated'
    # Redirect to brokers page with #broker-code anchor after status toggle
    redirect_to admin_brokers_path(anchor: 'broker-code'), notice: "Broker code #{status_text} successfully!"
  end


  private

  def set_broker_code
    @broker_code = BrokerCode.find(params[:id])
  end

  def set_broker
    @broker = Broker.find(params[:broker_id]) if params[:broker_id].present?
  end

  def broker_context?
    params[:broker_id].present?
  end

  def broker_code_params
    params.require(:broker_code).permit(:broker_id, :broker_code, :company_name, :status)
  end

  def get_unique_companies
    # Get unique company names from various insurance tables
    companies = []

    # Safely check and get companies from each insurance type
    begin
      if defined?(LifeInsurance) && LifeInsurance.column_names.include?('insurance_company_name')
        companies += LifeInsurance.distinct.pluck(:insurance_company_name).compact
      end
    rescue => e
      Rails.logger.error "Error fetching LifeInsurance companies: #{e.message}"
    end

    begin
      if defined?(HealthInsurance) && HealthInsurance.column_names.include?('insurance_company_name')
        companies += HealthInsurance.distinct.pluck(:insurance_company_name).compact
      end
    rescue => e
      Rails.logger.error "Error fetching HealthInsurance companies: #{e.message}"
    end

    begin
      if defined?(MotorInsurance) && MotorInsurance.column_names.include?('insurance_company_name')
        companies += MotorInsurance.distinct.pluck(:insurance_company_name).compact
      end
    rescue => e
      Rails.logger.error "Error fetching MotorInsurance companies: #{e.message}"
    end

    begin
      if defined?(OtherInsurance)
        # Check what column name OtherInsurance uses for company name
        if OtherInsurance.column_names.include?('insurance_company_name')
          companies += OtherInsurance.distinct.pluck(:insurance_company_name).compact
        elsif OtherInsurance.column_names.include?('company_name')
          companies += OtherInsurance.distinct.pluck(:company_name).compact
        elsif OtherInsurance.column_names.include?('insurance_company')
          companies += OtherInsurance.distinct.pluck(:insurance_company).compact
        end
      end
    rescue => e
      Rails.logger.error "Error fetching OtherInsurance companies: #{e.message}"
    end

    # Add some common insurance companies as fallback
    companies += [
      'ICICI Lombard',
      'HDFC ERGO',
      'Bajaj Allianz',
      'TATA AIG',
      'Reliance General',
      'New India Assurance',
      'Oriental Insurance',
      'United India Insurance',
      'National Insurance',
      'IFFCO Tokio',
      'Cholamandalam MS',
      'Future Generali',
      'Kotak Mahindra General',
      'Liberty General',
      'Raheja QBE',
      'Royal Sundaram',
      'SBI General',
      'Shriram General',
      'Universal Sompo',
      'Max Life Insurance',
      'LIC of India',
      'SBI Life Insurance',
      'HDFC Life',
      'ICICI Prudential Life',
      'Birla Sun Life',
      'Kotak Life Insurance',
      'PNB MetLife',
      'Aegon Life',
      'Aviva Life Insurance',
      'Canara HSBC Life',
      'Edelweiss Tokio Life',
      'Exide Life Insurance',
      'IDBI Federal Life',
      'IndiaFirst Life',
      'Pramerica Life',
      'Sahara India Life',
      'Star Union Dai-ichi Life',
      'TATA AIA Life'
    ]

    companies.uniq.compact.sort
  end
end