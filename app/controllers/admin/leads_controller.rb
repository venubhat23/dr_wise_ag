class Admin::LeadsController < Admin::ApplicationController
  before_action :set_lead, only: [:show, :edit, :update, :destroy, :convert_to_customer, :create_policy, :transfer_referral]

  # GET /admin/leads
  def index
    @leads = Lead.all

    # Search functionality
    if params[:search].present?
      @leads = @leads.where(
        "first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ? OR mobile ILIKE ?",
        "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%"
      )
    end

    # Filter by current stage
    if params[:current_stage].present?
      @leads = @leads.where(current_stage: params[:current_stage])
    end

    # Filter by lead source
    if params[:lead_source].present?
      @leads = @leads.where(lead_source: params[:lead_source])
    end

    @leads = @leads.order(created_date: :desc).page(params[:page])

    # Statistics
    @total_leads = Lead.count
    @consultation_leads = Lead.where(current_stage: 'consultation').count if Lead.column_names.include?('current_stage')
    @converted_leads = Lead.where(current_stage: 'converted').count if Lead.column_names.include?('current_stage')
  end

  # GET /admin/leads/1
  def show
  end

  # GET /admin/leads/new
  def new
    @lead = Lead.new
  end

  # GET /admin/leads/1/edit
  def edit
  end

  # POST /admin/leads
  def create
    @lead = Lead.new(lead_params)

    if @lead.save
      redirect_to admin_lead_path(@lead), notice: 'Lead was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/leads/1
  def update
    if @lead.update(lead_params)
      redirect_to admin_lead_path(@lead), notice: 'Lead was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/leads/1
  def destroy
    @lead.destroy
    redirect_to admin_leads_path, notice: 'Lead was successfully deleted.'
  end

  # PATCH /admin/leads/1/convert_to_customer
  def convert_to_customer
    # Logic to convert lead to customer
    customer = Customer.create!(
      customer_type: 'individual',
      first_name: @lead.first_name,
      last_name: @lead.last_name,
      email: @lead.email,
      mobile: @lead.mobile,
      address: @lead.address || 'To be updated',
      state: @lead.state || 'To be updated',
      city: @lead.city || 'To be updated',
      status: true
    )

    if customer.persisted?
      @lead.update(current_stage: 'converted') if @lead.respond_to?(:current_stage)
      redirect_to admin_customer_path(customer), notice: 'Lead successfully converted to customer.'
    else
      redirect_to admin_lead_path(@lead), alert: 'Failed to convert lead to customer.'
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to admin_lead_path(@lead), alert: "Failed to convert lead: #{e.message}"
  end

  # PATCH /admin/leads/1/create_policy
  def create_policy
    # Redirect to policy creation with lead info
    redirect_to new_admin_policy_path(lead_id: @lead.id), notice: 'Please fill in policy details.'
  end

  # PATCH /admin/leads/1/transfer_referral
  def transfer_referral
    # Logic for transferring referral
    if @lead.update(current_stage: 'transferred') if @lead.respond_to?(:current_stage)
      redirect_to admin_lead_path(@lead), notice: 'Referral transferred successfully.'
    else
      redirect_to admin_lead_path(@lead), alert: 'Failed to transfer referral.'
    end
  end

  private

  def set_lead
    @lead = Lead.find(params[:id])
  end

  def lead_params
    params.require(:lead).permit(
      :first_name, :last_name, :email, :mobile, :address, :state, :city,
      :lead_source, :current_stage, :insurance_interest, :notes, :created_date
    )
  end
end