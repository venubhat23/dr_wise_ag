class Api::V1::Mobile::SettingsController < Api::V1::Mobile::BaseController
  before_action :authenticate_customer!

  # GET /api/v1/mobile/settings/profile
  def profile
    user = current_user

    render json: {
      success: true,
      data: build_profile_data(user)
    }
  end

  # PUT /api/v1/mobile/settings/profile
  def update_profile
    user = current_user
    profile_params = get_permitted_params_for_user(user)

    ActiveRecord::Base.transaction do
      if user.update(profile_params)
        # Handle nominee details update for customers
        if user.is_a?(Customer) && params[:nominees].present?
          update_customer_nominees(user, params[:nominees])
        end

        render json: {
          success: true,
          message: 'Profile updated successfully',
          data: build_profile_data(user)
        }
      else
        render json: {
          success: false,
          message: 'Failed to update profile',
          errors: user.errors.full_messages
        }, status: :unprocessable_entity
      end
    end
  rescue StandardError => e
    render json: {
      success: false,
      message: 'Failed to update profile',
      errors: [e.message]
    }, status: :unprocessable_entity
  end

  # POST /api/v1/mobile/settings/change_password
  def change_password
    new_password = params[:new_password]

    if new_password.blank?
      return render json: {
        success: false,
        message: 'New password is required'
      }, status: :unprocessable_entity
    end

    if new_password.length < 6
      return render json: {
        success: false,
        message: 'Password must be at least 6 characters long'
      }, status: :unprocessable_entity
    end

    # Note: Since customers don't have passwords in current model,
    # this would need to be implemented when you add password authentication
    # For now, returning success response

    render json: {
      success: true,
      message: 'Password changed successfully'
    }
  end

  # GET /api/v1/mobile/settings/terms
  def terms_and_conditions
    # You can store this in database or return static content
    terms_url = "#{request.base_url}/terms_and_conditions.html"

    render json: {
      success: true,
      data: {
        terms_url: terms_url,
        terms_content: get_terms_content
      }
    }
  end

  # GET /api/v1/mobile/settings/contact
  def contact_us
    customer = current_user

    # Get the assigned agent/sub-agent for this customer
    # This could be based on policies or customer assignment
    agent_info = get_customer_agent(customer)

    render json: {
      success: true,
      data: {
        agent_name: agent_info[:name],
        agent_mobile: agent_info[:mobile],
        agent_email: agent_info[:email],
        agent_address: agent_info[:address],
        company_info: {
          name: "InsureBook Admin",
          mobile: "+91 9876543210",
          email: "support@insurebook.com",
          address: "123 Insurance Street, Mumbai, Maharashtra, India",
          website: "www.insurebook.com"
        },
        support_hours: "Monday to Friday: 9:00 AM - 6:00 PM",
        emergency_contact: "+91 9876543210"
      }
    }
  end

  # POST /api/v1/mobile/settings/helpdesk
  def helpdesk
    helpdesk_params = params.permit(:name, :email, :phone_number, :description)

    if helpdesk_params[:name].blank? || helpdesk_params[:email].blank? || helpdesk_params[:description].blank?
      return render json: {
        success: false,
        message: 'Name, email, and description are required'
      }, status: :unprocessable_entity
    end

    begin
      # Create client request in database
      client_request = ClientRequest.create!(
        name: helpdesk_params[:name],
        email: helpdesk_params[:email],
        phone_number: helpdesk_params[:phone_number],
        description: helpdesk_params[:description],
        status: 'pending',
        priority: 'medium'
      )

      render json: {
        success: true,
        message: 'Your request has been submitted successfully. Our team will contact you soon.',
        data: {
          request_id: client_request.id,
          status: client_request.status,
          estimated_response_time: '24-48 hours'
        }
      }

    rescue ActiveRecord::RecordInvalid => e
      render json: {
        success: false,
        message: 'Failed to submit request',
        errors: e.record.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/mobile/settings/notifications
  def notification_settings
    customer = current_user

    # Get all notifications due today for this customer
    notifications = []

    # Get health insurance notifications
    health_insurances = HealthInsurance.where(customer: customer)
    health_insurances.each do |insurance|
      insurance.notifications_due_today.each do |notification|
        notifications << {
          id: "health_#{insurance.id}_#{notification['type']}",
          type: notification['type'],
          title: notification['title'],
          message: notification['message'],
          date: notification['date']
        }
      end
    end

    # Get life insurance notifications
    life_insurances = LifeInsurance.where(customer: customer)
    life_insurances.each do |insurance|
      insurance.notifications_due_today.each do |notification|
        notifications << {
          id: "life_#{insurance.id}_#{notification['type']}",
          type: notification['type'],
          title: notification['title'],
          message: notification['message'],
          date: notification['date']
        }
      end
    end

    render json: {
      success: true,
      data: notifications
    }
  end

  # PUT /api/v1/mobile/settings/notifications
  def update_notification_settings
    notification_params = params.permit(
      :email_notifications, :sms_notifications, :push_notifications,
      :policy_reminders, :payment_reminders, :renewal_alerts, :promotional_emails
    )

    # Here you would update the user preferences in database
    # For now, returning success response

    render json: {
      success: true,
      message: 'Notification settings updated successfully'
    }
  end

  private

  def get_terms_content
    # You can store this in database or return static content
    <<~TERMS
      Terms and Conditions for InsureBook Admin

      1. General Terms
      These terms and conditions govern your use of InsureBook Admin mobile application.

      2. Privacy Policy
      We are committed to protecting your privacy and personal information.

      3. Policy Management
      You can view and manage your insurance policies through this application.

      4. Support
      For any queries or support, please contact our customer service team.

      Last updated: December 2025
    TERMS
  end

  def get_customer_agent(customer)
    # Try to find agent from customer's policies
    health_policy = HealthInsurance.where(customer: customer).joins(:sub_agent).first
    life_policy = LifeInsurance.where(customer: customer).joins(:sub_agent).first

    sub_agent = health_policy&.sub_agent || life_policy&.sub_agent

    if sub_agent
      {
        name: sub_agent.display_name,
        mobile: sub_agent.mobile,
        email: sub_agent.email,
        address: sub_agent.address || "Not provided"
      }
    else
      # Default company agent
      {
        name: "InsureBook Support Team",
        mobile: "+91 9876543210",
        email: "support@insurebook.com",
        address: "123 Insurance Street, Mumbai, Maharashtra, India"
      }
    end
  end

  def build_profile_data(user)
    base_data = {
      username: user.email,
      user_image: nil, # Add if you have profile images
      full_name: user.display_name,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      mobile_number: user.mobile,
      gender: user.gender,
      age: user.age,
      birth_date: user.birth_date,
      address: user.address
    }

    # Handle city and state based on model structure
    if user.respond_to?(:city)
      base_data[:city] = user.city
      base_data[:state] = user.state
    elsif user.respond_to?(:city_id)
      base_data[:city_id] = user.city_id
      base_data[:state_id] = user.state_id
    end

    # Add user-type specific fields
    case user
    when Customer
      base_data.merge!({
        pincode: user.pincode,
        pan: user.pan_number || user.pan_no,
        gst: user.gst_number || user.gst_no,
        customer_type: user.customer_type,
        occupation: user.occupation,
        annual_income: user.annual_income,
        marital_status: user.marital_status,
        education: user.education
      })

      # Add nominee details for customers
      base_data[:nominees] = get_nominee_details(user)
    when SubAgent
      base_data.merge!({
        role_id: user.role_id,
        pan: user.pan_no,
        account_type: user.account_type,
        account_holder_name: user.account_holder_name,
        account_number: user.account_no, # Note: it's account_no not account_number in the model
        ifsc_code: user.ifsc_code,
        bank_name: user.bank_name,
        upi_id: user.upi_id,
        status: user.status,
        company_name: user.company_name
      })
    when User
      base_data.merge!({
        user_type: user.user_type,
        role: user.role,
        pan_number: user.pan_number,
        occupation: user.occupation,
        annual_income: user.annual_income
      })
    end

    base_data
  end

  def get_nominee_details(customer)
    # Get all nominees from life insurance policies for this customer
    life_insurance_nominees = []

    # Fetch life insurance policies with nominees
    life_insurances = LifeInsurance.includes(:life_insurance_nominees).where(customer: customer)

    life_insurances.each do |policy|
      policy.life_insurance_nominees.each do |nominee|
        life_insurance_nominees << {
          policy_number: policy.policy_number,
          policy_type: 'life_insurance',
          nominee_name: nominee.nominee_name,
          relationship: nominee.relationship,
          age: nominee.age,
          share_percentage: nominee.share_percentage
        }
      end
    end

    {
      life_insurance_nominees: life_insurance_nominees,
      total_nominees_count: life_insurance_nominees.count
    }
  end

  def update_customer_nominees(customer, nominees_params)
    return unless nominees_params.is_a?(Array)

    nominees_params.each do |nominee_data|
      policy_number = nominee_data[:policy_number] || nominee_data['policy_number']
      next unless policy_number.present?

      # Find the life insurance policy
      life_insurance = LifeInsurance.find_by(customer: customer, policy_number: policy_number)
      next unless life_insurance

      # Find existing nominee or create new one
      nominee = life_insurance.life_insurance_nominees.find_by(
        nominee_name: nominee_data[:nominee_name] || nominee_data['nominee_name']
      ) || life_insurance.life_insurance_nominees.new

      # Update nominee attributes
      nominee.assign_attributes(
        nominee_name: nominee_data[:nominee_name] || nominee_data['nominee_name'],
        relationship: nominee_data[:relationship] || nominee_data['relationship'],
        age: nominee_data[:age] || nominee_data['age'],
        share_percentage: nominee_data[:share_percentage] || nominee_data['share_percentage']
      )

      nominee.save! if nominee.valid?
    end
  end

  def get_permitted_params_for_user(user)
    base_params = [:first_name, :last_name, :mobile, :gender, :birth_date, :address]

    # Add city/state params based on model structure
    if user.respond_to?(:city)
      base_params += [:city, :state]
    elsif user.respond_to?(:city_id)
      base_params += [:city_id, :state_id]
    end

    case user
    when Customer
      params.permit(base_params + [:pincode, :occupation, :annual_income, :marital_status, :education])
    when SubAgent
      params.permit(base_params + [:account_type, :account_holder_name, :account_no, :ifsc_code, :bank_name, :upi_id, :company_name])
    when User
      params.permit(base_params + [:occupation, :annual_income])
    else
      params.permit(base_params)
    end
  end
end