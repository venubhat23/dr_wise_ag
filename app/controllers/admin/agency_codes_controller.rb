class Admin::AgencyCodesController < Admin::ApplicationController
  include InsuranceCompanyMethods

  before_action :set_agency_code, only: [:show, :edit, :update, :destroy]

  # GET /admin/agency_codes
  def index
    @agency_codes = AgencyCode.all

    # Apply search filter
    if params[:search].present?
      @agency_codes = @agency_codes.search(params[:search])
    end

    # Apply company filter
    if params[:company].present?
      @agency_codes = @agency_codes.by_company(params[:company])
    end

    # Apply insurance type filter
    if params[:insurance_type].present?
      @agency_codes = @agency_codes.by_insurance_type(params[:insurance_type])
    end

    # Get total count before pagination for display purposes
    @total_filtered_count = @agency_codes.count

    # Apply pagination (10 records per page)
    @agency_codes = @agency_codes.order(:created_at).page(params[:page]).per(10)

    # For filters
    @insurance_companies = insurance_companies_list

    # Statistics (use unfiltered counts for stats cards)
    @total_codes = AgencyCode.count
    @health_codes = AgencyCode.where(insurance_type: 'Health').count
    @motor_codes = AgencyCode.where(insurance_type: 'Motor').count
    @life_codes = AgencyCode.where(insurance_type: 'Life').count
  end

  # GET /admin/agency_codes/1
  def show
  end

  # GET /admin/agency_codes/new
  def new
    @agency_code = AgencyCode.new
    @insurance_companies = insurance_companies_list
    @insurance_types = ['Health', 'Motor', 'Life', 'General', 'Other']
  end

  # GET /admin/agency_codes/1/edit
  def edit
    @insurance_companies = insurance_companies_list
    @insurance_types = ['Health', 'Motor', 'Life', 'General', 'Other']
  end

  # POST /admin/agency_codes
  def create
    @agency_code = AgencyCode.new(agency_code_params)

    if @agency_code.save
      redirect_to admin_agency_codes_path, notice: 'Agency code was successfully created.'
    else
      @insurance_companies = insurance_companies_list
      @insurance_types = ['Health', 'Motor', 'Life', 'General', 'Other']
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/agency_codes/1
  def update
    if @agency_code.update(agency_code_params)
      redirect_to admin_agency_codes_path, notice: 'Agency code was successfully updated.'
    else
      @insurance_companies = insurance_companies_list
      @insurance_types = ['Health', 'Motor', 'Life', 'General', 'Other']
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/agency_codes/1
  def destroy
    @agency_code.destroy
    redirect_to admin_agency_codes_path, notice: 'Agency code was successfully deleted.'
  end

  # GET /admin/agency_codes/search - For AJAX search
  def search
    @agency_codes = AgencyCode.all

    if params[:search].present?
      @agency_codes = @agency_codes.search(params[:search])
    end

    if params[:company].present?
      @agency_codes = @agency_codes.by_company(params[:company])
    end

    if params[:insurance_type].present?
      @agency_codes = @agency_codes.by_insurance_type(params[:insurance_type])
    end

    # Get total count before pagination for display purposes
    @total_filtered_count = @agency_codes.count

    # Apply pagination (10 records per page)
    @agency_codes = @agency_codes.order(:created_at).page(params[:page]).per(10)

    render partial: 'agency_codes_table', locals: { agency_codes: @agency_codes, total_filtered_count: @total_filtered_count }
  end

  private

  def set_agency_code
    @agency_code = AgencyCode.find(params[:id])
  end

  def agency_code_params
    params.require(:agency_code).permit(:insurance_type, :company_name, :agent_name, :code)
  end
end