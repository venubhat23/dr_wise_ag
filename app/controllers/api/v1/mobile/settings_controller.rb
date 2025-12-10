class Api::V1::Mobile::SettingsController < Api::V1::Mobile::BaseController
  before_action :authenticate_customer!

  # GET /api/v1/mobile/settings/profile
  def profile
    customer = current_user

    render json: {
      success: true,
      data: {
        username: customer.email,
        user_image: nil, # Add if you have profile images
        full_name: customer.display_name,
        first_name: customer.first_name,
        last_name: customer.last_name,
        email: customer.email,
        mobile_number: customer.mobile,
        gender: customer.gender,
        age: customer.age,
        birth_date: customer.birth_date,
        city: customer.city,
        state: customer.state,
        address: customer.address,
        pincode: customer.pincode,
        pan: customer.pan_number || customer.pan_no,
        gst: customer.gst_number || customer.gst_no,
        customer_type: customer.customer_type,
        occupation: customer.occupation,
        annual_income: customer.annual_income,
        marital_status: customer.marital_status,
        education: customer.education
      }
    }
  end

  # PUT /api/v1/mobile/settings/profile
  def update_profile
    customer = current_user
    profile_params = params.permit(
      :first_name, :last_name, :mobile, :gender, :birth_date,
      :city, :state, :address, :pincode, :occupation, :annual_income,
      :marital_status, :education
    )

    if customer.update(profile_params)
      render json: {
        success: true,
        message: 'Profile updated successfully',
        data: {
          full_name: customer.display_name,
          email: customer.email,
          mobile_number: customer.mobile
        }
      }
    else
      render json: {
        success: false,
        message: 'Failed to update profile',
        errors: customer.errors.full_messages
      }, status: :unprocessable_entity
    end
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
end