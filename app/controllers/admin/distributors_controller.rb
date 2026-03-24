class Admin::DistributorsController < Admin::ApplicationController
  include ConfigurablePagination
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

    # Order and paginate using configurable pagination
    @distributors = paginate_records(@distributors.order(created_at: :desc))

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

    # Get actual distributor payout data
    @distributor_payout_data = calculate_single_distributor_payouts(@distributor.id)

    # Overall distributor statistics (excluding commission calculation)
    @distributor_stats = calculate_distributor_stats_basic
  end

  # GET /admin/distributors/new
  def new
    @distributor = Distributor.new
    @distributor.role_id = 'distributor'
    @distributor.distributor_documents.build
    @investors = Investor.all
  end

  # GET /admin/distributors/1/edit
  def edit
    # Documents are already loaded via set_distributor before_action
    @distributor.distributor_documents.build if @distributor.distributor_documents.empty?
    @investors = Investor.all
    # Preload assigned sub_agents to avoid N+1 queries
    @assigned_sub_agent_ids = @distributor.assigned_sub_agents.pluck(:id).to_set
  end

  # POST /admin/distributors
  def create
    Rails.logger.info "=== DISTRIBUTOR CREATE PARAMS ==="
    Rails.logger.info "Documents attributes: #{params[:distributor][:distributor_documents_attributes].inspect}"
    Rails.logger.info "Assigned affiliate IDs from params: #{params[:distributor][:assigned_affiliate_ids].inspect}"

    # Extract permitted parameters
    permitted_params = distributor_params
    assigned_affiliate_ids = permitted_params.delete(:assigned_affiliate_ids)

    # Handle upload_main_document separately to avoid ActiveStorage issues
    main_document = permitted_params.delete(:upload_main_document)

    # Process document files before creating distributor
    documents_attributes = permitted_params[:distributor_documents_attributes]
    if documents_attributes.present?
      documents_attributes.each do |key, doc_attrs|
        if doc_attrs[:document_file].present?
          # Store the file in the document attributes for processing by the model
          # The DistributorDocument model will handle the R2 upload in its before_save callback
        end
      end
    end

    @distributor = Distributor.new(permitted_params)
    @distributor.role_id = 'distributor'

    if @distributor.save
      # Attach main document after distributor is saved
      if main_document.present?
        begin
          @distributor.upload_main_document.attach(main_document)
        rescue => e
          Rails.logger.error "Failed to attach main document: #{e.message}"
          # Don't fail the whole creation for document attachment issues
        end
      end

      # Create user account for ambassador login (same logic as customers)
      create_ambassador_user_account(@distributor)
      handle_affiliate_assignments(@distributor, assigned_affiliate_ids)
      Rails.logger.info "Documents after create: #{@distributor.distributor_documents.count}"
      redirect_to admin_distributors_path, notice: 'Ambassador was successfully created with login credentials.'
    else
      Rails.logger.error "Create errors: #{@distributor.errors.full_messages}"
      @distributor.distributor_documents.build if @distributor.distributor_documents.empty?
      @investors = Investor.all  # Reload investors for form rendering
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/distributors/1
  def update
    Rails.logger.info "=== DISTRIBUTOR UPDATE PARAMS ==="
    Rails.logger.info "Documents attributes: #{params[:distributor][:distributor_documents_attributes].inspect}"
    Rails.logger.info "Assigned affiliate IDs from params: #{params[:distributor][:assigned_affiliate_ids].inspect}"

    # Extract permitted parameters
    permitted_params = distributor_params
    assigned_affiliate_ids = permitted_params.delete(:assigned_affiliate_ids)

    # Handle upload_main_document separately to avoid ActiveStorage issues
    main_document = permitted_params.delete(:upload_main_document)

    if @distributor.update(permitted_params)
      # Attach main document after distributor is updated
      if main_document.present?
        begin
          @distributor.upload_main_document.attach(main_document)
        rescue => e
          Rails.logger.error "Failed to attach main document during update: #{e.message}"
          # Don't fail the whole update for document attachment issues
        end
      end
      handle_affiliate_assignments(@distributor, assigned_affiliate_ids)
      Rails.logger.info "Documents after update: #{@distributor.distributor_documents.count}"
      redirect_to admin_distributors_path, notice: 'Ambassador was successfully updated.'
    else
      Rails.logger.error "Update errors: #{@distributor.errors.full_messages}"
      @distributor.distributor_documents.build if @distributor.distributor_documents.empty?
      @investors = Investor.all  # Reload investors for form rendering
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/distributors/1
  def destroy
    # Check for relationships that would prevent deletion
    has_assigned_affiliates = @distributor.assigned_sub_agents.exists?
    has_direct_affiliates = @distributor.sub_agents.exists?

    # Check for insurance policies directly linked to this distributor
    has_health_policies = HealthInsurance.where(distributor_id: @distributor.id).exists? rescue false
    has_life_policies = LifeInsurance.where(distributor_id: @distributor.id).exists? rescue false
    has_motor_policies = MotorInsurance.where(distributor_id: @distributor.id).exists? rescue false
    has_other_policies = defined?(OtherInsurance) && OtherInsurance.where(distributor_id: @distributor.id).exists? rescue false

    # Check for distributor payouts
    has_payouts = defined?(DistributorPayout) && DistributorPayout.where(distributor_id: @distributor.id).exists? rescue false

    if has_assigned_affiliates || has_direct_affiliates || has_health_policies || has_life_policies || has_motor_policies || has_other_policies || has_payouts
      error_messages = []

      if has_assigned_affiliates || has_direct_affiliates
        affiliate_count = @distributor.assigned_sub_agents.count + @distributor.sub_agents.count
        error_messages << "#{affiliate_count} assigned affiliate(s)"
      end

      policy_count = 0
      policy_count += HealthInsurance.where(distributor_id: @distributor.id).count rescue 0
      policy_count += LifeInsurance.where(distributor_id: @distributor.id).count rescue 0
      policy_count += MotorInsurance.where(distributor_id: @distributor.id).count rescue 0
      policy_count += OtherInsurance.where(distributor_id: @distributor.id).count rescue 0 if defined?(OtherInsurance)

      if policy_count > 0
        error_messages << "#{policy_count} insurance policy(ies)"
      end

      if has_payouts
        payout_count = DistributorPayout.where(distributor_id: @distributor.id).count rescue 0
        error_messages << "#{payout_count} payout record(s)" if payout_count > 0
      end

      message = "Cannot delete ambassador with #{error_messages.join(', ')}. Please reassign or remove these records first."
      redirect_to admin_distributors_path, alert: message
    else
      begin
        # Delete associated records that don't have proper cascade setup
        @distributor.distributor_documents.destroy_all
        @distributor.distributor_assignments.destroy_all

        # Now destroy the distributor
        @distributor.destroy!
        redirect_to admin_distributors_path, notice: 'Ambassador was successfully deleted.'
      rescue => e
        redirect_to admin_distributors_path,
                    alert: "Failed to delete ambassador: #{e.message}"
      end
    end
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

  # PATCH /admin/distributors/1/deactivate
  def deactivate
    @distributor = Distributor.find(params[:id])
    if @distributor.deactivate!
      redirect_to admin_distributors_path, notice: 'Ambassador was successfully deactivated.'
    else
      redirect_to admin_distributors_path, alert: 'Failed to deactivate ambassador.'
    end
  end

  # PATCH /admin/distributors/1/activate
  def activate
    @distributor = Distributor.find(params[:id])
    if @distributor.activate!
      redirect_to admin_distributors_path, notice: 'Ambassador was successfully activated.'
    else
      redirect_to admin_distributors_path, alert: 'Failed to activate ambassador.'
    end
  end

  private

  def create_ambassador_user_account(distributor)
    return unless distributor&.email.present?

    # Check if user already exists
    existing_user = User.find_by(email: distributor.email)
    return if existing_user

    # Get ambassador roles
    ambassador_user_role = UserRole.find_by(name: 'Ambassador')
    ambassador_role = Role.find_by(name: 'ambassador') || Role.find_by(name: 'Ambassador')

    # Determine password based on form selection
    password = determine_ambassador_password

    begin
      # Create user with determined password
      user = User.create!(
        first_name: distributor.first_name || 'Ambassador',
        last_name: distributor.last_name || 'User',
        email: distributor.email,
        password: password,
        password_confirmation: password,
        mobile: distributor.mobile,
        user_type: 'ambassador',
        role: ambassador_role,
        user_role: ambassador_user_role,
        status: true,
        original_password: password
      )

      Rails.logger.info "✅ Ambassador user account created: #{user.email} with password: #{password}"
    rescue => e
      Rails.logger.error "❌ Failed to create ambassador user: #{e.message}"
    end
  end

  def set_distributor
    @distributor = Distributor.includes(distributor_documents: { document_file_attachment: :blob }).find(params[:id])
  end

  def determine_ambassador_password
    password_option = params[:password_option] || 'auto_generate'

    if password_option == 'manual' && params[:distributor][:password].present?
      params[:distributor][:password]
    else
      'Ganesha@123'
    end
  end

  def distributor_params
    params.require(:distributor).permit(
      :first_name, :middle_name, :last_name, :mobile, :email, :role_id,
      :state_id, :city_id, :state, :city, :birth_date, :gender, :pan_no, :gst_no,
      :company_name, :address, :bank_name, :account_no, :ifsc_code,
      :account_holder_name, :account_type, :upi_id, :status, :upload_main_document, :investor_id,
      :password, :password_confirmation,
      assigned_affiliate_ids: [],
      distributor_documents_attributes: [:id, :document_type, :document_file, :_destroy],
      uploaded_documents_attributes: [:id, :title, :description, :document_type, :file, :uploaded_by, :_destroy]
    )
  end

  def handle_affiliate_assignments(distributor, assigned_affiliate_ids)
    Rails.logger.info "=== AFFILIATE ASSIGNMENT DEBUG ==="
    Rails.logger.info "assigned_affiliate_ids: #{assigned_affiliate_ids.inspect}"
    Rails.logger.info "assigned_affiliate_ids class: #{assigned_affiliate_ids.class}"

    # Always remove existing assignments first
    Rails.logger.info "Removing existing assignments for distributor #{distributor.id}"
    distributor.distributor_assignments.destroy_all

    # Handle the case where no affiliates are selected (unassign all)
    if assigned_affiliate_ids.nil? || assigned_affiliate_ids.empty?
      Rails.logger.info "No affiliates selected - all assignments removed"
      return
    end

    # Ensure we have an array
    assigned_affiliate_ids = Array(assigned_affiliate_ids) unless assigned_affiliate_ids.is_a?(Array)

    # Create new assignments
    assigned_affiliate_ids.reject(&:blank?).each do |sub_agent_id|
      sub_agent = SubAgent.find_by(id: sub_agent_id)
      if sub_agent
        Rails.logger.info "Assigning affiliate #{sub_agent.display_name} (ID: #{sub_agent.id}) to distributor #{distributor.id}"

        # Remove any existing assignment for this sub_agent to other distributors
        DistributorAssignment.where(sub_agent: sub_agent).destroy_all

        # Create new assignment
        distributor.distributor_assignments.create!(
          sub_agent: sub_agent,
          assigned_at: Time.current
        )
      else
        Rails.logger.warn "SubAgent with ID #{sub_agent_id} not found"
      end
    end

    Rails.logger.info "Final assignment count for distributor #{distributor.id}: #{distributor.distributor_assignments.count}"
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

    # Calculate distributor commission from commission_payouts table
    health_commission = CommissionPayout.where(
      policy_type: 'health',
      policy_id: health_policies.pluck(:id),
      payout_to: 'ambassador'
    ).sum(:payout_amount).to_f

    life_commission = CommissionPayout.where(
      policy_type: 'life',
      policy_id: life_policies.pluck(:id),
      payout_to: 'ambassador'
    ).sum(:payout_amount).to_f

    motor_commission = CommissionPayout.where(
      policy_type: 'motor',
      policy_id: motor_policies.pluck(:id),
      payout_to: 'ambassador'
    ).sum(:payout_amount).to_f

    total_commission = (health_commission + life_commission + motor_commission + other_policies_commission).to_f

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
        id: policy.id,
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
        id: policy.id,
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
        id: policy.id,
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

  def calculate_single_distributor_payouts(distributor_id)
    # Get all commission payouts for this specific distributor
    ambassador_commission_payouts = CommissionPayout.where(payout_to: 'ambassador').includes(:payout)

    leads = []
    total_amount = 0.0
    paid_amount = 0.0
    pending_amount = 0.0

    ambassador_commission_payouts.each do |commission_payout|
      # Get policy from commission payout
      policy = get_policy_from_commission_payout(commission_payout)
      next unless policy

      # Skip if main agent commission not received
      next unless policy.respond_to?(:main_agent_commission_received) && policy.main_agent_commission_received

      # Check if this payout belongs to our distributor
      policy_distributor_id = policy.distributor_id if policy.respond_to?(:distributor_id)
      next unless policy_distributor_id == distributor_id

      # Get or create lead
      lead = nil
      if commission_payout.lead_id.present?
        lead = Lead.find_by(lead_id: commission_payout.lead_id)
      end

      # Fallback: try to find lead by policy lead_id
      if lead.nil? && policy.respond_to?(:lead_id) && policy.lead_id.present?
        lead = Lead.find_by(lead_id: policy.lead_id)
      end

      # If no lead found, create a virtual lead object
      if lead.nil?
        lead = OpenStruct.new(
          id: "virtual_#{policy.id}",
          lead_id: policy.try(:lead_id) || "POLICY-#{policy.id}",
          created_at: policy.created_at
        )
      end

      distributor_commission = commission_payout.payout_amount.to_f
      already_paid = commission_payout.status == 'paid'

      total_amount += distributor_commission

      if already_paid
        paid_amount += distributor_commission
      else
        pending_amount += distributor_commission
      end

      leads << {
        lead: lead,
        commission: distributor_commission,
        paid: already_paid
      }
    end

    {
      leads: leads,
      total_amount: total_amount,
      paid_amount: paid_amount,
      pending_amount: pending_amount,
      lead_count: leads.count
    }
  end

  def calculate_distributor_stats_basic
    total_policies = 0
    total_premium = 0.0
    total_customers = 0

    @assigned_affiliates.each do |affiliate|
      stats = @affiliate_stats[affiliate.id]
      total_policies += stats[:total_policies]
      total_premium += stats[:total_premium]
      total_customers += stats[:customers_count]
    end

    {
      total_affiliates: @assigned_affiliates.count,
      active_affiliates: @assigned_affiliates.active.count,
      total_policies: total_policies,
      total_premium: total_premium,
      total_customers: total_customers,
      avg_policies_per_affiliate: @assigned_affiliates.count > 0 ? (total_policies.to_f / @assigned_affiliates.count).round(2) : 0
    }
  end

  def get_policy_from_commission_payout(commission_payout)
    case commission_payout.policy_type
    when 'health'
      HealthInsurance.find_by(id: commission_payout.policy_id)
    when 'life'
      LifeInsurance.find_by(id: commission_payout.policy_id)
    when 'motor'
      MotorInsurance.find_by(id: commission_payout.policy_id)
    when 'other'
      OtherInsurance.find_by(id: commission_payout.policy_id) if defined?(OtherInsurance)
    end
  end
end
