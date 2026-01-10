class Admin::InsuranceCompaniesController < Admin::ApplicationController
  before_action :set_insurance_company, only: [:show, :edit, :update, :destroy]

  def index
    @current_tab = params[:tab] || 'all'
    @search_query = params[:search]

    # Base query
    @insurance_companies = InsuranceCompany.all

    # Filter by insurance type based on tab
    case @current_tab
    when 'life'
      @insurance_companies = @insurance_companies.where(insurance_type: 'Life')
    when 'health'
      @insurance_companies = @insurance_companies.where(insurance_type: 'Health')
    when 'general'
      @insurance_companies = @insurance_companies.where(insurance_type: 'General')
    else
      # 'all' tab - no additional filtering
    end

    # Apply search if present
    if @search_query.present?
      @insurance_companies = @insurance_companies.where(
        "name ILIKE ? OR code ILIKE ? OR contact_person ILIKE ?",
        "%#{@search_query}%", "%#{@search_query}%", "%#{@search_query}%"
      )
    end

    # Order and paginate
    @insurance_companies = @insurance_companies.order(:name)
    @insurance_companies = @insurance_companies.page(params[:page])

    # Statistics for cards
    @total_companies = InsuranceCompany.count
    @life_companies = InsuranceCompany.where(insurance_type: 'Life').count
    @health_companies = InsuranceCompany.where(insurance_type: 'Health').count
    @general_companies = InsuranceCompany.where(insurance_type: 'General').count

  rescue NameError
    # Handle case where InsuranceCompany model doesn't exist yet
    redirect_to admin_customers_path, alert: 'Insurance Companies functionality not yet implemented.'
  end

  def show
  end

  def new
    @insurance_company = InsuranceCompany.new
  rescue NameError
    redirect_to admin_customers_path, alert: 'Insurance Companies functionality not yet implemented.'
  end

  def edit
  end

  def create
    @insurance_company = InsuranceCompany.new(insurance_company_params)

    if @insurance_company.save
      redirect_to admin_insurance_company_path(@insurance_company), notice: 'Insurance company was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  rescue NameError
    redirect_to admin_customers_path, alert: 'Insurance Companies functionality not yet implemented.'
  end

  def update
    if @insurance_company.update(insurance_company_params)
      redirect_to admin_insurance_company_path(@insurance_company), notice: 'Insurance company was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @insurance_company.destroy
    redirect_to admin_insurance_companies_path, notice: 'Insurance company was successfully deleted.'
  end

  private

  def set_insurance_company
    @insurance_company = InsuranceCompany.find(params[:id])
  rescue NameError
    redirect_to admin_customers_path, alert: 'Insurance Companies functionality not yet implemented.'
  end

  def insurance_company_params
    params.require(:insurance_company).permit(:name, :code, :contact_person, :email, :mobile, :address, :status, :insurance_type)
  end
end