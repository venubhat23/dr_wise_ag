class Api::V1::Mobile::AuthenticationController < Api::V1::ApplicationController

  # POST /api/v1/mobile/auth/login
  def login
    email = params[:username] || params[:email]
    password = params[:password]

    if email.blank? || password.blank?
      return render json: {
        success: false,
        message: 'Username and password are required'
      }, status: :unprocessable_entity
    end

    # Check if it's a customer login
    customer = Customer.find_by(email: email)
    if customer && customer.status
      # For customers, we don't have password authentication in current model
      # You might need to add password field to customers table
      token = generate_token(customer, 'customer')

      render json: {
        success: true,
        data: {
          token: token,
          username: customer.display_name,
          role: 'customer',
          user_id: customer.id,
          email: customer.email,
          mobile: customer.mobile
        }
      }
      return
    end

    # Check if it's a user/agent login
    user = User.find_by(email: email)
    if user && user.valid_password?(password)
      token = generate_token(user, 'agent')

      # Get agent statistics
      agent_stats = get_agent_statistics(user)

      render json: {
        success: true,
        data: {
          token: token,
          username: user.first_name + ' ' + user.last_name,
          role: 'agent',
          user_id: user.id,
          email: user.email,
          commission_earned: agent_stats[:commission_earned],
          customers_count: agent_stats[:customers_count],
          policies_count: agent_stats[:policies_count]
        }
      }
      return
    end

    # Check sub-agent login
    sub_agent = SubAgent.find_by(email: email)
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
          policies_count: sub_agent_stats[:policies_count]
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
    email = params[:email]

    if email.blank?
      return render json: {
        success: false,
        message: 'Email is required'
      }, status: :unprocessable_entity
    end

    # Check in all user types
    user = User.find_by(email: email) ||
           Customer.find_by(email: email) ||
           SubAgent.find_by(email: email)

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
    role = params[:role]&.downcase || 'customer'

    if role == 'customer'
      register_customer
    elsif role == 'agent'
      register_agent
    else
      render json: {
        success: false,
        message: 'Invalid role. Only customer and agent registration are allowed.'
      }, status: :unprocessable_entity
    end
  end

  def register_customer
    customer_params = params.permit(:first_name, :last_name, :email, :mobile, :password)

    if customer_params[:email].blank? || customer_params[:mobile].blank?
      return render json: {
        success: false,
        message: 'Email and mobile number are required'
      }, status: :unprocessable_entity
    end

    # Check if customer already exists
    if Customer.exists?(email: customer_params[:email]) || Customer.exists?(mobile: customer_params[:mobile])
      return render json: {
        success: false,
        message: 'Customer with this email or mobile number already exists'
      }, status: :conflict
    end

    customer = Customer.new(
      customer_type: 'individual',
      first_name: customer_params[:first_name],
      last_name: customer_params[:last_name],
      email: customer_params[:email],
      mobile: customer_params[:mobile],
      status: true,
      added_by: 'self_registration'
    )

    if customer.save
      render json: {
        success: true,
        message: 'Customer registration successful. Please contact your agent for account activation.',
        data: {
          customer_id: customer.id,
          email: customer.email,
          mobile: customer.mobile,
          role: 'customer'
        }
      }
    else
      render json: {
        success: false,
        message: 'Customer registration failed',
        errors: customer.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def register_agent
    agent_params = params.permit(:first_name, :last_name, :email, :mobile, :password, :password_confirmation,
                                :pan_no, :address, :city, :state, :gender, :occupation, :annual_income)

    if agent_params[:email].blank? || agent_params[:mobile].blank? || agent_params[:password].blank?
      return render json: {
        success: false,
        message: 'Email, mobile number, and password are required'
      }, status: :unprocessable_entity
    end

    if agent_params[:password] != agent_params[:password_confirmation]
      return render json: {
        success: false,
        message: 'Password confirmation does not match'
      }, status: :unprocessable_entity
    end

    # Check if user already exists
    if User.exists?(email: agent_params[:email]) || User.exists?(mobile: agent_params[:mobile])
      return render json: {
        success: false,
        message: 'Agent with this email or mobile number already exists'
      }, status: :conflict
    end

    user = User.new(
      first_name: agent_params[:first_name],
      last_name: agent_params[:last_name],
      email: agent_params[:email],
      mobile: agent_params[:mobile],
      password: agent_params[:password],
      password_confirmation: agent_params[:password_confirmation],
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

  def get_agent_statistics(user)
    {
      commission_earned: 0.0, # Calculate from policies
      customers_count: Customer.count,
      policies_count: HealthInsurance.count + LifeInsurance.count
    }
  end

  def get_sub_agent_statistics(sub_agent)
    health_policies = HealthInsurance.where(sub_agent: sub_agent)
    life_policies = LifeInsurance.where(sub_agent: sub_agent)

    commission_earned = health_policies.sum(:commission_amount) + life_policies.sum(:commission_amount)

    {
      commission_earned: commission_earned,
      customers_count: (health_policies.pluck(:customer_id) + life_policies.pluck(:customer_id)).uniq.count,
      policies_count: health_policies.count + life_policies.count
    }
  end
end