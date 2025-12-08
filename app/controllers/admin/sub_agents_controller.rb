class Admin::SubAgentsController < Admin::ApplicationController
  before_action :set_sub_agent, only: [:show, :edit, :update, :destroy]

  # GET /admin/sub_agents
  def index
    @sub_agents = SubAgent.all

    # Search functionality
    if params[:search].present?
      @sub_agents = @sub_agents.search_by_name_mobile_email(params[:search])
    end

    # Filter by status
    case params[:status]
    when 'active'
      @sub_agents = @sub_agents.active
    when 'inactive'
      @sub_agents = @sub_agents.inactive
    end

    @sub_agents = @sub_agents.order(created_at: :desc).page(params[:page])

    # Statistics
    @total_sub_agents = SubAgent.count
    @active_sub_agents = SubAgent.active.count
    @inactive_sub_agents = SubAgent.inactive.count
  end

  # GET /admin/sub_agents/1
  def show
    @documents = @sub_agent.sub_agent_documents.order(:created_at)
  end

  # GET /admin/sub_agents/new
  def new
    @sub_agent = SubAgent.new
    @sub_agent.sub_agent_documents.build
  end

  # GET /admin/sub_agents/1/edit
  def edit
    @sub_agent.sub_agent_documents.build if @sub_agent.sub_agent_documents.empty?
  end

  # POST /admin/sub_agents
  def create
    @sub_agent = SubAgent.new(sub_agent_params)

    if @sub_agent.save
      redirect_to admin_sub_agents_path, notice: 'Sub Agent was successfully created.'
    else
      @sub_agent.sub_agent_documents.build if @sub_agent.sub_agent_documents.empty?
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/sub_agents/1
  def update
    if @sub_agent.update(sub_agent_params)
      redirect_to admin_sub_agents_path, notice: 'Sub Agent was successfully updated.'
    else
      @sub_agent.sub_agent_documents.build if @sub_agent.sub_agent_documents.empty?
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/sub_agents/1
  def destroy
    @sub_agent.destroy
    redirect_to admin_sub_agents_path, notice: 'Sub Agent was successfully deleted.'
  end

  # PATCH /admin/sub_agents/1/toggle_status
  def toggle_status
    @sub_agent = SubAgent.find(params[:id])
    new_status = @sub_agent.active? ? :inactive : :active

    if @sub_agent.update(status: new_status)
      redirect_to admin_sub_agents_path, notice: "Sub Agent status updated to #{new_status}."
    else
      redirect_to admin_sub_agents_path, alert: 'Failed to update status.'
    end
  end

  private

  def set_sub_agent
    @sub_agent = SubAgent.find(params[:id])
  end

  def sub_agent_params
    params.require(:sub_agent).permit(
      :first_name, :middle_name, :last_name, :mobile, :email, :role_id,
      :state_id, :city_id, :birth_date, :gender, :pan_no, :gst_no,
      :company_name, :address, :bank_name, :account_no, :ifsc_code,
      :account_holder_name, :account_type, :upi_id, :status, :upload_main_document,
      sub_agent_documents_attributes: [:id, :document_type, :document_file, :_destroy]
    )
  end
end