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

    customers = if agent.user_type == 'admin'
                  Customer.all
                else
                  # For agents, show customers from their policies
                  customer_ids = (HealthInsurance.pluck(:customer_id) + LifeInsurance.pluck(:customer_id)).uniq
                  Customer.where(id: customer_ids)
                end

    customers = customers.active.page(page).per(per_page)

    customers_data = customers.map do |customer|
      {
        id: customer.id,
        name: customer.display_name,
        mobile: customer.mobile,
        email: customer.email,
        customer_type: customer.customer_type,
        status: customer.active? ? 'Active' : 'Inactive',
        policies_count: get_customer_policies_count(customer),
        total_premium: get_customer_total_premium(customer),
        created_at: customer.created_at
      }
    end

    render json: {
      success: true,
      data: {
        customers: customers_data,
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
      :pan_no, :gst_no, :occupation, :annual_income, :marital_status
    )

    customer = Customer.new(customer_params.merge(
      status: true,
      added_by: current_user.id
    ))

    if customer.save
      render json: {
        success: true,
        message: 'Customer added successfully',
        data: {
          customer_id: customer.id,
          name: customer.display_name,
          email: customer.email,
          mobile: customer.mobile
        }
      }
    else
      render json: {
        success: false,
        message: 'Failed to add customer',
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
    policy_params = params.permit(
      :customer_id, :policy_holder, :plan_name, :policy_number,
      :insurance_company_name, :policy_type, :policy_start_date, :policy_end_date,
      :payment_mode, :sum_insured, :net_premium, :gst_percentage, :total_premium,
      :agent_commission_percentage, :commission_amount
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

    policy = HealthInsurance.new(policy_params.merge(
      added_by: current_user.id,
      status: 'active'
    ))

    if policy.save
      render json: {
        success: true,
        message: 'Health insurance policy added successfully',
        data: format_policy_data(policy, 'Health')
      }
    else
      render json: {
        success: false,
        message: 'Failed to add health insurance policy',
        errors: policy.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/mobile/agent/policies/life
  def add_life_policy
    policy_params = params.permit(
      :customer_id, :policy_holder, :plan_name, :policy_number,
      :insurance_company_name, :policy_type, :policy_start_date, :policy_end_date,
      :payment_mode, :policy_term, :premium_payment_term, :sum_insured,
      :net_premium, :total_premium, :nominee_name, :nominee_relationship,
      :agent_commission_percentage, :commission_amount
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

    policy = LifeInsurance.new(policy_params.merge(
      added_by: current_user.id,
      status: 'active'
    ))

    if policy.save
      render json: {
        success: true,
        message: 'Life insurance policy added successfully',
        data: format_policy_data(policy, 'Life')
      }
    else
      render json: {
        success: false,
        message: 'Failed to add life insurance policy',
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

  # GET /api/v1/mobile/agent/form_data
  def form_data
    render json: {
      success: true,
      data: {
        insurance_companies: get_insurance_companies,
        payment_modes: ['monthly', 'quarterly', 'half_yearly', 'yearly', 'single'],
        policy_types: ['new_policy', 'renewal'],
        customer_types: ['individual', 'corporate'],
        genders: ['Male', 'Female', 'Other'],
        marital_statuses: ['Single', 'Married', 'Divorced', 'Widowed'],
        vehicle_types: ['Two Wheeler', 'Four Wheeler', 'Commercial Vehicle'],
        coverage_types: ['Property', 'Travel', 'Personal Accident', 'Fire', 'Marine', 'Cyber Security', 'Other'],
        insurance_types: ['health', 'life', 'motor', 'other']
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

      if role == 'agent'
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
end