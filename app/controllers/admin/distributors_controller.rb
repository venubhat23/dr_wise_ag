class Admin::DistributorsController < Admin::ApplicationController
  before_action :set_distributor, only: [:show, :edit, :update, :destroy]

  # GET /admin/distributors
  def index
    @distributors = Distributor.all

    # Search functionality
    if params[:search].present?
      @distributors = @distributors.search_by_name_mobile_email(params[:search])
    end

    # Filter by status
    case params[:status]
    when 'active'
      @distributors = @distributors.active
    when 'inactive'
      @distributors = @distributors.inactive
    end

    @distributors = @distributors.order(created_at: :desc).page(params[:page])

    # Statistics
    @total_distributors = Distributor.count
    @active_distributors = Distributor.active.count
    @inactive_distributors = Distributor.inactive.count
  end

  # GET /admin/distributors/1
  def show
    @documents = @distributor.distributor_documents.order(:created_at)
  end

  # GET /admin/distributors/new
  def new
    @distributor = Distributor.new
    @distributor.role_id = 'distributor'
    @distributor.distributor_documents.build
  end

  # GET /admin/distributors/1/edit
  def edit
    @distributor.distributor_documents.build if @distributor.distributor_documents.empty?
  end

  # POST /admin/distributors
  def create
    @distributor = Distributor.new(distributor_params)
    @distributor.role_id = 'distributor'

    if @distributor.save
      redirect_to admin_distributors_path, notice: 'Distributor was successfully created.'
    else
      @distributor.distributor_documents.build if @distributor.distributor_documents.empty?
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/distributors/1
  def update
    if @distributor.update(distributor_params)
      redirect_to admin_distributors_path, notice: 'Distributor was successfully updated.'
    else
      @distributor.distributor_documents.build if @distributor.distributor_documents.empty?
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/distributors/1
  def destroy
    @distributor.destroy
    redirect_to admin_distributors_path, notice: 'Distributor was successfully deleted.'
  end

  # PATCH /admin/distributors/1/toggle_status
  def toggle_status
    @distributor = Distributor.find(params[:id])
    new_status = @distributor.active? ? :inactive : :active

    if @distributor.update(status: new_status)
      redirect_to admin_distributors_path, notice: "Distributor status updated to #{new_status}."
    else
      redirect_to admin_distributors_path, alert: 'Failed to update status.'
    end
  end

  private

  def set_distributor
    @distributor = Distributor.find(params[:id])
  end

  def distributor_params
    params.require(:distributor).permit(
      :first_name, :middle_name, :last_name, :mobile, :email, :role_id,
      :state_id, :city_id, :birth_date, :gender, :pan_no, :gst_no,
      :company_name, :address, :bank_name, :account_no, :ifsc_code,
      :account_holder_name, :account_type, :upi_id, :status, :upload_main_document,
      distributor_documents_attributes: [:id, :document_type, :document_file, :_destroy]
    )
  end
end
