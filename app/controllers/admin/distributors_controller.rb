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

    # Get total count before pagination for display purposes
    @total_filtered_count = @distributors.count

    # Order and paginate (10 records per page)
    @distributors = @distributors.order(created_at: :desc).page(params[:page]).per(10)

    # Statistics
    @total_distributors = Distributor.count
    @active_distributors = Distributor.active.count
    @inactive_distributors = Distributor.inactive.count
  end

  # GET /admin/distributors/1
  def show
    @documents = @distributor.distributor_documents.order(:created_at)

    # Get assigned affiliates with their detailed information
    @assigned_affiliates = @distributor.assigned_sub_agents.includes(
      :distributor_assignment
    ).order('sub_agents.created_at DESC')

    # Calculate statistics for each affiliate
    @affiliate_stats = {}
    @assigned_affiliates.each do |affiliate|
      @affiliate_stats[affiliate.id] = calculate_affiliate_stats(affiliate)
    end

    # Overall distributor statistics
    @distributor_stats = calculate_distributor_stats
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
      handle_affiliate_assignments(@distributor, params[:distributor][:assigned_affiliate_ids])
      redirect_to admin_distributors_path, notice: 'Distributor was successfully created.'
    else
      @distributor.distributor_documents.build if @distributor.distributor_documents.empty?
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/distributors/1
  def update
    if @distributor.update(distributor_params)
      handle_affiliate_assignments(@distributor, params[:distributor][:assigned_affiliate_ids])
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

  def handle_affiliate_assignments(distributor, assigned_affiliate_ids)
    return unless assigned_affiliate_ids.is_a?(Array)

    # Remove existing assignments
    distributor.distributor_assignments.destroy_all

    # Create new assignments
    assigned_affiliate_ids.reject(&:blank?).each do |sub_agent_id|
      sub_agent = SubAgent.find_by(id: sub_agent_id)
      if sub_agent
        # Remove any existing assignment for this sub_agent
        DistributorAssignment.where(sub_agent: sub_agent).destroy_all

        # Create new assignment
        distributor.distributor_assignments.create!(
          sub_agent: sub_agent,
          assigned_at: Time.current
        )
      end
    end
  end

  def calculate_affiliate_stats(affiliate)
    health_policies = HealthInsurance.where(sub_agent_id: affiliate.id)
    life_policies = LifeInsurance.where(sub_agent_id: affiliate.id)
    motor_policies = MotorInsurance.where(sub_agent_id: affiliate.id)

    # Safely try to get other policies if the association exists
    other_policies_count = 0
    other_policies_premium = 0.0
    other_policies_commission = 0.0

    begin
      # Try to get other insurance through customers
      affiliate_customers = Customer.where(sub_agent_id: affiliate.id)
      if defined?(OtherInsurance) && OtherInsurance.respond_to?(:joins)
        other_policies = OtherInsurance.joins(:policy).where(policies: { customer_id: affiliate_customers.pluck(:id) })
        other_policies_count = other_policies.count
        other_policies_premium = other_policies.sum(:total_premium).to_f rescue 0.0
        other_policies_commission = other_policies.sum(:commission_amount).to_f rescue 0.0
      end
    rescue => e
      Rails.logger.debug "Could not load other insurance data: #{e.message}"
      other_policies_count = 0
      other_policies_premium = 0.0
      other_policies_commission = 0.0
    end

    total_policies = health_policies.count + life_policies.count + motor_policies.count + other_policies_count
    total_premium = (health_policies.sum(:total_premium) +
                    life_policies.sum(:total_premium) +
                    motor_policies.sum(:total_premium) +
                    other_policies_premium).to_f

    total_commission = (health_policies.sum(:commission_amount) +
                       life_policies.sum(:commission_amount) +
                       motor_policies.sum(:main_agent_commission_amount) +
                       other_policies_commission).to_f

    # Get unique customers from all policies created by this affiliate
    customer_ids = []
    customer_ids += health_policies.pluck(:customer_id).compact
    customer_ids += life_policies.pluck(:customer_id).compact
    customer_ids += motor_policies.pluck(:customer_id).compact
    unique_customers_count = customer_ids.uniq.count

    {
      total_policies: total_policies,
      total_premium: total_premium,
      total_commission: total_commission,
      health_policies: health_policies.count,
      life_policies: life_policies.count,
      motor_policies: motor_policies.count,
      other_policies: other_policies_count,
      recent_policies: get_recent_policies_for_affiliate(affiliate),
      customers_count: unique_customers_count,
      joined_date: affiliate.created_at
    }
  end

  def calculate_distributor_stats
    total_policies = 0
    total_premium = 0.0
    total_commission = 0.0
    total_customers = 0

    @assigned_affiliates.each do |affiliate|
      stats = @affiliate_stats[affiliate.id]
      total_policies += stats[:total_policies]
      total_premium += stats[:total_premium]
      total_commission += stats[:total_commission]
      total_customers += stats[:customers_count]
    end

    {
      total_affiliates: @assigned_affiliates.count,
      active_affiliates: @assigned_affiliates.active.count,
      total_policies: total_policies,
      total_premium: total_premium,
      total_commission: total_commission,
      total_customers: total_customers,
      avg_policies_per_affiliate: @assigned_affiliates.count > 0 ? (total_policies.to_f / @assigned_affiliates.count).round(2) : 0
    }
  end

  def get_recent_policies_for_affiliate(affiliate)
    policies = []

    # Get recent health policies
    HealthInsurance.where(sub_agent_id: affiliate.id)
                   .includes(:customer)
                   .order(created_at: :desc)
                   .limit(3)
                   .each do |policy|
      policies << {
        type: 'Health',
        policy_number: policy.policy_number,
        customer: policy.customer&.display_name || 'Unknown',
        premium: policy.total_premium,
        created_at: policy.created_at
      }
    end

    # Get recent life policies
    LifeInsurance.where(sub_agent_id: affiliate.id)
                 .includes(:customer)
                 .order(created_at: :desc)
                 .limit(3)
                 .each do |policy|
      policies << {
        type: 'Life',
        policy_number: policy.policy_number,
        customer: policy.customer&.display_name || 'Unknown',
        premium: policy.total_premium,
        created_at: policy.created_at
      }
    end

    # Get recent motor policies
    MotorInsurance.where(sub_agent_id: affiliate.id)
                  .includes(:customer)
                  .order(created_at: :desc)
                  .limit(2)
                  .each do |policy|
      policies << {
        type: 'Motor',
        policy_number: policy.policy_number,
        customer: policy.customer&.display_name || 'Unknown',
        premium: policy.total_premium,
        created_at: policy.created_at
      }
    end

    # Sort by creation date and return top 5
    policies.sort_by { |p| p[:created_at] }.reverse.first(5)
  end
end
