class Admin::LeadsController < Admin::ApplicationController
  include LocationData
  before_action :set_lead, only: [:show, :edit, :update, :destroy, :convert_to_customer, :create_policy, :transfer_referral, :advance_stage, :go_back_stage, :update_stage]

  # GET /admin/leads
  def index
    @leads = Lead.all

    # Search functionality
    if params[:search].present?
      @leads = @leads.search_leads(params[:search])
    end

    # Filter by current stage
    if params[:current_stage].present?
      @leads = @leads.by_stage(params[:current_stage])
    end

    # Filter by lead source
    if params[:lead_source].present?
      @leads = @leads.by_source(params[:lead_source])
    end

    # Filter by product category
    if params[:product_category].present?
      @leads = @leads.by_product_category(params[:product_category])
    end

    # Filter by product subcategory
    if params[:product_subcategory].present?
      @leads = @leads.by_product_subcategory(params[:product_subcategory])
    end

    # Filter by referred by
    if params[:referred_by].present?
      @leads = @leads.where("referred_by ILIKE ?", "%#{params[:referred_by]}%")
    end

    @leads = @leads.order(created_at: :desc).includes(:converted_customer, :created_policy)

    # Statistics for dashboard
    @total_leads = Lead.count
    @consultation_leads = Lead.consultation.count
    @one_on_one_leads = Lead.one_on_one.count
    @converted_leads = Lead.converted.count
    @policy_created_leads = Lead.policy_created.count
    @referral_settled_leads = Lead.referral_settled.count

    # Conversion rate calculation
    total_converted = @converted_leads + @policy_created_leads + @referral_settled_leads
    @conversion_rate = @total_leads > 0 ? (total_converted.to_f / @total_leads * 100).round(1) : 0

    # Pipeline stats
    @pipeline_stats = {
      consultation: @consultation_leads,
      one_on_one: @one_on_one_leads,
      converted: @converted_leads,
      policy_created: @policy_created_leads,
      referral_settled: @referral_settled_leads
    }

    # Temporarily use simple view for debugging
    if params[:debug] == 'simple'
      render 'index_simple'
    end
  end

  # GET /admin/leads/1
  def show
    @activity_logs = []
  end

  # GET /admin/leads/new
  def new
    @lead = Lead.new
    @lead.created_date = Date.current
    @lead.current_stage = 'consultation'
  end

  # GET /admin/leads/1/edit
  def edit
  end

  # POST /admin/leads
  def create
    @lead = Lead.new(lead_params)
    @lead.created_date = Date.current if @lead.created_date.blank?

    if @lead.save
      redirect_to admin_leads_path, notice: 'Lead was successfully created.'
    else
      Rails.logger.error "Lead creation failed: #{@lead.errors.full_messages.join(', ')}"
      flash.now[:alert] = "Failed to create lead: #{@lead.errors.full_messages.join(', ')}"
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
    # Check for relationships that would prevent deletion
    has_converted_customer = @lead.converted_customer_id.present?
    has_created_policy = @lead.created_policy.present?

    # Check if the converted customer has policies or other data
    customer_has_policies = false
    if has_converted_customer
      customer = Customer.find_by(id: @lead.converted_customer_id)
      if customer
        health_policies = HealthInsurance.where(customer_id: customer.id).exists? rescue false
        life_policies = LifeInsurance.where(customer_id: customer.id).exists? rescue false
        motor_policies = MotorInsurance.where(customer_id: customer.id).exists? rescue false
        other_policies = defined?(OtherInsurance) && OtherInsurance.where(customer_id: customer.id).exists? rescue false
        customer_has_policies = health_policies || life_policies || motor_policies || other_policies
      end
    end

    # Check for insurance policies directly linked to this lead
    has_lead_policies = false
    lead_policy_count = 0
    begin
      lead_policy_count += HealthInsurance.where(lead_id: @lead.lead_id).count rescue 0
      lead_policy_count += LifeInsurance.where(lead_id: @lead.lead_id).count rescue 0
      lead_policy_count += MotorInsurance.where(lead_id: @lead.lead_id).count rescue 0
      lead_policy_count += OtherInsurance.where(lead_id: @lead.lead_id).count rescue 0 if defined?(OtherInsurance)
      has_lead_policies = lead_policy_count > 0
    rescue
      has_lead_policies = false
      lead_policy_count = 0
    end

    if has_converted_customer || has_created_policy || customer_has_policies || has_lead_policies
      error_messages = []

      if has_converted_customer
        error_messages << "converted customer record"
      end

      if has_created_policy
        error_messages << "created policy"
      end

      if customer_has_policies
        error_messages << "customer with existing policies"
      end

      if has_lead_policies
        error_messages << "#{lead_policy_count} linked insurance policy(ies)"
      end

      message = "Cannot delete lead with #{error_messages.join(', ')}. This would cause data integrity issues."
      redirect_to admin_leads_path, alert: message
    else
      begin
        @lead.destroy!
        redirect_to admin_leads_path, notice: 'Lead was successfully deleted.'
      rescue ActiveRecord::RecordNotDestroyed => e
        redirect_to admin_leads_path, alert: "Failed to delete lead: #{e.message}"
      rescue => e
        redirect_to admin_leads_path, alert: "Failed to delete lead: #{e.message}"
      end
    end
  end

  # PATCH /admin/leads/1/convert_to_customer
  def convert_to_customer
    unless @lead.can_convert_to_customer?
      redirect_to admin_lead_path(@lead), alert: 'Lead cannot be converted at this stage.'
      return
    end

    # Check if customer already exists with same mobile or email
    existing_customer = nil
    if @lead.contact_number.present?
      existing_customer = Customer.find_by(mobile: @lead.contact_number)
    end

    if !existing_customer && @lead.email.present?
      existing_customer = Customer.find_by(email: @lead.email)
    end

    if existing_customer
      # Update existing customer with lead data and redirect to edit
      Rails.logger.info "Found existing customer #{existing_customer.id} for lead #{@lead.id}. Updating with latest lead data."

      # Prepare update attributes from lead
      update_attrs = {}

      if @lead.individual?
        # Update individual customer fields with non-blank lead data
        update_attrs[:first_name] = @lead.first_name if @lead.first_name.present?
        update_attrs[:middle_name] = @lead.middle_name if @lead.middle_name.present?
        update_attrs[:last_name] = @lead.last_name if @lead.last_name.present?
        update_attrs[:email] = @lead.email if @lead.email.present?
        update_attrs[:birth_date] = @lead.birth_date if @lead.birth_date.present?
        update_attrs[:gender] = @lead.gender if @lead.gender.present?
        update_attrs[:marital_status] = @lead.marital_status if @lead.marital_status.present?
        update_attrs[:pan_no] = @lead.pan_no if @lead.pan_no.present?
        update_attrs[:pan_number] = @lead.pan_no if @lead.pan_no.present?
        update_attrs[:height_feet] = @lead.height if @lead.height.present?
        update_attrs[:weight_kg] = @lead.weight if @lead.weight.present?
        update_attrs[:birth_place] = @lead.birth_place if @lead.birth_place.present?
        update_attrs[:education] = @lead.education if @lead.education.present?
        update_attrs[:business_job] = @lead.business_job if @lead.business_job.present?
        update_attrs[:business_name] = @lead.business_name if @lead.business_name.present?
        update_attrs[:job_name] = @lead.job_name if @lead.job_name.present?
        update_attrs[:occupation] = @lead.occupation if @lead.occupation.present?
        update_attrs[:type_of_duty] = @lead.type_of_duty if @lead.type_of_duty.present?
        update_attrs[:annual_income] = @lead.annual_income if @lead.annual_income.present?
        update_attrs[:additional_information] = @lead.additional_information if @lead.additional_information.present?
      elsif @lead.corporate?
        update_attrs[:company_name] = @lead.company_name if @lead.company_name.present?
        update_attrs[:email] = @lead.email if @lead.email.present?
        update_attrs[:pan_no] = @lead.pan_no if @lead.pan_no.present?
        update_attrs[:gst_no] = @lead.gst_no if @lead.gst_no.present?
      end

      # Always update address fields if present
      update_attrs[:address] = @lead.address if @lead.address.present?
      update_attrs[:state] = @lead.state if @lead.state.present?
      update_attrs[:city] = @lead.city if @lead.city.present?
      update_attrs[:lead_id] = @lead.lead_id if @lead.lead_id.present?

      # Update customer with lead data
      if update_attrs.any?
        existing_customer.update!(update_attrs)
        Rails.logger.info "Updated customer #{existing_customer.id} with lead data: #{update_attrs.keys.join(', ')}"
      end

      # Update lead to mark as converted
      @lead.update!(
        current_stage: 'converted',
        converted_customer_id: existing_customer.id
      )

      redirect_to edit_admin_customer_path(existing_customer),
                  notice: "Found existing customer and updated with latest lead information. Please review and save the changes."
      return
    end

    ActiveRecord::Base.transaction do
      # Prepare customer attributes based on customer type
      customer_attrs = {
        customer_type: @lead.customer_type || 'individual',
        mobile: @lead.contact_number,
        address: @lead.address.presence,
        state: @lead.state.presence,
        city: @lead.city.presence, # Ensure city is properly transferred
        lead_id: @lead.lead_id, # Map lead ID to customer
        status: true
      }

      if @lead.individual?
        # Individual customer attributes
        customer_attrs.merge!(
          first_name: @lead.first_name || extract_first_name(@lead.name),
          middle_name: @lead.middle_name.presence, # Use presence to convert empty strings to nil
          last_name: @lead.last_name || extract_last_name(@lead.name),
          email: @lead.email.presence,
          birth_date: @lead.birth_date,
          gender: @lead.gender.presence,
          marital_status: @lead.marital_status.presence,
          pan_no: @lead.pan_no.presence,
          pan_number: @lead.pan_no.presence, # Map to both PAN fields
          height_feet: @lead.height.presence,
          weight_kg: @lead.weight.presence,
          birth_place: @lead.birth_place.presence,
          education: @lead.education.presence,
          business_job: @lead.business_job.presence,
          business_name: @lead.business_name.presence,
          job_name: @lead.job_name.presence,
          occupation: @lead.occupation.presence,
          type_of_duty: @lead.type_of_duty.presence,
          annual_income: @lead.annual_income,
          additional_information: @lead.additional_information.presence
        )
      elsif @lead.corporate?
        # Corporate customer attributes
        customer_attrs.merge!(
          company_name: @lead.company_name || @lead.name,
          email: @lead.email.presence, # Required for corporate
          pan_no: @lead.pan_no.presence,
          gst_no: @lead.gst_no.presence
        )
      end

      # Debug: Log the attributes being passed
      Rails.logger.info "Converting lead #{@lead.id} to customer with attributes: #{customer_attrs.inspect}"

      # Create customer from lead data
      customer = Customer.create!(customer_attrs)

      # Debug: Log the created customer attributes with all individual fields
      Rails.logger.info "Created customer #{customer.id} with attributes:"
      Rails.logger.info "  - Name: #{customer.first_name} #{customer.middle_name} #{customer.last_name}"
      Rails.logger.info "  - Birth date: #{customer.birth_date}"
      Rails.logger.info "  - Gender: #{customer.gender}"
      Rails.logger.info "  - Marital status: #{customer.marital_status}"
      Rails.logger.info "  - PAN: #{customer.pan_no} / #{customer.pan_number}"
      Rails.logger.info "  - Height: #{customer.height_feet}"
      Rails.logger.info "  - Weight: #{customer.weight_kg}"
      Rails.logger.info "  - Birth place: #{customer.birth_place}"
      Rails.logger.info "  - Address: #{customer.address}"
      Rails.logger.info "  - City: #{customer.city}"
      Rails.logger.info "  - State: #{customer.state}"
      Rails.logger.info "  - Education: #{customer.education}"
      Rails.logger.info "  - Business/Job: #{customer.business_job}"
      Rails.logger.info "  - Business Name: #{customer.business_name}"
      Rails.logger.info "  - Job Name: #{customer.job_name}"
      Rails.logger.info "  - Occupation: #{customer.occupation}"
      Rails.logger.info "  - Type of Duty: #{customer.type_of_duty}"
      Rails.logger.info "  - Annual Income: #{customer.annual_income}"
      Rails.logger.info "  - Additional Info: #{customer.additional_information}"
      Rails.logger.info "  - Lead ID: #{customer.lead_id}"

      # Update lead with customer reference
      @lead.update!(
        current_stage: 'converted',
        converted_customer_id: customer.id
      )

      redirect_to edit_admin_customer_path(customer), notice: 'Lead successfully converted to customer. You can now review and edit the customer details.'
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Lead conversion failed for lead #{@lead.id}: #{e.message}"
    Rails.logger.error "Validation errors: #{e.record.errors.full_messages.join(', ')}"
    redirect_to admin_lead_path(@lead), alert: "Failed to convert lead: #{e.message} - Errors: #{e.record.errors.full_messages.join(', ')}"
  end

  # PATCH /admin/leads/1/create_policy
  def create_policy
    unless @lead.can_create_policy?
      redirect_to admin_lead_path(@lead), alert: 'Cannot create policy for this lead.'
      return
    end

    if @lead.product_category == 'insurance'
      case @lead.product_subcategory
      when 'health'
        redirect_to new_admin_health_insurance_path(customer_id: @lead.converted_customer_id, lead_id: @lead.id)
      when 'life'
        redirect_to new_admin_life_insurance_path(customer_id: @lead.converted_customer_id, lead_id: @lead.id)
      when 'motor'
        redirect_to new_admin_motor_insurance_path(customer_id: @lead.converted_customer_id, lead_id: @lead.id)
      when 'general', 'travel', 'other'
        redirect_to new_admin_other_insurance_path(customer_id: @lead.converted_customer_id, lead_id: @lead.id)
      else
        redirect_to admin_lead_path(@lead), alert: 'Unknown insurance type.'
      end
    else
      redirect_to admin_lead_path(@lead), alert: 'Policy creation is only available for insurance products.'
    end
  end

  # PATCH /admin/leads/1/transfer_referral
  def transfer_referral
    unless @lead.can_settle_referral?
      redirect_to admin_lead_path(@lead), alert: 'Referral cannot be settled at this stage.'
      return
    end

    ActiveRecord::Base.transaction do
      @lead.update!(
        current_stage: 'referral_settled',
        transferred_amount: true
      )

      redirect_to admin_lead_path(@lead), notice: 'Referral payment transferred successfully.'
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to admin_lead_path(@lead), alert: "Failed to transfer referral: #{e.message}"
  end

  # PATCH /admin/leads/1/advance_stage
  def advance_stage
    next_stage = @lead.next_stage

    unless next_stage
      redirect_to admin_lead_path(@lead), alert: 'Lead is already at the final stage.'
      return
    end

    if @lead.update(current_stage: next_stage)
      redirect_to admin_lead_path(@lead), notice: "Lead advanced to #{next_stage.humanize} stage."
    else
      redirect_to admin_lead_path(@lead), alert: 'Failed to advance lead stage.'
    end
  end

  # PATCH /admin/leads/1/go_back_stage
  def go_back_stage
    unless @lead.can_go_back?
      redirect_to admin_lead_path(@lead), alert: 'Cannot go back from current stage.'
      return
    end

    previous_stage = @lead.previous_stage
    if @lead.update(current_stage: previous_stage)
      redirect_to admin_lead_path(@lead), notice: "Lead moved back to #{previous_stage.humanize} stage."
    else
      redirect_to admin_lead_path(@lead), alert: 'Failed to move lead back.'
    end
  end

  # PATCH /admin/leads/1/update_stage
  def update_stage
    stage = params[:stage]

    unless Lead.current_stages.key?(stage)
      redirect_to admin_lead_path(@lead), alert: 'Invalid stage.'
      return
    end

    # Check if the lead can transition to this stage
    unless @lead.available_stages_for_transition.include?(stage)
      redirect_to admin_lead_path(@lead), alert: 'Cannot transition to this stage.'
      return
    end

    if @lead.update(current_stage: stage, stage_updated_at: Time.current)
      redirect_to admin_lead_path(@lead), notice: "Lead stage updated to #{stage.humanize}."
    else
      redirect_to admin_lead_path(@lead), alert: 'Failed to update lead stage.'
    end
  end

  # GET /admin/leads/check_existing_customer
  def check_existing_customer
    contact_number = params[:contact_number]
    email = params[:email]

    existing_customers = []

    # Check by contact number/mobile
    if contact_number.present?
      clean_contact = contact_number.gsub(/\D/, '')
      customer_by_mobile = Customer.where("mobile LIKE ?", "%#{clean_contact}%").first
      if customer_by_mobile
        existing_customers << {
          id: customer_by_mobile.id,
          name: customer_by_mobile.display_name,
          mobile: customer_by_mobile.mobile,
          email: customer_by_mobile.email,
          match_type: 'mobile'
        }
      end
    end

    # Check by email
    if email.present?
      customer_by_email = Customer.where(email: email).first
      if customer_by_email && !existing_customers.any? { |c| c[:id] == customer_by_email.id }
        existing_customers << {
          id: customer_by_email.id,
          name: customer_by_email.display_name,
          mobile: customer_by_email.mobile,
          email: customer_by_email.email,
          match_type: 'email'
        }
      end
    end

    render json: {
      exists: existing_customers.any?,
      customers: existing_customers
    }
  end

  # PATCH /admin/leads/bulk_update_stage
  def bulk_update_stage
    lead_ids = params[:lead_ids]
    new_stage = params[:stage]

    unless lead_ids.present? && Lead.current_stages.key?(new_stage)
      redirect_to admin_leads_path, alert: 'Invalid parameters for bulk update.'
      return
    end

    leads = Lead.where(id: lead_ids)
    updated_count = 0
    failed_count = 0

    leads.each do |lead|
      if lead.available_stages_for_transition.include?(new_stage)
        if lead.update(current_stage: new_stage, stage_updated_at: Time.current)
          updated_count += 1
        else
          failed_count += 1
        end
      else
        failed_count += 1
      end
    end

    if failed_count == 0
      redirect_to admin_leads_path, notice: "Successfully updated #{updated_count} leads to #{new_stage.humanize} stage."
    elsif updated_count > 0
      redirect_to admin_leads_path, notice: "Updated #{updated_count} leads. #{failed_count} leads could not be updated due to stage restrictions."
    else
      redirect_to admin_leads_path, alert: "No leads could be updated. Please check stage transition rules."
    end
  end

  private

  # JSON response helper method
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def set_lead
    @lead = Lead.find(params[:id])
  end

  def lead_params
    params.require(:lead).permit(
      :name, :contact_number, :email, :address, :city, :state,
      :referred_by, :product_category, :product_subcategory, :customer_type, :current_stage, :lead_source,
      :call_disposition, :referral_amount, :notes, :created_date,
      :note, :is_direct, :affiliate_id,
      :first_name, :middle_name, :last_name, :birth_date, :gender, :pan_no, :gst_no,
      :company_name, :marital_status, :height, :weight, :birth_place,
      :education, :business_job, :business_name, :job_name, :occupation,
      :type_of_duty, :annual_income, :additional_information
    )
  end

  def extract_first_name(full_name)
    full_name.to_s.split(' ').first || 'Unknown'
  end

  def extract_last_name(full_name)
    names = full_name.to_s.split(' ')
    names.length > 1 ? names[1..-1].join(' ') : 'Unknown'
  end
end