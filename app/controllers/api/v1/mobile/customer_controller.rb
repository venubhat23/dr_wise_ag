class Api::V1::Mobile::CustomerController < Api::V1::Mobile::BaseController
  before_action :authenticate_customer!

  # GET /api/v1/mobile/customer/portfolio
  def portfolio
    customer_id = current_customer.id

    # Get all health insurance policies
    health_policies = HealthInsurance.where(customer_id: customer_id)

    # Get all life insurance policies
    life_policies = LifeInsurance.where(customer_id: customer_id)

    portfolio = []

    # Add health insurance policies
    health_policies.each do |policy|
      portfolio << {
        id: policy.id,
        insurance_name: policy.plan_name || "Health Insurance",
        insurance_type: "Health",
        policy_number: policy.policy_number,
        policy_holder: policy.policy_holder,
        start_date: policy.policy_start_date,
        end_date: policy.policy_end_date,
        total_premium: policy.total_premium,
        sum_insured: policy.sum_insured,
        insurance_company: policy.insurance_company_name,
        payment_mode: policy.payment_mode,
        status: policy.active? ? 'Active' : (policy.expired? ? 'Expired' : 'Expiring Soon'),
        days_until_expiry: policy.days_until_expiry,
        attachment: policy.policy_documents.attached? ? rails_blob_url(policy.policy_documents.first) : nil
      }
    end

    # Add life insurance policies
    life_policies.each do |policy|
      portfolio << {
        id: policy.id,
        insurance_name: policy.plan_name || "Life Insurance",
        insurance_type: "Life",
        policy_number: policy.policy_number,
        policy_holder: policy.policy_holder,
        start_date: policy.policy_start_date,
        end_date: policy.policy_end_date,
        total_premium: policy.total_premium,
        sum_insured: policy.sum_insured,
        insurance_company: policy.insurance_company_name,
        payment_mode: policy.payment_mode,
        status: policy.active? ? 'Active' : (policy.expired? ? 'Expired' : 'Expiring Soon'),
        days_until_expiry: policy.days_until_expiry,
        attachment: policy.policy_documents.attached? ? rails_blob_url(policy.policy_documents.first) : nil,
        # Life insurance specific fields
        nominee_name: policy.nominee_name,
        nominee_relationship: policy.nominee_relationship,
        policy_term: policy.policy_term,
        premium_payment_term: policy.premium_payment_term
      }
    end

    # Sort by start date (newest first)
    portfolio = portfolio.sort_by { |p| p[:start_date] }.reverse

    render json: {
      success: true,
      data: {
        portfolio: portfolio,
        total_policies: portfolio.count,
        total_premium: portfolio.sum { |p| p[:total_premium].to_f },
        total_sum_insured: portfolio.sum { |p| p[:sum_insured].to_f },
        active_policies: portfolio.count { |p| p[:status] == 'Active' },
        expiring_policies: portfolio.count { |p| p[:status] == 'Expiring Soon' }
      }
    }
  end

  # GET /api/v1/mobile/customer/upcoming_installments
  def upcoming_installments
    customer_id = current_customer.id

    # Get policies with upcoming installments (based on payment mode and autopay dates)
    installments = []

    # Health Insurance installments
    health_policies = HealthInsurance.where(customer_id: customer_id).active
    health_policies.each do |policy|
      next unless policy.installment_autopay_start_date.present?

      # Calculate next installment date based on payment mode
      next_installment = calculate_next_installment_date(policy.installment_autopay_start_date, policy.payment_mode)

      if next_installment && next_installment <= 30.days.from_now
        installments << {
          id: policy.id,
          insurance_name: policy.plan_name || "Health Insurance",
          insurance_type: "Health",
          policy_number: policy.policy_number,
          policy_holder: policy.policy_holder,
          start_date: policy.policy_start_date,
          end_date: policy.policy_end_date,
          total_premium: policy.total_premium,
          next_installment_date: next_installment,
          installment_amount: calculate_installment_amount(policy.total_premium, policy.payment_mode),
          attachment: policy.policy_documents.attached? ? rails_blob_url(policy.policy_documents.first) : nil
        }
      end
    end

    # Life Insurance installments
    life_policies = LifeInsurance.where(customer_id: customer_id).active
    life_policies.each do |policy|
      next unless policy.installment_autopay_start_date.present?

      next_installment = calculate_next_installment_date(policy.installment_autopay_start_date, policy.payment_mode)

      if next_installment && next_installment <= 30.days.from_now
        installments << {
          id: policy.id,
          insurance_name: policy.plan_name || "Life Insurance",
          insurance_type: "Life",
          policy_number: policy.policy_number,
          policy_holder: policy.policy_holder,
          start_date: policy.policy_start_date,
          end_date: policy.policy_end_date,
          total_premium: policy.total_premium,
          next_installment_date: next_installment,
          installment_amount: calculate_installment_amount(policy.total_premium, policy.payment_mode),
          attachment: policy.policy_documents.attached? ? rails_blob_url(policy.policy_documents.first) : nil
        }
      end
    end

    # Sort by installment date
    installments = installments.sort_by { |i| i[:next_installment_date] }

    render json: {
      success: true,
      data: {
        upcoming_installments: installments,
        total_installments: installments.count,
        total_amount: installments.sum { |i| i[:installment_amount].to_f }
      }
    }
  end

  # GET /api/v1/mobile/customer/upcoming_renewals
  def upcoming_renewals
    customer_id = current_customer.id

    renewals = []

    # Health Insurance renewals (expiring in next 60 days)
    health_policies = HealthInsurance.where(customer_id: customer_id)
                                    .where('policy_end_date BETWEEN ? AND ?', Date.current, 60.days.from_now)

    health_policies.each do |policy|
      renewals << {
        id: policy.id,
        insurance_name: policy.plan_name || "Health Insurance",
        insurance_type: "Health",
        policy_number: policy.policy_number,
        policy_holder: policy.policy_holder,
        start_date: policy.policy_start_date,
        end_date: policy.policy_end_date,
        renewal_date: policy.policy_end_date + 1.day,
        total_premium: policy.total_premium,
        days_until_renewal: (policy.policy_end_date - Date.current).to_i,
        insurance_company: policy.insurance_company_name,
        attachment: policy.policy_documents.attached? ? rails_blob_url(policy.policy_documents.first) : nil
      }
    end

    # Life Insurance renewals (expiring in next 60 days)
    life_policies = LifeInsurance.where(customer_id: customer_id)
                                .where('policy_end_date BETWEEN ? AND ?', Date.current, 60.days.from_now)

    life_policies.each do |policy|
      renewals << {
        id: policy.id,
        insurance_name: policy.plan_name || "Life Insurance",
        insurance_type: "Life",
        policy_number: policy.policy_number,
        policy_holder: policy.policy_holder,
        start_date: policy.policy_start_date,
        end_date: policy.policy_end_date,
        renewal_date: policy.policy_end_date + 1.day,
        total_premium: policy.total_premium,
        days_until_renewal: (policy.policy_end_date - Date.current).to_i,
        insurance_company: policy.insurance_company_name,
        attachment: policy.policy_documents.attached? ? rails_blob_url(policy.policy_documents.first) : nil
      }
    end

    # Sort by renewal date
    renewals = renewals.sort_by { |r| r[:renewal_date] }

    render json: {
      success: true,
      data: {
        upcoming_renewals: renewals,
        total_renewals: renewals.count,
        urgent_renewals: renewals.count { |r| r[:days_until_renewal] <= 7 }
      }
    }
  end

  # POST /api/v1/mobile/customer/add_policy
  def add_policy
    policy_params = params.permit(:insurance_type, :plan_name, :sum_insured, :premium_amount,
                                  :"premium amount", :"Renewal date",
                                  :renewal_date, :policy_number, :insurance_company, :remarks,
                                  family_members: [])

    # Handle the premium amount field with space
    premium_amount = policy_params[:premium_amount] || policy_params[:"premium amount"]
    renewal_date = policy_params[:renewal_date] || policy_params[:"Renewal date"]

    # Validate required fields
    if policy_params[:insurance_type].blank?
      return render json: {
        success: false,
        message: 'Insurance type is required'
      }, status: :unprocessable_entity
    end

    if policy_params[:plan_name].blank?
      return render json: {
        success: false,
        message: 'Plan name is required'
      }, status: :unprocessable_entity
    end

    if policy_params[:sum_insured].blank? || policy_params[:sum_insured].to_f <= 0
      return render json: {
        success: false,
        message: 'Sum insured is required and must be greater than 0'
      }, status: :unprocessable_entity
    end

    if premium_amount.blank? || premium_amount.to_f <= 0
      return render json: {
        success: false,
        message: 'Premium amount is required and must be greater than 0'
      }, status: :unprocessable_entity
    end

    # Create a policy request or notification for admin to review
    # This is a simplified implementation - you might want to create a separate PolicyRequest model

    case policy_params[:insurance_type].downcase
    when 'health'
      policy = HealthInsurance.new(
        customer_id: current_customer.id,
        policy_holder: current_customer.display_name || 'Self',
        plan_name: policy_params[:plan_name],
        insurance_company_name: policy_params[:insurance_company] || 'To be assigned',
        insurance_type: 'Individual',
        policy_type: 'New',
        policy_number: policy_params[:policy_number] || "REQ-#{Time.current.to_i}",
        policy_booking_date: Date.current,
        policy_start_date: Date.current,
        policy_end_date: renewal_date&.to_date || 1.year.from_now,
        payment_mode: 'Yearly',
        sum_insured: policy_params[:sum_insured].to_f,
        net_premium: premium_amount&.to_f || 0,
        total_premium: premium_amount&.to_f || 0,
        gst_percentage: 18,
        is_customer_added: true,
        is_agent_added: false,
        is_admin_added: false
      )

      # Store additional info in a notes field or separate model
      if policy_params[:family_members].present?
        family_info = "Family members to be covered: #{policy_params[:family_members].join(', ')}"
        # You might want to add this to a notes field or create family member records
      end

    when 'life', 'lic'
      policy = LifeInsurance.new(
        customer_id: current_customer.id,
        policy_holder: current_customer.display_name || 'Self',
        plan_name: policy_params[:plan_name],
        insurance_company_name: policy_params[:insurance_company] || 'To be assigned',
        policy_type: 'New',
        policy_number: policy_params[:policy_number] || "REQ-#{Time.current.to_i}",
        policy_booking_date: Date.current,
        policy_start_date: Date.current,
        policy_end_date: renewal_date&.to_date || 20.years.from_now,
        payment_mode: 'Yearly',
        policy_term: 20,
        premium_payment_term: 10,
        sum_insured: policy_params[:sum_insured].to_f,
        net_premium: premium_amount&.to_f || 0,
        total_premium: premium_amount&.to_f || 0,
        first_year_gst_percentage: 18,
        is_customer_added: true,
        is_agent_added: false,
        is_admin_added: false
      )

    when 'motor'
      return render json: {
        success: false,
        message: 'Motor insurance requests are not available through customer portal. Please contact your agent.'
      }, status: :unprocessable_entity

    when 'other'
      return render json: {
        success: false,
        message: 'Other insurance requests are not available through customer portal. Please contact your agent.'
      }, status: :unprocessable_entity

    else
      return render json: {
        success: false,
        message: 'Invalid insurance type. Supported types: health, life'
      }, status: :unprocessable_entity
    end

    if policy&.save
      render json: {
        success: true,
        message: 'Policy request submitted successfully! Our team will review your request and contact you within 24 hours.',
        data: {
          policy_id: policy.id,
          policy_number: policy.policy_number,
          insurance_type: policy_params[:insurance_type],
          plan_name: policy_params[:plan_name],
          sum_insured: policy_params[:sum_insured].to_f,
          premium_amount: premium_amount&.to_f || 0,
          renewal_date: renewal_date,
          status: 'pending_approval',
          family_members: policy_params[:family_members] || [],
          remarks: policy_params[:remarks],
          submitted_at: Time.current.iso8601
        }
      }
    else
      render json: {
        success: false,
        message: 'Failed to submit policy request',
        errors: policy&.errors&.full_messages || ['Unable to create policy request']
      }, status: :unprocessable_entity
    end
  end

  private

  def calculate_next_installment_date(start_date, payment_mode)
    return nil unless start_date

    case payment_mode.downcase
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

  def calculate_installment_amount(total_premium, payment_mode)
    return total_premium unless total_premium && payment_mode

    case payment_mode.downcase
    when 'monthly'
      total_premium / 12.0
    when 'quarterly'
      total_premium / 4.0
    when 'half-yearly', 'half yearly'
      total_premium / 2.0
    when 'yearly'
      total_premium
    else
      total_premium
    end
  end
end