class Api::V1::Mobile::AgentController < Api::V1::Mobile::BaseController
  before_action :authenticate_agent!

  # GET /api/v1/mobile/agent/dashboard
  def dashboard
    agent = current_user

    # Get dashboard statistics
    stats = get_dashboard_statistics(agent)

    render json: {
      success: true,
      data: {
        agent_info: {
          name: agent.full_name,
          email: agent.email,
          mobile: agent.mobile,
          role: agent.role
        },
        statistics: stats,
        recent_activities: get_recent_activities(agent)
      }
    }
  end

  # GET /api/v1/mobile/agent/customers
  def customers
    agent = current_user
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    filter = params[:filter] # 'all', 'agent_added', 'system_added'

    customers = if agent.user_type == 'admin'
                  Customer.all
                else
                  # For agents, show customers from their policies and customers they added
                  policy_customer_ids = (HealthInsurance.pluck(:customer_id) + LifeInsurance.pluck(:customer_id)).uniq
                  agent_added_customers = Customer.where("added_by LIKE ?", "%agent_mobile_api_#{agent.id}%")
                  Customer.where(id: policy_customer_ids).or(agent_added_customers)
                end

    # Apply filter
    case filter
    when 'agent_added'
      customers = customers.where("added_by LIKE ?", "%agent_mobile_api_%")
    when 'system_added'
      customers = customers.where("added_by IS NULL OR added_by NOT LIKE ?", "%agent_mobile_api_%")
    # 'all' or nil shows all customers
    end

    customers = customers.active.page(page).per(per_page)

    customers_data = customers.map do |customer|
      {
        id: customer.id,
        name: customer.display_name,
        mobile: customer.mobile,
        email: customer.email,
        password: generate_demo_password(customer), # Demo password for testing
        customer_type: customer.customer_type,
        status: customer.active? ? 'Active' : 'Inactive',
        policies_count: get_customer_policies_count(customer),
        total_premium: get_customer_total_premium(customer),
        added_by: customer.added_by || 'system',
        added_via: determine_add_source(customer.added_by),
        created_at: customer.created_at
      }
    end

    # Get statistics for different types
    stats = get_customer_statistics(agent)

    render json: {
      success: true,
      data: {
        customers: customers_data,
        statistics: stats,
        pagination: {
          current_page: page.to_i,
          per_page: per_page.to_i,
          total_customers: customers.total_count,
          total_pages: customers.total_pages
        }
      }
    }
  end

  # POST /api/v1/mobile/agent/customers
  def add_customer
    customer_params = params.permit(
      :customer_type, :first_name, :last_name, :company_name, :email,
      :mobile, :gender, :birth_date, :address, :city, :state, :pincode,
      :pan_no, :gst_no, :occupation, :annual_income, :marital_status,
      :image_url, :file1, :file2
    )

    # Validation: Check required fields
    validation_errors = []
    validation_errors << 'First name is required' if customer_params[:first_name].blank?
    validation_errors << 'Mobile number is required' if customer_params[:mobile].blank?
    validation_errors << 'Email is required' if customer_params[:email].blank?

    # Validate phone number format
    if customer_params[:mobile].present?
      clean_phone = customer_params[:mobile].gsub(/\D/, '')
      unless clean_phone.match?(/^[6-9]\d{9}$/)
        validation_errors << 'Invalid phone number format. Must be a valid Indian mobile number'
      end
    end

    # Validate email format
    if customer_params[:email].present? && !customer_params[:email].match?(URI::MailTo::EMAIL_REGEXP)
      validation_errors << 'Invalid email format'
    end

    # Check for existing customer with same email or mobile
    if customer_params[:email].present? && Customer.exists?(email: customer_params[:email])
      validation_errors << 'Customer with this email already exists'
    end

    if customer_params[:mobile].present? && Customer.exists?(mobile: customer_params[:mobile])
      validation_errors << 'Customer with this mobile number already exists'
    end

    if validation_errors.any?
      return render json: {
        status: false,
        message: 'Validation failed',
        errors: validation_errors
      }, status: :unprocessable_entity
    end

    customer = Customer.new(customer_params.except(:file1, :file2).merge(
      status: true,
      added_by: "agent_mobile_api_#{current_user.id}" # Track agent who added customer
    ))

    if customer.save
      # Handle file uploads
      file_info = handle_customer_file_uploads(customer, params[:file1], params[:file2])

      render json: {
        status: true,
        message: 'Customer created successfully',
        data: {
          customer_id: customer.id,
          name: customer.display_name,
          email: customer.email,
          mobile: customer.mobile,
          image_url: customer.image_url,
          customer_type: customer.customer_type,
          gender: customer.gender,
          birth_date: customer.birth_date&.strftime('%Y-%m-%d'),
          address: customer.address,
          city: customer.city,
          state: customer.state,
          pincode: customer.pincode,
          pan_no: customer.pan_no,
          occupation: customer.occupation,
          annual_income: customer.annual_income,
          marital_status: customer.marital_status,
          files: file_info,
          added_by: customer.added_by,
          added_by_agent: {
            id: current_user.id,
            name: current_user.full_name,
            email: current_user.email
          },
          created_at: customer.created_at.strftime('%Y-%m-%d %H:%M:%S')
        }
      }, status: :created
    else
      render json: {
        status: false,
        message: 'Failed to create customer',
        errors: customer.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/mobile/agent/policies
  def policies
    agent = current_user
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    policy_type = params[:policy_type] # 'health', 'life', 'motor', 'other', or 'all'

    policies = []

    # Get health insurance policies
    if policy_type.blank? || policy_type == 'health' || policy_type == 'all'
      health_policies = if agent.user_type == 'admin'
                         HealthInsurance.all
                       else
                         HealthInsurance.joins(:customer)
                       end

      health_policies.includes(:customer).each do |policy|
        policies << format_policy_data(policy, 'Health')
      end
    end

    # Get life insurance policies
    if policy_type.blank? || policy_type == 'life' || policy_type == 'all'
      life_policies = if agent.user_type == 'admin'
                       LifeInsurance.all
                     else
                       LifeInsurance.joins(:customer)
                     end

      life_policies.includes(:customer).each do |policy|
        policies << format_policy_data(policy, 'Life')
      end
    end

    # Get motor insurance policies
    if policy_type.blank? || policy_type == 'motor' || policy_type == 'all'
      motor_policies = if agent.user_type == 'admin'
                         Policy.where(insurance_type: 'motor')
                       else
                         Policy.where(insurance_type: 'motor', user: agent)
                       end

      motor_policies.includes(:customer).each do |policy|
        policies << format_policy_data(policy, 'Motor')
      end
    end

    # Get other insurance policies
    if policy_type.blank? || policy_type == 'other' || policy_type == 'all'
      other_policies = if agent.user_type == 'admin'
                         Policy.where(insurance_type: 'other')
                       else
                         Policy.where(insurance_type: 'other', user: agent)
                       end

      other_policies.includes(:customer).each do |policy|
        policies << format_policy_data(policy, 'Other')
      end
    end

    # Sort by creation date (newest first)
    policies = policies.sort_by { |p| p[:created_at] }.reverse

    # Paginate manually
    total_policies = policies.count
    start_index = (page.to_i - 1) * per_page.to_i
    end_index = start_index + per_page.to_i - 1
    paginated_policies = policies[start_index..end_index] || []

    render json: {
      success: true,
      data: {
        policies: paginated_policies,
        pagination: {
          current_page: page.to_i,
          per_page: per_page.to_i,
          total_policies: total_policies,
          total_pages: (total_policies.to_f / per_page.to_i).ceil
        }
      }
    }
  end

  # POST /api/v1/mobile/agent/policies/health
  def add_health_policy
    # Updated parameter structure based on your specification
    policy_params = params.permit(
      :client_id, :policy_holder, :insurance_company_id, :policy_type, :insurance_type,
      :plan_name, :policy_number, :policy_booking_date, :policy_start_date, :policy_end_date,
      :policy_term_years, :payment_mode, :sum_insured, :net_premium, :gst_percentage, :total_premium,
      :installment_autopay_start_date, :installment_autopay_end_date,
      family_members: [:full_name, :age, :relationship, :sum_insured],
      documents: [:document_type, :document_file]
    )

    # Validation: Check required fields
    validation_errors = []
    validation_errors << 'Client ID is required' if policy_params[:client_id].blank?
    validation_errors << 'Policy holder is required' if policy_params[:policy_holder].blank?
    validation_errors << 'Insurance company ID is required' if policy_params[:insurance_company_id].blank?
    validation_errors << 'Plan name is required' if policy_params[:plan_name].blank?
    validation_errors << 'Policy number is required' if policy_params[:policy_number].blank?
    validation_errors << 'Net premium is required' if policy_params[:net_premium].blank?

    if validation_errors.any?
      return render json: {
        status: false,
        message: 'Validation failed',
        errors: validation_errors
      }, status: :unprocessable_entity
    end

    # Find customer (client)
    customer = Customer.find_by(id: policy_params[:client_id])
    unless customer
      return render json: {
        status: false,
        message: 'Customer not found'
      }, status: :not_found
    end

    # Check if policy number already exists
    if HealthInsurance.exists?(policy_number: policy_params[:policy_number])
      return render json: {
        status: false,
        message: 'Validation failed',
        errors: {
          policy_number: ['has already been taken']
        }
      }, status: :unprocessable_entity
    end

    # Calculate total premium if not provided
    calculated_total_premium = if policy_params[:total_premium].present?
                                policy_params[:total_premium].to_f
                              else
                                net_premium = policy_params[:net_premium].to_f
                                gst_percentage = policy_params[:gst_percentage].to_f || 18.0
                                net_premium + (net_premium * gst_percentage / 100.0)
                              end

    # Create health insurance policy
    policy = HealthInsurance.new(
      customer_id: policy_params[:client_id],
      policy_holder: policy_params[:policy_holder],
      insurance_company_name: get_company_name_by_id(policy_params[:insurance_company_id]),
      policy_type: policy_params[:policy_type],
      insurance_type: policy_params[:insurance_type] || 'health',
      plan_name: policy_params[:plan_name],
      policy_number: policy_params[:policy_number],
      policy_booking_date: parse_date(policy_params[:policy_booking_date]) || Date.current,
      policy_start_date: parse_date(policy_params[:policy_start_date]),
      policy_end_date: parse_date(policy_params[:policy_end_date]),
      payment_mode: policy_params[:payment_mode],
      sum_insured: policy_params[:sum_insured],
      net_premium: policy_params[:net_premium],
      gst_percentage: policy_params[:gst_percentage] || 18.0,
      total_premium: calculated_total_premium,
      sub_agent: current_user,
      added_by: "agent_mobile_api_#{current_user.id}"
    )

    if policy.save
      # Handle family members
      if params[:family_members].present?
        params[:family_members].each do |member_data|
          create_family_member(policy, member_data)
        end
      end

      # Handle document uploads
      if params[:documents].present?
        handle_document_uploads(policy, params[:documents])
      end

      render json: {
        status: true,
        message: 'Health policy created successfully',
        data: {
          policy_id: policy.id,
          policy_number: policy.policy_number,
          client_name: customer.display_name,
          total_premium: policy.total_premium,
          created_at: policy.created_at.strftime('%Y-%m-%d %H:%M:%S')
        }
      }, status: :created
    else
      render json: {
        status: false,
        message: 'Validation failed',
        errors: policy.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/mobile/agent/policies/life
  def add_life_policy
    # Updated parameter structure based on the API documentation
    policy_params = params.permit(
      :client_id, :policy_holder, :insured_name, :insurance_company_id, :agency_code_id,
      :policy_type, :payment_mode, :policy_number, :policy_booking_date, :policy_start_date, :policy_end_date,
      :policy_term_years, :premium_payment_term_years, :plan_name, :sum_insured, :net_premium,
      :gst_percentage_year_1, :gst_percentage_year_2, :gst_percentage_year_3, :total_premium,
      :reference_by_name, :installment_autopay_start_date, :installment_autopay_end_date,
      nominees: [:nominee_name, :relationship, :age],
      bank_details: [:bank_name, :account_type, :account_number, :ifsc_code, :account_holder_name],
      documents: [:document_type, :document_file]
    )

    # Validation: Check required fields
    validation_errors = []
    validation_errors << 'Client ID is required' if policy_params[:client_id].blank?
    validation_errors << 'Policy holder is required' if policy_params[:policy_holder].blank?
    validation_errors << 'Insured name is required' if policy_params[:insured_name].blank?
    validation_errors << 'Insurance company ID is required' if policy_params[:insurance_company_id].blank?
    validation_errors << 'Policy number is required' if policy_params[:policy_number].blank?
    validation_errors << 'Policy start date is required' if policy_params[:policy_start_date].blank?
    validation_errors << 'Policy end date is required' if policy_params[:policy_end_date].blank?
    validation_errors << 'Policy term years is required' if policy_params[:policy_term_years].blank?
    validation_errors << 'Premium payment term years is required' if policy_params[:premium_payment_term_years].blank?
    validation_errors << 'Net premium is required' if policy_params[:net_premium].blank?
    validation_errors << 'GST percentage year 1 is required' if policy_params[:gst_percentage_year_1].blank?

    if validation_errors.any?
      return render json: {
        status: false,
        message: 'Validation failed',
        errors: validation_errors
      }, status: :unprocessable_entity
    end

    # Find customer (client)
    customer = Customer.find_by(id: policy_params[:client_id])
    unless customer
      return render json: {
        status: false,
        message: 'Customer not found'
      }, status: :not_found
    end

    # Check if policy number already exists
    if LifeInsurance.exists?(policy_number: policy_params[:policy_number])
      return render json: {
        status: false,
        message: 'Validation failed',
        errors: {
          policy_number: ['already exists']
        }
      }, status: :unprocessable_entity
    end

    # Calculate total premium if not provided
    calculated_total_premium = if policy_params[:total_premium].present?
                                policy_params[:total_premium].to_f
                              else
                                net_premium = policy_params[:net_premium].to_f
                                gst_percentage = policy_params[:gst_percentage_year_1].to_f
                                net_premium + (net_premium * gst_percentage / 100.0)
                              end

    # Map policy type values
    mapped_policy_type = case policy_params[:policy_type]
                        when 'term', 'endowment', 'ulip'
                          'New'
                        else
                          'New'
                        end

    # Create life insurance policy with the correct field mappings
    policy = LifeInsurance.new(
      customer_id: policy_params[:client_id],
      policy_holder: policy_params[:policy_holder],
      insured_name: policy_params[:insured_name],
      insurance_company_name: get_company_name_by_id(policy_params[:insurance_company_id]),
      agency_code_id: policy_params[:agency_code_id],
      policy_type: mapped_policy_type,
      payment_mode: policy_params[:payment_mode]&.capitalize || 'Yearly',
      policy_number: policy_params[:policy_number],
      policy_booking_date: parse_date(policy_params[:policy_booking_date]) || Date.current,
      policy_start_date: parse_date(policy_params[:policy_start_date]),
      policy_end_date: parse_date(policy_params[:policy_end_date]),
      policy_term: policy_params[:policy_term_years],
      premium_payment_term: policy_params[:premium_payment_term_years],
      plan_name: policy_params[:plan_name],
      sum_insured: policy_params[:sum_insured],
      net_premium: policy_params[:net_premium],
      first_year_gst_percentage: policy_params[:gst_percentage_year_1],
      second_year_gst_percentage: policy_params[:gst_percentage_year_2],
      third_year_gst_percentage: policy_params[:gst_percentage_year_3],
      total_premium: calculated_total_premium,
      reference_by_name: policy_params[:reference_by_name],
      installment_autopay_start_date: parse_date(policy_params[:installment_autopay_start_date]),
      installment_autopay_end_date: parse_date(policy_params[:installment_autopay_end_date]),
      sub_agent: current_user,
      is_agent_added: true,
      is_customer_added: false,
      is_admin_added: false
    )

    if policy.save
      # Handle nominees
      if params[:nominees].present?
        params[:nominees].each do |nominee_data|
          create_life_insurance_nominee(policy, nominee_data)
        end
      end

      # Handle bank details
      if params[:bank_details].present?
        create_life_insurance_bank_details(policy, params[:bank_details])
      end

      # Handle document uploads
      if params[:documents].present?
        handle_life_insurance_document_uploads(policy, params[:documents])
      end

      render json: {
        status: true,
        message: 'Life policy created successfully',
        data: {
          policy_id: policy.id,
          policy_number: policy.policy_number,
          client_name: customer.display_name,
          total_premium: policy.total_premium,
          created_at: policy.created_at.strftime('%Y-%m-%d %H:%M:%S')
        }
      }, status: :created
    else
      render json: {
        status: false,
        message: 'Validation failed',
        errors: policy.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/mobile/agent/policies/motor
  def add_motor_policy
    policy_params = params.permit(
      :customer_id, :policy_holder, :plan_name, :policy_number,
      :insurance_company_name, :policy_type, :policy_start_date, :policy_end_date,
      :payment_mode, :sum_insured, :net_premium, :gst_percentage, :total_premium,
      :agent_commission_percentage, :commission_amount, :vehicle_make, :vehicle_model,
      :vehicle_number, :vehicle_year, :engine_number, :chassis_number, :vehicle_type
    )

    if policy_params[:customer_id].blank?
      return render json: {
        success: false,
        message: 'Customer ID is required'
      }, status: :unprocessable_entity
    end

    customer = Customer.find_by(id: policy_params[:customer_id])
    unless customer
      return render json: {
        success: false,
        message: 'Customer not found'
      }, status: :not_found
    end

    # For Motor insurance, we can use the Policy model with motor type
    policy = Policy.new(
      customer: customer,
      user: current_user,
      insurance_company_id: 1, # Default, should be dynamic
      agency_broker_id: 1, # Default, should be dynamic
      policy_number: policy_params[:policy_number],
      plan_name: policy_params[:plan_name],
      insurance_type: 'motor',
      policy_type: policy_params[:policy_type] == 'renewal' ? 'renewal' : 'new_policy',
      policy_start_date: policy_params[:policy_start_date],
      policy_end_date: policy_params[:policy_end_date],
      payment_mode: policy_params[:payment_mode] || 'yearly',
      sum_insured: policy_params[:sum_insured],
      net_premium: policy_params[:net_premium],
      gst_percentage: policy_params[:gst_percentage] || 18,
      total_premium: policy_params[:total_premium],
      agent_commission_percentage: policy_params[:agent_commission_percentage],
      commission_amount: policy_params[:commission_amount],
      status: true
    )

    if policy.save
      # Create motor insurance specific data
      motor_insurance = MotorInsurance.create!(
        policy: policy,
        vehicle_make: policy_params[:vehicle_make],
        vehicle_model: policy_params[:vehicle_model],
        vehicle_number: policy_params[:vehicle_number],
        vehicle_year: policy_params[:vehicle_year],
        engine_number: policy_params[:engine_number],
        chassis_number: policy_params[:chassis_number],
        vehicle_type: policy_params[:vehicle_type]
      )

      render json: {
        success: true,
        message: 'Motor insurance policy added successfully',
        data: format_policy_data(policy, 'Motor')
      }
    else
      render json: {
        success: false,
        message: 'Failed to add motor insurance policy',
        errors: policy.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/mobile/agent/policies/other
  def add_other_policy
    policy_params = params.permit(
      :customer_id, :policy_holder, :plan_name, :policy_number,
      :insurance_company_name, :policy_type, :policy_start_date, :policy_end_date,
      :payment_mode, :sum_insured, :net_premium, :gst_percentage, :total_premium,
      :agent_commission_percentage, :commission_amount, :coverage_type, :description
    )

    if policy_params[:customer_id].blank?
      return render json: {
        success: false,
        message: 'Customer ID is required'
      }, status: :unprocessable_entity
    end

    customer = Customer.find_by(id: policy_params[:customer_id])
    unless customer
      return render json: {
        success: false,
        message: 'Customer not found'
      }, status: :not_found
    end

    # For Other insurance, we can use the Policy model with other type
    policy = Policy.new(
      customer: customer,
      user: current_user,
      insurance_company_id: 1, # Default, should be dynamic
      agency_broker_id: 1, # Default, should be dynamic
      policy_number: policy_params[:policy_number],
      plan_name: policy_params[:plan_name],
      insurance_type: 'other',
      policy_type: policy_params[:policy_type] == 'renewal' ? 'renewal' : 'new_policy',
      policy_start_date: policy_params[:policy_start_date],
      policy_end_date: policy_params[:policy_end_date],
      payment_mode: policy_params[:payment_mode] || 'yearly',
      sum_insured: policy_params[:sum_insured],
      net_premium: policy_params[:net_premium],
      gst_percentage: policy_params[:gst_percentage] || 18,
      total_premium: policy_params[:total_premium],
      agent_commission_percentage: policy_params[:agent_commission_percentage],
      commission_amount: policy_params[:commission_amount],
      status: true
    )

    if policy.save
      # Create other insurance specific data
      other_insurance = OtherInsurance.create!(
        policy: policy,
        coverage_type: policy_params[:coverage_type],
        description: policy_params[:description]
      )

      render json: {
        success: true,
        message: 'Other insurance policy added successfully',
        data: format_policy_data(policy, 'Other')
      }
    else
      render json: {
        success: false,
        message: 'Failed to add other insurance policy',
        errors: policy.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/mobile/agent/leads
  def add_lead
    # Updated parameter structure for leads
    lead_params = params.permit(
      :name, :contact_number, :email, :product_interest, :address, :city, :state,
      :referred_by, :current_stage, :created_date, :priority, :note, :call_disposition,
      :lead_source, :referral_amount, :transferred_amount
    )

    # Validation: Check required fields
    validation_errors = []
    validation_errors << 'Name is required' if lead_params[:name].blank?
    validation_errors << 'Contact number is required' if lead_params[:contact_number].blank?
    validation_errors << 'Product interest is required' if lead_params[:product_interest].blank?

    # Validate phone number format
    if lead_params[:contact_number].present?
      clean_phone = lead_params[:contact_number].gsub(/\D/, '')
      unless clean_phone.match?(/^[6-9]\d{9}$/)
        validation_errors << 'Invalid phone number format. Must be a valid Indian mobile number'
      end
    end

    # Validate email format if provided
    if lead_params[:email].present? && !lead_params[:email].match?(URI::MailTo::EMAIL_REGEXP)
      validation_errors << 'Invalid email format'
    end

    # Validate product interest
    valid_products = ['health', 'life', 'motor', 'home', 'travel', 'other']
    if lead_params[:product_interest].present? && !valid_products.include?(lead_params[:product_interest])
      validation_errors << 'Invalid product interest'
    end

    # Validate current stage
    valid_stages = ['consultation', 'one_on_one', 'converted', 'policy_created', 'referral_settled']
    if lead_params[:current_stage].present? && !valid_stages.include?(lead_params[:current_stage])
      validation_errors << 'Invalid current stage'
    end

    if validation_errors.any?
      return render json: {
        status: false,
        message: 'Validation failed',
        errors: validation_errors
      }, status: :unprocessable_entity
    end

    # Check if lead with same contact number already exists
    existing_lead = Lead.find_by(contact_number: lead_params[:contact_number])
    if existing_lead
      return render json: {
        status: false,
        message: 'Validation failed',
        errors: {
          contact_number: ['A lead with this contact number already exists']
        }
      }, status: :unprocessable_entity
    end

    # Create lead with default values
    lead = Lead.new(
      name: lead_params[:name],
      contact_number: lead_params[:contact_number],
      email: lead_params[:email],
      product_interest: lead_params[:product_interest],
      address: lead_params[:address],
      city: lead_params[:city],
      state: lead_params[:state],
      referred_by: lead_params[:referred_by],
      current_stage: lead_params[:current_stage] || 'consultation',
      created_date: parse_date(lead_params[:created_date]) || Date.current,
      priority: lead_params[:priority] || 'medium',
      note: lead_params[:note],
      call_disposition: lead_params[:call_disposition],
      lead_source: lead_params[:lead_source] || 'agent_referral',
      referral_amount: lead_params[:referral_amount] || 0.0,
      transferred_amount: lead_params[:transferred_amount] || false,
      stage_updated_at: Time.current
    )

    if lead.save
      render json: {
        status: true,
        message: 'Lead created successfully',
        data: {
          lead_id: lead.lead_id,
          id: lead.id,
          name: lead.name,
          contact_number: lead.contact_number,
          email: lead.email,
          product_interest: lead.product_interest,
          current_stage: lead.current_stage,
          priority: lead.priority,
          lead_source: lead.lead_source,
          created_at: lead.created_at.strftime('%Y-%m-%d %H:%M:%S'),
          stage_progress: lead.stage_progress_percentage,
          can_advance: lead.can_advance?,
          next_stage: lead.next_stage
        }
      }, status: :created
    else
      render json: {
        status: false,
        message: 'Failed to create lead',
        errors: lead.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/mobile/agent/leads
  def leads
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    stage_filter = params[:stage] # 'consultation', 'converted', etc.
    product_filter = params[:product] # 'health', 'life', etc.
    search = params[:search]

    # Base query - agents can see all leads for now
    leads = Lead.includes(:converted_customer, :created_policy).recent

    # Apply filters
    leads = leads.by_stage(stage_filter) if stage_filter.present?
    leads = leads.by_product(product_filter) if product_filter.present?

    # Apply search
    if search.present?
      leads = leads.search_leads(search)
    end

    # Paginate
    leads = leads.page(page).per(per_page)

    leads_data = leads.map do |lead|
      {
        id: lead.id,
        lead_id: lead.lead_id,
        name: lead.name,
        contact_number: lead.contact_number,
        email: lead.email,
        product_interest: lead.product_interest.capitalize,
        current_stage: lead.current_stage.humanize,
        priority: lead.priority.capitalize,
        lead_source: lead.lead_source.humanize,
        created_date: lead.created_date&.strftime('%Y-%m-%d'),
        full_address: lead.full_address,
        referred_by: lead.referred_by,
        stage_progress: lead.stage_progress_percentage,
        stage_description: lead.stage_description,
        can_advance: lead.can_advance?,
        can_go_back: lead.can_go_back?,
        next_stage: lead.next_stage,
        previous_stage: lead.previous_stage,
        converted_customer_id: lead.converted_customer_id,
        created_policy_id: lead.created_policy_id,
        referral_amount: lead.referral_amount,
        transferred_amount: lead.transferred_amount,
        stage_badge_class: lead.stage_badge_class,
        source_badge_class: lead.source_badge_class,
        product_badge_class: lead.product_badge_class,
        created_at: lead.created_at.strftime('%Y-%m-%d %H:%M:%S')
      }
    end

    # Get statistics
    stats = get_leads_statistics

    render json: {
      success: true,
      data: {
        leads: leads_data,
        statistics: stats,
        pagination: {
          current_page: page.to_i,
          per_page: per_page.to_i,
          total_leads: leads.total_count,
          total_pages: leads.total_pages
        }
      }
    }
  end

  # GET /api/v1/mobile/agent/form_data
  def form_data
    render json: {
      success: true,
      data: {
        clients: get_clients_dropdown,
        insurance_companies: get_insurance_companies_dropdown,
        payment_modes: ['monthly', 'quarterly', 'half_yearly', 'yearly', 'single'],
        policy_types: ['individual', 'family', 'group'],
        insurance_types: ['health', 'life', 'motor', 'other'],
        policy_holder_options: ['self', 'other'],
        relationships: ['self', 'spouse', 'child', 'father', 'mother', 'brother', 'sister'],
        document_types: ['policy_copy', 'proposal_form', 'medical_reports', 'id_proof', 'address_proof'],

        # Leads related dropdowns
        lead_stages: [
          { value: 'consultation', label: 'Consultation' },
          { value: 'one_on_one', label: 'One-on-One' },
          { value: 'converted', label: 'Converted' },
          { value: 'policy_created', label: 'Policy Created' },
          { value: 'referral_settled', label: 'Referral Settled' }
        ],
        lead_sources: [
          { value: 'online', label: 'Online' },
          { value: 'offline', label: 'Offline' },
          { value: 'agent_referral', label: 'Agent Referral' },
          { value: 'walk_in', label: 'Walk In' },
          { value: 'tele_calling', label: 'Tele Calling' },
          { value: 'campaign', label: 'Campaign' }
        ],
        product_interests: [
          { value: 'health', label: 'Health Insurance' },
          { value: 'life', label: 'Life Insurance' },
          { value: 'motor', label: 'Motor Insurance' },
          { value: 'home', label: 'Home Insurance' },
          { value: 'travel', label: 'Travel Insurance' },
          { value: 'other', label: 'Other Insurance' }
        ],
        priority_levels: [
          { value: 'high', label: 'High' },
          { value: 'medium', label: 'Medium' },
          { value: 'low', label: 'Low' }
        ],
        states: get_indian_states,

        customer_types: ['individual', 'corporate'],
        genders: ['Male', 'Female', 'Other'],
        marital_statuses: ['Single', 'Married', 'Divorced', 'Widowed'],
        vehicle_types: ['Two Wheeler', 'Four Wheeler', 'Commercial Vehicle'],
        coverage_types: ['Property', 'Travel', 'Personal Accident', 'Fire', 'Marine', 'Cyber Security', 'Other']
      }
    }
  end

  # GET /api/v1/mobile/agent/insurance_companies
  def insurance_companies
    page = params[:page] || 1
    per_page = params[:per_page] || 20
    search = params[:search]
    status_filter = params[:status] # 'active', 'inactive', or 'all'

    companies = InsuranceCompany.all

    # Apply search filter
    if search.present?
      companies = companies.where("name ILIKE ? OR code ILIKE ?", "%#{search}%", "%#{search}%")
    end

    # Apply status filter
    case status_filter
    when 'active'
      companies = companies.where(status: true)
    when 'inactive'
      companies = companies.where(status: false)
    # 'all' or nil shows all companies
    end

    companies = companies.order(:name).page(page).per(per_page)

    companies_data = companies.map do |company|
      {
        id: company.id,
        name: company.name,
        code: company.code,
        status: company.status ? 'Active' : 'Inactive',
        contact_person: company.contact_person,
        email: company.email,
        mobile: company.mobile,
        address: company.address,
        created_at: company.created_at&.strftime('%Y-%m-%d %H:%M:%S'),
        updated_at: company.updated_at&.strftime('%Y-%m-%d %H:%M:%S')
      }
    end

    render json: {
      success: true,
      data: {
        insurance_companies: companies_data,
        statistics: {
          total_companies: InsuranceCompany.count,
          active_companies: InsuranceCompany.where(status: true).count,
          inactive_companies: InsuranceCompany.where(status: false).count
        },
        pagination: {
          current_page: page.to_i,
          per_page: per_page.to_i,
          total_companies: companies.total_count,
          total_pages: companies.total_pages
        }
      }
    }
  end

  private

  def authenticate_agent!
    token = request.headers['Authorization']&.split(' ')&.last

    if token.blank?
      return render json: {
        success: false,
        message: 'Authorization token is required'
      }, status: :unauthorized
    end

    begin
      decoded_token = JWT.decode(token, Rails.application.secret_key_base)[0]
      user_id = decoded_token['user_id']
      role = decoded_token['role']

      if (role == 'agent') || (role == 'sub_agent')
        @current_user = User.find(user_id)
      else
        return render json: {
          success: false,
          message: 'Agent authorization required'
        }, status: :unauthorized
      end

      if @current_user.nil?
        return render json: {
          success: false,
          message: 'Agent not found'
        }, status: :unauthorized
      end

    rescue JWT::DecodeError => e
      render json: {
        success: false,
        message: 'Invalid authorization token'
      }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound => e
      render json: {
        success: false,
        message: 'Agent not found'
      }, status: :unauthorized
    end
  end

  def get_dashboard_statistics(agent)
    if agent.user_type == 'admin'
      # Admin can see all statistics
      {
        customers_count: Customer.active.count,
        policies_count: HealthInsurance.count + LifeInsurance.count,
        health_policies_count: HealthInsurance.count,
        life_policies_count: LifeInsurance.count,
        total_premium: (HealthInsurance.sum(:total_premium) + LifeInsurance.sum(:total_premium)),
        commission_earned: (HealthInsurance.sum(:commission_amount) + LifeInsurance.sum(:commission_amount)),
        this_month_policies: get_this_month_policies_count,
        this_month_premium: get_this_month_premium
      }
    else
      # Regular agents see limited statistics
      customer_ids = (HealthInsurance.pluck(:customer_id) + LifeInsurance.pluck(:customer_id)).uniq
      {
        customers_count: customer_ids.count,
        policies_count: HealthInsurance.count + LifeInsurance.count,
        health_policies_count: HealthInsurance.count,
        life_policies_count: LifeInsurance.count,
        total_premium: (HealthInsurance.sum(:total_premium) + LifeInsurance.sum(:total_premium)),
        commission_earned: (HealthInsurance.sum(:commission_amount) + LifeInsurance.sum(:commission_amount)),
        this_month_policies: get_this_month_policies_count,
        this_month_premium: get_this_month_premium
      }
    end
  end

  def get_recent_activities(agent)
    activities = []

    # Recent policies (last 10)
    recent_health = HealthInsurance.order(created_at: :desc).limit(5)
    recent_life = LifeInsurance.order(created_at: :desc).limit(5)

    recent_health.each do |policy|
      activities << {
        type: 'policy_created',
        message: "Health insurance policy #{policy.policy_number} created for #{policy.customer&.display_name || 'Customer'}",
        timestamp: policy.created_at,
        policy_type: 'Health'
      }
    end

    recent_life.each do |policy|
      activities << {
        type: 'policy_created',
        message: "Life insurance policy #{policy.policy_number} created for #{policy.customer&.display_name || 'Customer'}",
        timestamp: policy.created_at,
        policy_type: 'Life'
      }
    end

    activities.sort_by { |a| a[:timestamp] }.reverse.first(10)
  end

  def get_customer_policies_count(customer)
    HealthInsurance.where(customer: customer).count +
    LifeInsurance.where(customer: customer).count
  end

  def get_customer_total_premium(customer)
    HealthInsurance.where(customer: customer).sum(:total_premium) +
    LifeInsurance.where(customer: customer).sum(:total_premium)
  end

  def format_policy_data(policy, type)
    {
      id: policy.id,
      insurance_name: policy.plan_name || "#{type} Insurance",
      insurance_type: type,
      policy_number: policy.policy_number,
      client_name: policy.customer&.display_name || 'N/A',
      policy_type: policy.policy_type || 'New',
      policy_holder: policy.policy_holder,
      entry_date: policy.created_at&.strftime('%Y-%m-%d'),
      start_date: policy.policy_start_date&.strftime('%Y-%m-%d'),
      end_date: policy.policy_end_date&.strftime('%Y-%m-%d'),
      total_premium: policy.total_premium,
      sum_insured: policy.sum_insured,
      insurance_company: policy.insurance_company_name,
      payment_mode: policy.payment_mode,
      commission_amount: policy.commission_amount || 0,
      status: policy.respond_to?(:active?) ? (policy.active? ? 'Active' : 'Inactive') : 'Active',
      created_at: policy.created_at
    }
  end

  def get_insurance_companies
    # You can get this from a dedicated model or return static list
    [
      'LIC of India',
      'SBI Life Insurance',
      'HDFC Life Insurance',
      'ICICI Prudential Life Insurance',
      'Bajaj Allianz Life Insurance',
      'Aditya Birla Sun Life Insurance',
      'Max Life Insurance',
      'Kotak Mahindra Life Insurance',
      'Tata AIA Life Insurance',
      'PNB MetLife India Insurance',
      'Star Health Insurance',
      'HDFC ERGO Health Insurance',
      'Care Health Insurance',
      'Niva Bupa Health Insurance',
      'Bajaj Allianz General Insurance',
      'New India Assurance',
      'Oriental Insurance',
      'United India Insurance'
    ]
  end

  # New helper methods for form data
  def get_clients_dropdown
    # Get all active customers
    Customer.active.limit(100).map do |customer|
      {
        id: customer.id,
        name: customer.display_name,
        email: customer.email,
        mobile: customer.mobile
      }
    end
  end

  def get_insurance_companies_dropdown
    # Return insurance companies with ID and name for dropdown
    companies = [
      'LIC of India',
      'SBI Life Insurance',
      'HDFC Life Insurance',
      'ICICI Prudential Life Insurance',
      'Star Health Insurance',
      'HDFC ERGO Health Insurance',
      'Care Health Insurance',
      'Bajaj Allianz General Insurance'
    ]

    companies.map.with_index(1) do |company, index|
      {
        id: index,
        name: company
      }
    end
  end

  def get_this_month_policies_count
    start_date = Date.current.beginning_of_month
    end_date = Date.current.end_of_month

    HealthInsurance.where(created_at: start_date..end_date).count +
    LifeInsurance.where(created_at: start_date..end_date).count
  end

  def get_this_month_premium
    start_date = Date.current.beginning_of_month
    end_date = Date.current.end_of_month

    HealthInsurance.where(created_at: start_date..end_date).sum(:total_premium) +
    LifeInsurance.where(created_at: start_date..end_date).sum(:total_premium)
  end

  def generate_demo_password(customer)
    # Generate a consistent demo password based on customer data
    # Format: first_name + last 4 digits of mobile + "123"
    first_name = customer.first_name&.downcase || 'customer'
    mobile_suffix = customer.mobile&.last(4) || '0000'
    "#{first_name}#{mobile_suffix}123"
  end

  def determine_add_source(added_by_field)
    return 'system' if added_by_field.blank?
    return 'mobile_api' if added_by_field.include?('agent_mobile_api_')
    return 'admin_panel' if added_by_field.include?('admin')
    'other'
  end

  def get_customer_statistics(agent)
    base_customers = if agent.user_type == 'admin'
                      Customer.all
                    else
                      policy_customer_ids = (HealthInsurance.pluck(:customer_id) + LifeInsurance.pluck(:customer_id)).uniq
                      agent_added_customers = Customer.where("added_by LIKE ?", "%agent_mobile_api_#{agent.id}%")
                      Customer.where(id: policy_customer_ids).or(agent_added_customers)
                    end

    {
      total_customers: base_customers.active.count,
      agent_added_customers: base_customers.where("added_by LIKE ?", "%agent_mobile_api_%").count,
      system_added_customers: base_customers.where("added_by IS NULL OR added_by NOT LIKE ?", "%agent_mobile_api_%").count,
      my_added_customers: agent.user_type != 'admin' ? base_customers.where("added_by LIKE ?", "%agent_mobile_api_#{agent.id}%").count : 0
    }
  end

  # Helper methods for health policy creation
  def parse_date(date_string)
    return nil if date_string.blank?
    Date.parse(date_string) rescue nil
  end

  def get_company_name_by_id(company_id)
    # Map company IDs to names - you can replace this with a database lookup
    companies = {
      1 => 'LIC of India',
      2 => 'SBI Life Insurance',
      3 => 'HDFC Life Insurance',
      4 => 'ICICI Prudential Life Insurance',
      5 => 'Star Health Insurance',
      6 => 'HDFC ERGO Health Insurance',
      7 => 'Care Health Insurance',
      8 => 'Bajaj Allianz General Insurance'
    }
    companies[company_id.to_i] || 'Unknown Insurance Company'
  end

  def create_family_member(policy, member_data)
    # Use the existing HealthInsuranceMember model if it exists
    if defined?(HealthInsuranceMember)
      HealthInsuranceMember.create!(
        health_insurance: policy,
        member_name: member_data[:full_name],
        age: member_data[:age],
        relationship: member_data[:relationship],
        sum_insured: member_data[:sum_insured]
      )
    else
      # Store in notes field as JSON if no separate table exists
      family_member = {
        full_name: member_data[:full_name],
        age: member_data[:age],
        relationship: member_data[:relationship],
        sum_insured: member_data[:sum_insured]
      }

      current_notes = policy.notes.present? ? JSON.parse(policy.notes) : {}
      current_notes['family_members'] ||= []
      current_notes['family_members'] << family_member
      policy.update(notes: current_notes.to_json)
    end
  end

  def handle_document_uploads(policy, documents_data)
    # Handle base64 document uploads using Active Storage
    documents_data.each_with_index do |doc_data, index|
      next if doc_data[:document_file].blank?

      begin
        # Decode base64 file
        decoded_file = Base64.decode64(doc_data[:document_file])

        # Create filename
        filename = "#{doc_data[:document_type]}_#{policy.policy_number}_#{index + 1}.pdf"

        # Create a StringIO object for Active Storage
        file_io = StringIO.new(decoded_file)
        file_io.set_encoding('BINARY')

        # Attach to the policy using Active Storage
        policy.documents.attach(
          io: file_io,
          filename: filename,
          content_type: 'application/pdf'
        )

        Rails.logger.info "Document uploaded successfully: #{filename}"
      rescue => e
        Rails.logger.error "Error processing document #{index}: #{e.message}"
      end
    end
  end

  # Helper method for leads statistics
  def get_leads_statistics
    current_month_start = Date.current.beginning_of_month
    current_month_end = Date.current.end_of_month

    {
      total_leads: Lead.count,
      this_month_leads: Lead.where(created_date: current_month_start..current_month_end).count,
      pending_leads: Lead.pending_conversion.count,
      converted_leads: Lead.converted_leads.count,
      conversion_rate: calculate_conversion_rate,
      by_stage: {
        consultation: Lead.by_stage('consultation').count,
        one_on_one: Lead.by_stage('one_on_one').count,
        converted: Lead.by_stage('converted').count,
        policy_created: Lead.by_stage('policy_created').count,
        referral_settled: Lead.by_stage('referral_settled').count
      },
      by_product: {
        health: Lead.by_product('health').count,
        life: Lead.by_product('life').count,
        motor: Lead.by_product('motor').count,
        home: Lead.by_product('home').count,
        travel: Lead.by_product('travel').count,
        other: Lead.by_product('other').count
      },
      by_source: {
        online: Lead.by_source('online').count,
        offline: Lead.by_source('offline').count,
        agent_referral: Lead.by_source('agent_referral').count,
        walk_in: Lead.by_source('walk_in').count,
        tele_calling: Lead.by_source('tele_calling').count,
        campaign: Lead.by_source('campaign').count
      }
    }
  end

  def calculate_conversion_rate
    total_leads = Lead.count
    return 0 if total_leads == 0

    converted_leads = Lead.converted_leads.count
    ((converted_leads.to_f / total_leads) * 100).round(2)
  end

  def get_indian_states
    [
      { value: 'andhra_pradesh', label: 'Andhra Pradesh' },
      { value: 'assam', label: 'Assam' },
      { value: 'bihar', label: 'Bihar' },
      { value: 'delhi', label: 'Delhi' },
      { value: 'gujarat', label: 'Gujarat' },
      { value: 'haryana', label: 'Haryana' },
      { value: 'karnataka', label: 'Karnataka' },
      { value: 'kerala', label: 'Kerala' },
      { value: 'madhya_pradesh', label: 'Madhya Pradesh' },
      { value: 'maharashtra', label: 'Maharashtra' },
      { value: 'punjab', label: 'Punjab' },
      { value: 'rajasthan', label: 'Rajasthan' },
      { value: 'tamil_nadu', label: 'Tamil Nadu' },
      { value: 'uttar_pradesh', label: 'Uttar Pradesh' },
      { value: 'west_bengal', label: 'West Bengal' }
    ]
  end

  # Helper method to handle customer file uploads
  def handle_customer_file_uploads(customer, file1, file2)
    file_info = {
      file1: nil,
      file2: nil,
      upload_status: 'success',
      upload_errors: []
    }

    begin
      # Handle file1 upload
      if file1.present?
        file1_result = process_customer_file(customer, file1, 'file1')
        file_info[:file1] = file1_result
      end

      # Handle file2 upload
      if file2.present?
        file2_result = process_customer_file(customer, file2, 'file2')
        file_info[:file2] = file2_result
      end

    rescue => e
      file_info[:upload_status] = 'error'
      file_info[:upload_errors] << e.message
      Rails.logger.error "Error processing customer files: #{e.message}"
    end

    file_info
  end

  def process_customer_file(customer, file_data, file_type)
    return nil if file_data.blank?

    begin
      # If it's a base64 string, decode it
      if file_data.is_a?(String) && file_data.start_with?('data:')
        # Extract file info from data URL
        data_match = file_data.match(/^data:([^;]+);base64,(.+)$/)
        if data_match
          content_type = data_match[1]
          encoded_file = data_match[2]
          decoded_file = Base64.decode64(encoded_file)

          # Determine file extension from content type
          extension = case content_type
                     when 'image/jpeg', 'image/jpg' then '.jpg'
                     when 'image/png' then '.png'
                     when 'image/gif' then '.gif'
                     when 'application/pdf' then '.pdf'
                     when 'image/webp' then '.webp'
                     else '.bin'
                     end

          # Create filename
          filename = "customer_#{customer.id}_#{file_type}_#{Time.current.to_i}#{extension}"

          # Create a StringIO object for Active Storage
          file_io = StringIO.new(decoded_file)
          file_io.set_encoding('BINARY')

          # Attach to customer using Active Storage
          customer.documents.attach(
            io: file_io,
            filename: filename,
            content_type: content_type
          )

          return {
            filename: filename,
            content_type: content_type,
            file_size: decoded_file.size,
            uploaded_at: Time.current.strftime('%Y-%m-%d %H:%M:%S'),
            type: file_type
          }
        end
      end

      # Handle direct file uploads (multipart)
      if file_data.respond_to?(:original_filename)
        filename = "customer_#{customer.id}_#{file_type}_#{Time.current.to_i}_#{file_data.original_filename}"

        customer.documents.attach(
          io: file_data.tempfile,
          filename: filename,
          content_type: file_data.content_type
        )

        return {
          filename: filename,
          content_type: file_data.content_type,
          file_size: file_data.size,
          uploaded_at: Time.current.strftime('%Y-%m-%d %H:%M:%S'),
          type: file_type
        }
      end

    rescue => e
      Rails.logger.error "Error processing #{file_type}: #{e.message}"
      return {
        error: "Failed to process #{file_type}",
        message: e.message
      }
    end

    nil
  end

  # Helper methods for life insurance
  def create_life_insurance_nominee(policy, nominee_data)
    LifeInsuranceNominee.create!(
      life_insurance: policy,
      nominee_name: nominee_data[:nominee_name],
      relationship: nominee_data[:relationship],
      age: nominee_data[:age],
      share_percentage: nominee_data[:share_percentage] || 100.0
    )
  rescue => e
    Rails.logger.error "Error creating nominee: #{e.message}"
  end

  def create_life_insurance_bank_details(policy, bank_data)
    LifeInsuranceBankDetail.create!(
      life_insurance: policy,
      bank_name: bank_data[:bank_name],
      account_type: bank_data[:account_type],
      account_number: bank_data[:account_number],
      ifsc_code: bank_data[:ifsc_code],
      account_holder_name: bank_data[:account_holder_name]
    )
  rescue => e
    Rails.logger.error "Error creating bank details: #{e.message}"
  end

  def handle_life_insurance_document_uploads(policy, documents_data)
    documents_data.each_with_index do |doc_data, index|
      next if doc_data[:document_file].blank?

      begin
        # Decode base64 file
        decoded_file = Base64.decode64(doc_data[:document_file])

        # Create filename
        filename = "life_insurance_#{policy.id}_#{doc_data[:document_type]}_#{index + 1}.pdf"

        # Create a StringIO object for Active Storage
        file_io = StringIO.new(decoded_file)
        file_io.set_encoding('BINARY')

        # Create the document record
        document = LifeInsuranceDocument.create!(
          life_insurance: policy,
          document_type: doc_data[:document_type],
          document_name: filename
        )

        # Attach the file to the document record
        document.document.attach(
          io: file_io,
          filename: filename,
          content_type: 'application/pdf'
        )

        Rails.logger.info "Life insurance document uploaded successfully: #{filename}"
      rescue => e
        Rails.logger.error "Error processing life insurance document #{index}: #{e.message}"
      end
    end
  end
end