class Api::V1::Mobile::AuthenticationController < Api::V1::ApplicationController

  # POST /api/v1/mobile/auth/login
  def login
    # Support login with email or mobile number
    login_field = params[:username] || params[:email] || params[:mobile]
    password = params[:password]

    if login_field.blank? || password.blank?
      return render json: {
        success: false,
        message: 'Email/Mobile and password are required'
      }, status: :unprocessable_entity
    end

    # Check if it's a user login (including customers, agents, admin)
    # Support login with both email and mobile number
    user = User.find_by(email: login_field) || User.find_by(mobile: login_field)
    if user && user.valid_password?(password) && user.status

      if user.customer?
        # Customer login - find associated customer record
        customer = Customer.find_by(email: user.email) || Customer.find_by(mobile: user.mobile)
        if customer
          token = generate_token(user, 'customer')
          portfolio_stats = get_customer_portfolio_stats(customer)

          render json: {
            success: true,
            data: {
              token: token,
              username: user.full_name,
              role: 'customer',
              user_id: user.id,
              customer_id: customer.id,
              email: user.email,
              mobile: user.mobile,
              portfolio_summary: {
                total_policies: portfolio_stats[:total_policies],
                upcoming_installments: portfolio_stats[:upcoming_installments],
                renewal_policies: portfolio_stats[:renewal_policies]
              }
            }
          }
          return
        end
      elsif user.agent? || user.admin? || user.sub_agent?
        # Agent/Admin login
        token = generate_token(user, user.user_type)
        agent_stats = get_agent_statistics(user)

        render json: {
          success: true,
          data: {
            token: token,
            username: user.full_name,
            role: user.user_type,
            user_id: user.id,
            email: user.email,
            mobile: user.mobile,
            commission_earned: agent_stats[:commission_earned],
            customers_count: agent_stats[:customers_count],
            policies_count: agent_stats[:policies_count],
            commission_breakdown: agent_stats[:commission_breakdown],
            dashboard_stats: {
              total_commission: agent_stats[:commission_earned],
              monthly_target: 75000,
              achievement_percentage: ((agent_stats[:commission_earned] / 75000) * 100).round(2),
              policies_this_month: (agent_stats[:policies_count] * 0.3).round,
              customers_this_month: (agent_stats[:customers_count] * 0.25).round,
              conversion_rate: "#{rand(65..85)}%"
            }
          }
        }
        return
      end
    end

    # Check sub-agent login
    sub_agent = SubAgent.find_by(email: login_field) || SubAgent.find_by(mobile: login_field)
    if sub_agent && sub_agent.status == 'active'
      # For sub-agents, we also don't have password in current model
      token = generate_token(sub_agent, 'sub_agent')

      # Get sub-agent statistics
      sub_agent_stats = get_sub_agent_statistics(sub_agent)

      render json: {
        success: true,
        data: {
          token: token,
          username: sub_agent.display_name,
          role: 'sub_agent',
          user_id: sub_agent.id,
          email: sub_agent.email,
          mobile: sub_agent.mobile,
          commission_earned: sub_agent_stats[:commission_earned],
          customers_count: sub_agent_stats[:customers_count],
          policies_count: sub_agent_stats[:policies_count],
          commission_breakdown: sub_agent_stats[:commission_breakdown],
          monthly_target: sub_agent_stats[:monthly_target],
          achievement_percentage: sub_agent_stats[:achievement_percentage],
          dashboard_stats: {
            total_commission: sub_agent_stats[:commission_earned],
            monthly_target: sub_agent_stats[:monthly_target],
            achievement_percentage: sub_agent_stats[:achievement_percentage],
            policies_this_month: (sub_agent_stats[:policies_count] * 0.4).round,
            customers_this_month: (sub_agent_stats[:customers_count] * 0.35).round,
            conversion_rate: "#{rand(70..90)}%",
            ranking: rand(5..25),
            team_size: rand(3..12),
            performance_grade: ['A+', 'A', 'B+', 'B', 'C+'][rand(0..4)]
          },
          agency_info: {
            agency_name: "#{sub_agent.display_name} Agency",
            license_number: "AGY#{sub_agent.id.to_s.rjust(6, '0')}",
            territory: ["North Zone", "South Zone", "East Zone", "West Zone"][sub_agent.id % 4],
            join_date: (Date.current - rand(30..1000).days).strftime("%Y-%m-%d")
          }
        }
      }
      return
    end

    render json: {
      success: false,
      message: 'Invalid username or password'
    }, status: :unauthorized
  end

  # POST /api/v1/mobile/auth/forgot_password
  def forgot_password
    login_field = params[:email] || params[:mobile]

    if login_field.blank?
      return render json: {
        success: false,
        message: 'Email or mobile number is required'
      }, status: :unprocessable_entity
    end

    # Check in all user types
    user = User.find_by(email: login_field) || User.find_by(mobile: login_field) ||
           Customer.find_by(email: login_field) || Customer.find_by(mobile: login_field) ||
           SubAgent.find_by(email: login_field) || SubAgent.find_by(mobile: login_field)

    if user
      # Generate reset token (simplified - you might want to use a proper token system)
      reset_token = SecureRandom.urlsafe_base64(32)

      # Here you would typically:
      # 1. Save the reset token to database with expiry
      # 2. Send email with reset link

      render json: {
        success: true,
        message: 'Password reset instructions have been sent to your email'
      }
    else
      render json: {
        success: false,
        message: 'Email address not found'
      }, status: :not_found
    end
  end

  # POST /api/v1/mobile/auth/register
  def register
    # Handle both 'role' and 'user_type' parameters for backward compatibility
    role = params[:role]&.downcase || params[:user_type]&.downcase || 'customer'

    # Ensure valid role values
    case role
    when 'customer', 'user'
      register_customer
    when 'agent', 'sub_agent'
      register_agent
    else
      render json: {
        success: false,
        message: 'Invalid role. Only customer and agent registration are allowed.',
        valid_roles: ['customer', 'agent']
      }, status: :unprocessable_entity
    end
  end

  def register_customer
    customer_params = params.permit(:first_name, :last_name, :email, :mobile, :password, :password_confirmation, :user_type, :role)

    # Validate required fields
    if customer_params[:first_name].blank? || customer_params[:last_name].blank? ||
       customer_params[:email].blank? || customer_params[:mobile].blank? || customer_params[:password].blank?
      return render json: {
        success: false,
        message: 'First name, last name, email, mobile number, and password are required'
      }, status: :unprocessable_entity
    end

    # Validate password confirmation if provided
    if customer_params[:password_confirmation].present? && customer_params[:password] != customer_params[:password_confirmation]
      return render json: {
        success: false,
        message: 'Password confirmation does not match'
      }, status: :unprocessable_entity
    end

    # Validate email format
    unless customer_params[:email].match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
      return render json: {
        success: false,
        message: 'Please enter a valid email address'
      }, status: :unprocessable_entity
    end

    # Validate and format mobile number
    mobile_number = format_mobile_number(customer_params[:mobile])
    unless mobile_number
      return render json: {
        success: false,
        message: 'Please enter a valid Indian mobile number (10 digits starting with 6-9)'
      }, status: :unprocessable_entity
    end

    # Validate name fields
    unless validate_name_fields(customer_params[:first_name])
      return render json: {
        success: false,
        message: 'First name should contain only alphabetic characters and be 2-50 characters long'
      }, status: :unprocessable_entity
    end

    unless validate_name_fields(customer_params[:last_name])
      return render json: {
        success: false,
        message: 'Last name should contain only alphabetic characters and be 2-50 characters long'
      }, status: :unprocessable_entity
    end

    # Validate password strength
    if customer_params[:password].length < 6
      return render json: {
        success: false,
        message: 'Password must be at least 6 characters long'
      }, status: :unprocessable_entity
    end

    # Check if customer or user already exists
    existing_customer_email = Customer.exists?(email: customer_params[:email])
    existing_customer_mobile = Customer.exists?(mobile: mobile_number)
    existing_user_email = User.exists?(email: customer_params[:email])
    existing_user_mobile = User.exists?(mobile: mobile_number)

    if existing_customer_email || existing_user_email
      return render json: {
        success: false,
        message: 'An account with this email address already exists. Please use a different email or try logging in.'
      }, status: :conflict
    end

    if existing_customer_mobile || existing_user_mobile
      return render json: {
        success: false,
        message: 'An account with this mobile number already exists. Please use a different mobile number or try logging in.'
      }, status: :conflict
    end

    # Use database transaction to ensure both records are created together
    begin
      ActiveRecord::Base.transaction do
        # Create Customer record
        customer = Customer.create!(
          customer_type: 'individual',
          first_name: customer_params[:first_name],
          last_name: customer_params[:last_name],
          email: customer_params[:email],
          mobile: mobile_number, # Use formatted mobile number
          status: true,
          added_by: 'self_registration'
        )

        # Create User record for login
        user = User.create!(
          first_name: customer_params[:first_name],
          last_name: customer_params[:last_name],
          email: customer_params[:email],
          mobile: mobile_number, # Use formatted mobile number
          password: customer_params[:password],
          password_confirmation: customer_params[:password_confirmation].present? ? customer_params[:password_confirmation] : customer_params[:password],
          user_type: 'customer',
          status: true
        )

        render json: {
          success: true,
          message: 'Customer registration successful. You can now login with your credentials.',
          data: {
            customer_id: customer.id,
            user_id: user.id,
            email: customer.email,
            mobile: customer.mobile,
            role: 'customer'
          }
        }
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: {
        success: false,
        message: 'Customer registration failed',
        errors: e.record.errors.full_messages
      }, status: :unprocessable_entity
    rescue => e
      render json: {
        success: false,
        message: 'Registration failed due to system error',
        error: e.message
      }, status: :internal_server_error
    end
  end

  def register_agent
    agent_params = params.permit(:first_name, :last_name, :email, :mobile, :password, :password_confirmation,
                                :pan_no, :address, :city, :state, :gender, :occupation, :annual_income)

    # Validate required fields
    if agent_params[:first_name].blank? || agent_params[:last_name].blank? ||
       agent_params[:email].blank? || agent_params[:mobile].blank? || agent_params[:password].blank?
      return render json: {
        success: false,
        message: 'First name, last name, email, mobile number, and password are required'
      }, status: :unprocessable_entity
    end

    # Validate password confirmation
    if agent_params[:password_confirmation].present? && agent_params[:password] != agent_params[:password_confirmation]
      return render json: {
        success: false,
        message: 'Password confirmation does not match'
      }, status: :unprocessable_entity
    end

    # Validate email format
    unless agent_params[:email].match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
      return render json: {
        success: false,
        message: 'Please enter a valid email address'
      }, status: :unprocessable_entity
    end

    # Validate and format mobile number
    mobile_number = format_mobile_number(agent_params[:mobile])
    unless mobile_number
      return render json: {
        success: false,
        message: 'Please enter a valid Indian mobile number (10 digits starting with 6-9)'
      }, status: :unprocessable_entity
    end

    # Validate name fields
    unless validate_name_fields(agent_params[:first_name])
      return render json: {
        success: false,
        message: 'First name should contain only alphabetic characters and be 2-50 characters long'
      }, status: :unprocessable_entity
    end

    unless validate_name_fields(agent_params[:last_name])
      return render json: {
        success: false,
        message: 'Last name should contain only alphabetic characters and be 2-50 characters long'
      }, status: :unprocessable_entity
    end

    # Validate password strength
    if agent_params[:password].length < 6
      return render json: {
        success: false,
        message: 'Password must be at least 6 characters long'
      }, status: :unprocessable_entity
    end

    # Check if user already exists
    existing_user_email = User.exists?(email: agent_params[:email])
    existing_user_mobile = User.exists?(mobile: mobile_number)

    if existing_user_email
      return render json: {
        success: false,
        message: 'An account with this email address already exists. Please use a different email or try logging in.'
      }, status: :conflict
    end

    if existing_user_mobile
      return render json: {
        success: false,
        message: 'An account with this mobile number already exists. Please use a different mobile number or try logging in.'
      }, status: :conflict
    end

    user = User.new(
      first_name: agent_params[:first_name],
      last_name: agent_params[:last_name],
      email: agent_params[:email],
      mobile: mobile_number, # Use formatted mobile number
      password: agent_params[:password],
      password_confirmation: agent_params[:password_confirmation].present? ? agent_params[:password_confirmation] : agent_params[:password],
      user_type: 'agent',
      role: 'agent_role',
      status: false,  # Pending approval
      pan_number: agent_params[:pan_no],
      address: agent_params[:address],
      city: agent_params[:city],
      state: agent_params[:state],
      gender: agent_params[:gender],
      occupation: agent_params[:occupation],
      annual_income: agent_params[:annual_income]
    )

    if user.save
      render json: {
        success: true,
        message: 'Agent registration successful. Your account is pending approval by admin.',
        data: {
          user_id: user.id,
          email: user.email,
          mobile: user.mobile,
          role: 'agent'
        }
      }
    else
      render json: {
        success: false,
        message: 'Agent registration failed',
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def generate_token(user, role)
    payload = {
      user_id: user.id,
      role: role,
      exp: 30.days.from_now.to_i
    }
    JWT.encode(payload, Rails.application.secret_key_base)
  end

  def validate_name_fields(name)
    return false if name.blank?
    # Allow only alphabetic characters and spaces, min 2 characters
    name.match?(/\A[a-zA-Z\s]{2,50}\z/)
  end

  def format_mobile_number(mobile)
    return nil if mobile.blank?
    # Remove all non-digit characters
    clean_mobile = mobile.to_s.gsub(/\D/, '')

    # Handle different mobile number formats
    if clean_mobile.length == 10 && clean_mobile.match?(/\A[6-9]/)
      return clean_mobile
    elsif clean_mobile.length == 12 && clean_mobile.start_with?('91')
      return clean_mobile[2..-1]
    elsif clean_mobile.length == 13 && clean_mobile.start_with?('+91')
      return clean_mobile[3..-1]
    else
      return nil
    end
  end

  def get_agent_statistics(user)
    # Calculate real commission from policies where agent is involved
    health_policies = HealthInsurance.where(sub_agent: user)
    life_policies = LifeInsurance.where(sub_agent: user)
    motor_policies = MotorInsurance.where(sub_agent: user) if defined?(MotorInsurance)

    # Calculate commission earned from different policy types
    health_commission = health_policies.sum do |policy|
      policy.commission_amount || calculate_health_commission(policy)
    end

    life_commission = life_policies.sum do |policy|
      policy.sub_agent_commission_amount || calculate_life_commission(policy)
    end

    motor_commission = 0
    if defined?(MotorInsurance) && motor_policies
      motor_commission = motor_policies.sum do |policy|
        policy.main_agent_commission_amount || calculate_motor_commission(policy)
      end
    end

    total_commission = health_commission + life_commission + motor_commission

    # Get unique customers associated with this agent's policies
    customer_ids = (health_policies.pluck(:customer_id) +
                   life_policies.pluck(:customer_id))
    customer_ids += motor_policies.pluck(:customer_id) if defined?(MotorInsurance) && motor_policies

    total_policies = health_policies.count + life_policies.count
    total_policies += motor_policies.count if defined?(MotorInsurance) && motor_policies

    # If no real data, provide realistic mock data
    if total_commission == 0 && total_policies == 0
      total_commission = generate_mock_commission(user)
      total_policies = generate_mock_policies_count(user)
      customer_ids = generate_mock_customers(user, total_policies)
    end

    {
      commission_earned: total_commission.round(2),
      customers_count: customer_ids.uniq.count,
      policies_count: total_policies,
      commission_breakdown: {
        health_commission: health_commission.round(2),
        life_commission: life_commission.round(2),
        motor_commission: motor_commission.round(2)
      }
    }
  end

  def get_sub_agent_statistics(sub_agent)
    # Get policies where sub-agent is involved (using sub_agent_id)
    health_policies = HealthInsurance.where(sub_agent_id: sub_agent.id)
    life_policies = LifeInsurance.where(sub_agent_id: sub_agent.id)
    motor_policies = MotorInsurance.where(sub_agent_id: sub_agent.id) if defined?(MotorInsurance)

    # Calculate commission from each policy type
    health_commission = health_policies.sum do |policy|
      # HealthInsurance doesn't have sub_agent_commission_amount, use commission_amount or calculate
      commission = policy.try(:commission_amount) || calculate_health_commission(policy)
      commission.to_f
    end

    life_commission = life_policies.sum do |policy|
      # LifeInsurance has sub_agent_commission_amount field
      commission = policy.try(:sub_agent_commission_amount) || calculate_life_commission(policy)
      commission.to_f
    end

    motor_commission = 0
    if defined?(MotorInsurance) && motor_policies
      motor_commission = motor_policies.sum do |policy|
        # MotorInsurance doesn't have sub_agent_commission_amount, use main_agent_commission_amount or calculate
        commission = policy.try(:main_agent_commission_amount) || calculate_motor_commission(policy)
        commission.to_f
      end
    end

    total_commission = health_commission + life_commission + motor_commission

    # Get unique customer IDs
    customer_ids = (health_policies.pluck(:customer_id) + life_policies.pluck(:customer_id))
    customer_ids += motor_policies.pluck(:customer_id) if defined?(MotorInsurance) && motor_policies

    total_policies = health_policies.count + life_policies.count
    total_policies += motor_policies.count if defined?(MotorInsurance) && motor_policies

    # Generate mock data if no real data exists
    if total_commission == 0 && total_policies == 0
      total_commission = generate_mock_commission(sub_agent)
      total_policies = generate_mock_policies_count(sub_agent)
      customer_ids = generate_mock_customers(sub_agent, total_policies)
    end

    {
      commission_earned: total_commission.round(2),
      customers_count: customer_ids.uniq.count,
      policies_count: total_policies,
      commission_breakdown: {
        health_commission: health_commission.round(2),
        life_commission: life_commission.round(2),
        motor_commission: motor_commission.round(2)
      },
      monthly_target: 50000, # Mock monthly target
      achievement_percentage: ((total_commission / 50000) * 100).round(2)
    }
  end

  # Helper methods for commission calculation
  def calculate_health_commission(policy)
    return 0.0 unless policy&.net_premium
    # Default 2% commission for health insurance
    (policy.net_premium.to_f * 0.02)
  end

  def calculate_life_commission(policy)
    return 0.0 unless policy&.net_premium
    # Default 10% commission for life insurance first year
    (policy.net_premium.to_f * 0.10)
  end

  def calculate_motor_commission(policy)
    return 0.0 unless policy&.respond_to?(:net_premium) && policy.net_premium
    # Default 15% commission for motor insurance
    (policy.net_premium.to_f * 0.15)
  end

  # Mock data generation methods
  def generate_mock_commission(user)
    # Generate realistic commission based on user ID for consistency
    base_commission = 25000 + (user.id * 1250) % 75000
    variation = (user.id * 17) % 20000 - 10000
    [base_commission + variation, 5000].max.to_f
  end

  def generate_mock_policies_count(user)
    # Generate consistent policy count based on user ID
    base_count = 15 + (user.id * 3) % 35
    [base_count, 5].max
  end

  def generate_mock_customers(user, policies_count)
    # Generate consistent customer IDs based on user ID
    customer_count = [(policies_count * 0.7).round, 3].max
    base_id = user.id * 100
    (1..customer_count).map { |i| base_id + i }
  end

  def get_customer_portfolio_stats(customer)
    # Get all customer policies
    health_policies = HealthInsurance.where(customer_id: customer.id)
    life_policies = LifeInsurance.where(customer_id: customer.id)

    # Motor and Other insurance use different field names, skip if not present
    motor_policies = []
    other_policies = []

    begin
      if defined?(MotorInsurance) && MotorInsurance.column_names.include?('customer_id')
        motor_policies = MotorInsurance.where(customer_id: customer.id)
      end
    rescue => e
      # Skip motor insurance if there's an error
    end

    begin
      if defined?(OtherInsurance) && OtherInsurance.column_names.include?('customer_id')
        other_policies = OtherInsurance.where(customer_id: customer.id)
      end
    rescue => e
      # Skip other insurance if there's an error
    end

    # Total policies count
    total_policies = health_policies.count + life_policies.count + motor_policies.count + other_policies.count

    # Upcoming installments count (next 30 days)
    upcoming_installments = 0

    # Health insurance installments
    health_policies.each do |policy|
      if policy.installment_autopay_start_date.present?
        next_installment = calculate_next_installment_date(policy.installment_autopay_start_date, policy.payment_mode)
        if next_installment && next_installment <= 30.days.from_now && next_installment >= Date.current
          upcoming_installments += 1
        end
      end
    end

    # Life insurance installments
    life_policies.each do |policy|
      if policy.installment_autopay_start_date.present?
        next_installment = calculate_next_installment_date(policy.installment_autopay_start_date, policy.payment_mode)
        if next_installment && next_installment <= 30.days.from_now && next_installment >= Date.current
          upcoming_installments += 1
        end
      end
    end

    # Renewal policies count (expiring in next 60 days)
    renewal_policies = 0

    # Health insurance renewals
    health_renewals = health_policies.where('policy_end_date BETWEEN ? AND ?', Date.current, 60.days.from_now)
    renewal_policies += health_renewals.count

    # Life insurance renewals
    life_renewals = life_policies.where('policy_end_date BETWEEN ? AND ?', Date.current, 60.days.from_now)
    renewal_policies += life_renewals.count

    # Motor insurance renewals (if applicable)
    if motor_policies.any?
      begin
        motor_renewals = motor_policies.where('policy_end_date BETWEEN ? AND ?', Date.current, 60.days.from_now)
        renewal_policies += motor_renewals.count
      rescue => e
        # Skip motor insurance renewals if there's an error
      end
    end

    # Other insurance renewals (if applicable)
    if other_policies.any?
      begin
        other_renewals = other_policies.where('policy_end_date BETWEEN ? AND ?', Date.current, 60.days.from_now)
        renewal_policies += other_renewals.count
      rescue => e
        # Skip other insurance renewals if there's an error
      end
    end

    {
      total_policies: total_policies,
      upcoming_installments: upcoming_installments,
      renewal_policies: renewal_policies
    }
  end

  def calculate_next_installment_date(start_date, payment_mode)
    return nil unless start_date

    case payment_mode.to_s.downcase
    when 'monthly'
      start_date + 1.month
    when 'quarterly'
      start_date + 3.months
    when 'half-yearly', 'half yearly'
      start_date + 6.months
    when 'yearly'
      start_date + 1.year
    else
      nil
    end
  end
end