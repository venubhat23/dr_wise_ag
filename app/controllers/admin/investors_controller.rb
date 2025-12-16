class Admin::InvestorsController < Admin::ApplicationController
  before_action :set_investor, only: [:show, :edit, :update, :destroy]

  # GET /admin/investors
  def index
    @investors = Investor.all

    # Search functionality
    if params[:search].present?
      @investors = @investors.search_by_name_mobile_email(params[:search])
    end

    # Filter by status
    case params[:status]
    when 'active'
      @investors = @investors.active
    when 'inactive'
      @investors = @investors.inactive
    end

    @investors = @investors.order(created_at: :desc).page(params[:page])

    # Statistics
    @total_investors = Investor.count
    @active_investors = Investor.active.count
    @inactive_investors = Investor.inactive.count
  end

  # GET /admin/investors/1
  def show
    @documents = @investor.investor_documents.order(:created_at)
  end

  # GET /admin/investors/new
  def new
    @investor = Investor.new
    @investor.role_id = 'investor'
    @investor.investor_documents.build
  end

  # GET /admin/investors/1/edit
  def edit
    @investor.investor_documents.build if @investor.investor_documents.empty?
  end

  # POST /admin/investors
  def create
    @investor = Investor.new(investor_params)
    @investor.role_id = 'investor'

    if @investor.save
      redirect_to admin_investors_path, notice: 'Investor was successfully created.'
    else
      @investor.investor_documents.build if @investor.investor_documents.empty?
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/investors/1
  def update
    if @investor.update(investor_params)
      redirect_to admin_investors_path, notice: 'Investor was successfully updated.'
    else
      @investor.investor_documents.build if @investor.investor_documents.empty?
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/investors/1
  def destroy
    @investor.destroy
    redirect_to admin_investors_path, notice: 'Investor was successfully deleted.'
  end

  # PATCH /admin/investors/1/toggle_status
  def toggle_status
    @investor = Investor.find(params[:id])
    new_status = @investor.active? ? :inactive : :active

    if @investor.update(status: new_status)
      redirect_to admin_investors_path, notice: "Investor status updated to #{new_status}."
    else
      redirect_to admin_investors_path, alert: 'Failed to update status.'
    end
  end

  private

  def set_investor
    @investor = Investor.find(params[:id])
  end

  def investor_params
    params.require(:investor).permit(
      :first_name, :middle_name, :last_name, :mobile, :email, :role_id,
      :state_id, :city_id, :birth_date, :gender, :pan_no, :gst_no,
      :company_name, :address, :bank_name, :account_no, :ifsc_code,
      :account_holder_name, :account_type, :upi_id, :status, :upload_main_document,
      investor_documents_attributes: [:id, :document_type, :document_file, :_destroy]
    )
  end
end
