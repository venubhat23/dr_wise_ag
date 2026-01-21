class Admin::Reports::UpcomingRenewalReportsController < Admin::Reports::BaseController
  def index
    @upcoming_renewals = []

    # Get policies expiring in next 90 days
    end_date = Date.current + 90.days

    # Health Insurance
    health_renewals = HealthInsurance.includes(:customer, :sub_agent)
                                   .where(policy_end_date: Date.current..end_date)
                                   .where(policy_type: ['New', 'Renewal'])
    @upcoming_renewals += health_renewals.map { |p| format_renewal_data(p, 'Health') }

    # Motor Insurance
    motor_renewals = MotorInsurance.includes(:customer, :sub_agent)
                                 .where(policy_end_date: Date.current..end_date)
                                 .where(policy_type: ['New', 'Renewal'])
    @upcoming_renewals += motor_renewals.map { |p| format_renewal_data(p, 'Motor') }

    # Life Insurance
    life_renewals = LifeInsurance.includes(:customer, :sub_agent)
                               .where(policy_end_date: Date.current..end_date)
                               .where(policy_type: ['New', 'Renewal'])
    @upcoming_renewals += life_renewals.map { |p| format_renewal_data(p, 'Life') }

    # Apply filters
    @upcoming_renewals = filter_renewals(@upcoming_renewals)

    # Sort by expiry date
    @upcoming_renewals.sort_by! { |r| r[:policy_end_date] }

    # Statistics
    @statistics = {
      total_renewals: @upcoming_renewals.count,
      total_renewal_value: @upcoming_renewals.sum { |r| r[:total_premium] },
      by_type: @upcoming_renewals.group_by { |r| r[:insurance_type] }.transform_values(&:count),
      by_timeframe: {
        'Next 7 days' => @upcoming_renewals.count { |r| r[:days_until_expiry] <= 7 },
        'Next 15 days' => @upcoming_renewals.count { |r| r[:days_until_expiry] <= 15 },
        'Next 30 days' => @upcoming_renewals.count { |r| r[:days_until_expiry] <= 30 },
        'Next 60 days' => @upcoming_renewals.count { |r| r[:days_until_expiry] <= 60 },
        'Next 90 days' => @upcoming_renewals.count { |r| r[:days_until_expiry] <= 90 }
      }
    }

    # Paginate
    @upcoming_renewals = Kaminari.paginate_array(@upcoming_renewals).page(params[:page]).per(50)
  end

  def export
    redirect_to admin_reports_upcoming_renewal_reports_path(format: :csv)
  end

  private

  def format_renewal_data(policy, type)
    days_until_expiry = (policy.policy_end_date - Date.current).to_i

    {
      id: policy.id,
      insurance_type: type,
      policy_number: policy.policy_number,
      customer_name: policy.customer&.display_name || 'Unknown',
      customer_email: policy.customer&.email,
      customer_mobile: policy.customer&.mobile,
      policy_start_date: policy.policy_start_date,
      policy_end_date: policy.policy_end_date,
      days_until_expiry: days_until_expiry,
      total_premium: policy.total_premium || 0,
      sum_insured: policy.try(:sum_insured) || policy.try(:total_idv) || 0,
      affiliate: policy.sub_agent&.display_name || 'Self',
      insurance_company: policy.insurance_company_name || 'Unknown',
      renewal_urgency: get_renewal_urgency(days_until_expiry),
      policy_object: policy
    }
  end

  def get_renewal_urgency(days)
    case days
    when 0..7
      'critical'
    when 8..15
      'high'
    when 16..30
      'medium'
    else
      'low'
    end
  end

  def filter_renewals(renewals)
    # Filter by insurance type
    renewals = renewals.select { |r| r[:insurance_type] == params[:insurance_type] } if params[:insurance_type].present?

    # Filter by timeframe
    if params[:timeframe].present?
      case params[:timeframe]
      when 'next_7_days'
        renewals = renewals.select { |r| r[:days_until_expiry] <= 7 }
      when 'next_15_days'
        renewals = renewals.select { |r| r[:days_until_expiry] <= 15 }
      when 'next_30_days'
        renewals = renewals.select { |r| r[:days_until_expiry] <= 30 }
      when 'next_60_days'
        renewals = renewals.select { |r| r[:days_until_expiry] <= 60 }
      end
    end

    # Filter by urgency
    renewals = renewals.select { |r| r[:renewal_urgency] == params[:urgency] } if params[:urgency].present?

    # Search filter
    if params[:search].present?
      search_term = params[:search].downcase
      renewals = renewals.select do |r|
        r[:customer_name].downcase.include?(search_term) ||
        r[:policy_number].downcase.include?(search_term) ||
        r[:customer_email]&.downcase&.include?(search_term)
      end
    end

    renewals
  end
end