class Admin::AnalyticsController < Admin::ApplicationController
  def index
    # Analytics dashboard data
    load_analytics_data
  end

  private

  def load_analytics_data
    # Time ranges
    @current_month = Date.current.beginning_of_month
    @last_month = 1.month.ago.beginning_of_month
    @current_year = Date.current.beginning_of_year
    @last_year = 1.year.ago.beginning_of_year

    # Core metrics
    @total_customers = Customer.count
    @total_policies = calculate_total_policies
    @total_premium = calculate_total_premium_collected
    @total_affiliates = SubAgent.count
    @total_ambassadors = Distributor.count

    # Growth metrics
    @customer_growth = calculate_growth_percentage(Customer, @current_month)
    @policy_growth = calculate_growth_percentage(HealthInsurance, @current_month) +
                     calculate_growth_percentage(LifeInsurance, @current_month) +
                     calculate_growth_percentage(MotorInsurance, @current_month)
    @premium_growth = calculate_premium_growth
    @affiliate_growth = calculate_growth_percentage(SubAgent, @current_month)

    # Policy distribution
    @policy_distribution = {
      'Life Insurance' => LifeInsurance.count,
      'Health Insurance' => HealthInsurance.count,
      'Motor Insurance' => MotorInsurance.count,
      'Other Insurance' => OtherInsurance.count
    }

    # Monthly trends (last 12 months)
    @monthly_trends = calculate_monthly_trends

    # Top performing affiliates
    @top_affiliates = calculate_top_affiliates

    # Recent activities
    @recent_policies = get_recent_policies
    @recent_leads = Lead.order(created_at: :desc).limit(10)

    # Commission analytics
    @commission_summary = calculate_commission_summary

    # Renewal analytics
    @renewal_analytics = calculate_renewal_analytics
  end

  def calculate_total_policies
    HealthInsurance.count + LifeInsurance.count + MotorInsurance.count + OtherInsurance.count
  end

  def calculate_total_premium_collected
    health_premium = HealthInsurance.sum(:total_premium) || 0
    life_premium = LifeInsurance.sum(:total_premium) || 0
    motor_premium = MotorInsurance.sum(:total_premium) || 0
    health_premium + life_premium + motor_premium
  end

  def calculate_growth_percentage(model, period_start)
    current_count = model.where('created_at >= ?', period_start).count
    previous_count = model.where(created_at: (period_start - 1.month)..(period_start - 1.day)).count

    return 0 if previous_count == 0
    ((current_count.to_f - previous_count.to_f) / previous_count.to_f * 100).round(1)
  end

  def calculate_premium_growth
    current_premium = HealthInsurance.where('created_at >= ?', @current_month).sum(:total_premium) +
                      LifeInsurance.where('created_at >= ?', @current_month).sum(:total_premium) +
                      MotorInsurance.where('created_at >= ?', @current_month).sum(:total_premium)

    previous_premium = HealthInsurance.where(created_at: @last_month..(@current_month - 1.day)).sum(:total_premium) +
                       LifeInsurance.where(created_at: @last_month..(@current_month - 1.day)).sum(:total_premium) +
                       MotorInsurance.where(created_at: @last_month..(@current_month - 1.day)).sum(:total_premium)

    return 0 if previous_premium == 0
    ((current_premium.to_f - previous_premium.to_f) / previous_premium.to_f * 100).round(1)
  end

  def calculate_monthly_trends
    trends = {}
    12.times do |i|
      month_date = (Date.current - i.months).beginning_of_month
      month_name = month_date.strftime('%b %Y')

      trends[month_name] = {
        customers: Customer.where(created_at: month_date..(month_date.end_of_month)).count,
        policies: calculate_policies_for_month(month_date),
        premium: calculate_premium_for_month(month_date),
        leads: Lead.where(created_at: month_date..(month_date.end_of_month)).count
      }
    end
    trends.to_a.reverse.to_h
  end

  def calculate_policies_for_month(month_date)
    HealthInsurance.where(created_at: month_date..(month_date.end_of_month)).count +
    LifeInsurance.where(created_at: month_date..(month_date.end_of_month)).count +
    MotorInsurance.where(created_at: month_date..(month_date.end_of_month)).count +
    OtherInsurance.where(created_at: month_date..(month_date.end_of_month)).count
  end

  def calculate_premium_for_month(month_date)
    HealthInsurance.where(created_at: month_date..(month_date.end_of_month)).sum(:total_premium) +
    LifeInsurance.where(created_at: month_date..(month_date.end_of_month)).sum(:total_premium) +
    MotorInsurance.where(created_at: month_date..(month_date.end_of_month)).sum(:total_premium)
  end

  def calculate_top_affiliates
    # Get top 10 affiliates by policies created
    SubAgent.joins(
      "LEFT JOIN health_insurances ON health_insurances.sub_agent_id = sub_agents.id " +
      "LEFT JOIN life_insurances ON life_insurances.sub_agent_id = sub_agents.id " +
      "LEFT JOIN motor_insurances ON motor_insurances.sub_agent_id = sub_agents.id"
    ).group('sub_agents.id, sub_agents.first_name, sub_agents.last_name')
     .select('sub_agents.*, COUNT(*) as policies_count')
     .order('policies_count DESC')
     .limit(10)
  end

  def get_recent_policies
    policies = []

    # Get recent health insurance policies
    HealthInsurance.includes(:customer).order(created_at: :desc).limit(3).each do |policy|
      policies << {
        type: 'Health Insurance',
        customer: policy.customer.display_name,
        policy_number: policy.policy_number,
        premium: policy.total_premium,
        date: policy.created_at
      }
    end

    # Get recent life insurance policies
    LifeInsurance.includes(:customer).order(created_at: :desc).limit(3).each do |policy|
      policies << {
        type: 'Life Insurance',
        customer: policy.customer.display_name,
        policy_number: policy.policy_number,
        premium: policy.total_premium,
        date: policy.created_at
      }
    end

    # Get recent motor insurance policies
    MotorInsurance.includes(:customer).order(created_at: :desc).limit(2).each do |policy|
      policies << {
        type: 'Motor Insurance',
        customer: policy.customer.display_name,
        policy_number: policy.policy_number,
        premium: policy.total_premium,
        date: policy.created_at
      }
    end

    policies.sort_by { |p| p[:date] }.reverse.first(10)
  end

  def calculate_commission_summary
    {
      total_commission_due: CommissionPayout.where(status: 'pending').sum(:payout_amount),
      total_commission_paid: CommissionPayout.where(status: 'paid').sum(:payout_amount),
      affiliate_commissions: CommissionPayout.where(payout_to: 'sub_agent', status: 'pending').sum(:payout_amount),
      ambassador_commissions: CommissionPayout.where(payout_to: 'ambassador', status: 'pending').sum(:payout_amount)
    }
  end

  def calculate_renewal_analytics
    thirty_days_from_now = 30.days.from_now
    sixty_days_from_now = 60.days.from_now

    {
      expiring_soon: calculate_expiring_policies(Date.current, thirty_days_from_now),
      expiring_later: calculate_expiring_policies(thirty_days_from_now, sixty_days_from_now),
      expired: calculate_expired_policies,
      renewal_rate: calculate_renewal_rate
    }
  end

  def calculate_expiring_policies(start_date, end_date)
    HealthInsurance.where(policy_end_date: start_date..end_date).count +
    LifeInsurance.where(policy_end_date: start_date..end_date).count +
    MotorInsurance.where(policy_end_date: start_date..end_date).count +
    OtherInsurance.where(policy_end_date: start_date..end_date).count
  end

  def calculate_expired_policies
    HealthInsurance.where('policy_end_date < ?', Date.current).count +
    LifeInsurance.where('policy_end_date < ?', Date.current).count +
    MotorInsurance.where('policy_end_date < ?', Date.current).count +
    OtherInsurance.where('policy_end_date < ?', Date.current).count
  end

  def calculate_renewal_rate
    # Calculate renewal rate based on renewed vs total eligible policies
    total_eligible = LifeInsurance.where('policy_end_date < ?', Date.current).count +
                     HealthInsurance.where('policy_end_date < ?', Date.current).count
    renewed = LifeInsurance.where(policy_type: 'Renewal').count +
              HealthInsurance.where(policy_type: 'Renewal').count

    return 0 if total_eligible == 0
    ((renewed.to_f / total_eligible.to_f) * 100).round(1)
  end
end