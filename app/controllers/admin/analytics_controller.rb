require 'ostruct'

class Admin::AnalyticsController < Admin::ApplicationController
  def index
    # Check for refresh parameter
    if params[:refresh] == 'true'
      refresh_analytics_cache
    end

    # Load analytics data (cached or fresh)
    load_analytics_data
  end

  def refresh
    refresh_analytics_cache
    redirect_to admin_analytics_path, notice: 'Analytics data has been refreshed!'
  end

  private

  def refresh_analytics_cache
    Rails.logger.info "🔄 Refreshing analytics cache..."
    AnalyticsCache.clear_cache('main_analytics')
    load_fresh_analytics_data
  end

  def load_analytics_data
    cache_identifier = 'main_analytics'

    # Try to get cached data first
    if AnalyticsCache.cache_fresh?(cache_identifier, 1.hour)
      Rails.logger.info "📊 Loading analytics from cache..."
      cached_data = AnalyticsCache.get_cached_data(cache_identifier)
      load_data_from_cache(cached_data) if cached_data
    else
      Rails.logger.info "🔄 Cache miss or stale, loading fresh analytics data..."
      load_fresh_analytics_data
    end

    # Set cache info for UI
    set_cache_info(cache_identifier)
  end

  def load_fresh_analytics_data
    cache_identifier = 'main_analytics'
    start_time = Time.current

    Rails.logger.info "🔄 Starting fresh analytics calculation..."

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

    # Agent performance analytics
    @agent_performance = calculate_agent_performance

    # Agent customer data for affiliate performance table
    @agent_customer_data = calculate_agent_customer_data

    # Commission metrics
    @commissions_due = (@commission_summary[:total_commission_due] || 0).to_f
    @conversion_rate = calculate_conversion_rate.to_f

    # Additional metrics for KPI cards
    @avg_policy_value = calculate_avg_policy_value
    @customer_retention = calculate_customer_retention

    # Lead conversion funnel
    @lead_conversion_funnel = calculate_lead_conversion_funnel

    # Lead stage distribution for analytics view
    @lead_stage_distribution = calculate_lead_stage_distribution

    # Customer location analytics
    @customer_location = calculate_customer_location

    # Customer acquisition trend (last 12 months)
    @customer_acquisition_trend = calculate_customer_acquisition_trend

    # Quick Insights data
    @active_customers = calculate_active_customers
    @converted_leads = calculate_converted_leads
    @new_leads = calculate_new_leads
    @support_tickets = calculate_support_tickets

    # Operations Overview data
    @docs_pending = calculate_docs_pending
    @claims_processing = calculate_claims_processing
    @client_requests_count = calculate_client_requests_count

    # Cache the calculated data
    analytics_data = {
      current_month: @current_month,
      last_month: @last_month,
      current_year: @current_year,
      last_year: @last_year,
      total_customers: @total_customers,
      total_policies: @total_policies,
      total_premium: @total_premium,
      total_affiliates: @total_affiliates,
      total_ambassadors: @total_ambassadors,
      customer_growth: @customer_growth,
      policy_growth: @policy_growth,
      premium_growth: @premium_growth,
      affiliate_growth: @affiliate_growth,
      policy_distribution: @policy_distribution,
      monthly_trends: @monthly_trends,
      top_affiliates: @top_affiliates.map(&:to_h),
      recent_policies: @recent_policies,
      recent_leads: @recent_leads.map(&:attributes),
      commission_summary: @commission_summary,
      renewal_analytics: @renewal_analytics,
      agent_performance: @agent_performance,
      agent_customer_data: @agent_customer_data,
      commissions_due: @commissions_due,
      conversion_rate: @conversion_rate,
      avg_policy_value: @avg_policy_value,
      customer_retention: @customer_retention,
      lead_conversion_funnel: @lead_conversion_funnel,
      lead_stage_distribution: @lead_stage_distribution,
      customer_location: @customer_location,
      customer_acquisition_trend: @customer_acquisition_trend,
      active_customers: @active_customers,
      converted_leads: @converted_leads,
      new_leads: @new_leads,
      support_tickets: @support_tickets,
      docs_pending: @docs_pending,
      claims_processing: @claims_processing,
      client_requests_count: @client_requests_count
    }

    AnalyticsCache.cache_analytics_data(cache_identifier, analytics_data)

    calculation_time = (Time.current - start_time).round(2)
    Rails.logger.info "✅ Fresh analytics calculated and cached in #{calculation_time}s"
  end

  def load_data_from_cache(cached_data)
    @current_month = cached_data['current_month']&.to_date
    @last_month = cached_data['last_month']&.to_date
    @current_year = cached_data['current_year']&.to_date
    @last_year = cached_data['last_year']&.to_date
    @total_customers = cached_data['total_customers'].to_i
    @total_policies = cached_data['total_policies'].to_i
    @total_premium = cached_data['total_premium'].to_f
    @total_affiliates = cached_data['total_affiliates'].to_i
    @total_ambassadors = cached_data['total_ambassadors'].to_i
    @customer_growth = cached_data['customer_growth'].to_f
    @policy_growth = cached_data['policy_growth'].to_f
    @premium_growth = cached_data['premium_growth'].to_f
    @affiliate_growth = cached_data['affiliate_growth'].to_f
    @policy_distribution = cached_data['policy_distribution']
    @monthly_trends = cached_data['monthly_trends']

    # Convert Hash objects back to OpenStruct for compatibility with view
    @top_affiliates = (cached_data['top_affiliates'] || []).map do |affiliate_hash|
      OpenStruct.new(affiliate_hash)
    end

    @recent_policies = cached_data['recent_policies']

    # Convert recent leads back to objects for view compatibility
    @recent_leads = (cached_data['recent_leads'] || []).map do |lead_hash|
      OpenStruct.new(lead_hash)
    end
    @commission_summary = cached_data['commission_summary']
    @renewal_analytics = cached_data['renewal_analytics']
    @agent_performance = cached_data['agent_performance']
    @agent_customer_data = cached_data['agent_customer_data']
    @commissions_due = (cached_data['commissions_due'] || 0).to_f
    @conversion_rate = (cached_data['conversion_rate'] || 0).to_f
    @avg_policy_value = cached_data['avg_policy_value']
    @customer_retention = cached_data['customer_retention']
    @lead_conversion_funnel = cached_data['lead_conversion_funnel']
    @lead_stage_distribution = cached_data['lead_stage_distribution']
    @customer_location = cached_data['customer_location']
    @customer_acquisition_trend = cached_data['customer_acquisition_trend']
    @active_customers = cached_data['active_customers'] || 0
    @converted_leads = cached_data['converted_leads'] || 0
    @new_leads = cached_data['new_leads'] || 0
    @support_tickets = cached_data['support_tickets'] || 0
    @docs_pending = cached_data['docs_pending'] || 0
    @claims_processing = cached_data['claims_processing'] || 0
    @client_requests_count = cached_data['client_requests_count'] || 0
  end

  def set_cache_info(cache_identifier)
    cache_record = AnalyticsCache.find_by(cache_identifier: cache_identifier)
    if cache_record
      @cache_last_updated = cache_record.last_updated
      @cache_age_minutes = cache_record.cache_age_minutes
      @data_is_cached = true
    else
      @cache_last_updated = nil
      @cache_age_minutes = 0
      @data_is_cached = false
    end
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
    # Simplified approach to get top affiliates by policy count
    affiliate_data = []

    # Get all sub agents and calculate their policies manually
    SubAgent.limit(50).each do |agent|
      health_count = HealthInsurance.where(sub_agent_id: agent.id).count
      life_count = LifeInsurance.where(sub_agent_id: agent.id).count
      motor_count = MotorInsurance.where(sub_agent_id: agent.id).count
      total_policies = health_count + life_count + motor_count

      if total_policies > 0
        affiliate_data << {
          id: agent.id,
          first_name: agent.first_name,
          last_name: agent.last_name,
          status: agent.status || 'active',
          policies_count: total_policies
        }
      end
    end

    # Sort by policies count and take top 10
    top_affiliates_data = affiliate_data.sort_by { |a| -a[:policies_count] }.first(10)

    # Convert to OpenStruct objects for compatibility
    top_affiliates_data.map { |data| OpenStruct.new(data) }
  rescue => e
    # Return empty array if there's an error
    Rails.logger.error "Error calculating top affiliates: #{e.message}"
    []
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

  def calculate_agent_performance
    # Calculate agent performance based on premium collected
    agent_premiums = {}

    # Get performance from health insurance
    HealthInsurance.joins(:sub_agent)
                   .group("CONCAT(sub_agents.first_name, ' ', sub_agents.last_name)")
                   .sum(:total_premium)
                   .each do |name, premium|
      agent_premiums[name] = (agent_premiums[name] || 0) + premium
    end

    # Get performance from life insurance
    LifeInsurance.joins(:sub_agent)
                 .group("CONCAT(sub_agents.first_name, ' ', sub_agents.last_name)")
                 .sum(:total_premium)
                 .each do |name, premium|
      agent_premiums[name] = (agent_premiums[name] || 0) + premium
    end

    # Get performance from motor insurance
    MotorInsurance.joins(:sub_agent)
                  .group("CONCAT(sub_agents.first_name, ' ', sub_agents.last_name)")
                  .sum(:total_premium)
                  .each do |name, premium|
      agent_premiums[name] = (agent_premiums[name] || 0) + premium
    end

    # Sort by premium amount and return hash
    agent_premiums.sort_by { |name, premium| -premium }.to_h
  rescue => e
    # Return empty hash if there's an error
    Rails.logger.error "Error calculating agent performance: #{e.message}"
    {}
  end

  def calculate_agent_customer_data
    # Calculate customer counts for each agent to avoid DB calls in view
    agent_customers = {}

    # Process each sub agent and calculate their customer metrics
    SubAgent.includes(:customers, :health_insurances, :life_insurances, :motor_insurances).each do |sub_agent|
      agent_name = "#{sub_agent.first_name} #{sub_agent.last_name}"

      # Direct customer count
      customer_count = sub_agent.customers.count

      # Unique customers from each insurance type
      health_customers = sub_agent.health_insurances.distinct.count(:customer_id)
      life_customers = sub_agent.life_insurances.distinct.count(:customer_id)
      motor_customers = sub_agent.motor_insurances.distinct.count(:customer_id)

      # Use the maximum as the customer count (accounts for overlap)
      max_customers = [customer_count, health_customers, life_customers, motor_customers].max

      agent_customers[agent_name] = max_customers if max_customers > 0
    end

    agent_customers
  rescue => e
    Rails.logger.error "Error calculating agent customer data: #{e.message}"
    {}
  end

  def calculate_conversion_rate
    # Calculate lead to policy conversion rate
    total_leads = Lead.count
    total_policies = @total_policies

    return 0 if total_leads == 0
    ((total_policies.to_f / total_leads.to_f) * 100).round(1)
  rescue => e
    Rails.logger.error "Error calculating conversion rate: #{e.message}"
    0
  end

  def calculate_avg_policy_value
    # Calculate average policy value across all insurance types
    return 0 if @total_policies == 0

    total_premium = @total_premium || 0
    (total_premium.to_f / @total_policies.to_f).round(0)
  rescue => e
    Rails.logger.error "Error calculating average policy value: #{e.message}"
    0
  end

  def calculate_customer_retention
    # Calculate customer retention rate based on customers with multiple policies
    total_customers = Customer.count
    return 0 if total_customers == 0

    # Count customers with more than one policy across all insurance types
    customers_with_multiple_policies = Customer.joins(
      "LEFT JOIN health_insurances ON health_insurances.customer_id = customers.id " +
      "LEFT JOIN life_insurances ON life_insurances.customer_id = customers.id " +
      "LEFT JOIN motor_insurances ON motor_insurances.customer_id = customers.id"
    ).group('customers.id')
     .having('COUNT(health_insurances.id) + COUNT(life_insurances.id) + COUNT(motor_insurances.id) > 1')
     .count.keys.length

    ((customers_with_multiple_policies.to_f / total_customers.to_f) * 100).round(1)
  rescue => e
    Rails.logger.error "Error calculating customer retention: #{e.message}"
    0
  end

  def calculate_lead_conversion_funnel
    # Calculate conversion funnel showing leads at different stages
    {
      'Leads Generated' => Lead.count,
      'Contacted' => Lead.where(current_stage: ['contacted', 'interested', 'quoted', 'policy_created']).count,
      'Interested' => Lead.where(current_stage: ['interested', 'quoted', 'policy_created']).count,
      'Quoted' => Lead.where(current_stage: ['quoted', 'policy_created']).count,
      'Converted' => Lead.where(current_stage: 'policy_created').count
    }
  rescue => e
    Rails.logger.error "Error calculating lead conversion funnel: #{e.message}"
    {
      'Leads Generated' => 0,
      'Contacted' => 0,
      'Interested' => 0,
      'Quoted' => 0,
      'Converted' => 0
    }
  end

  def calculate_lead_stage_distribution
    # Calculate lead distribution by current stage for analytics view
    {
      'New Leads' => Lead.where(current_stage: 'lead_generated').count,
      'Contacted' => Lead.where(current_stage: ['follow_up', 'follow_up_successful']).count,
      'Consultation' => Lead.where(current_stage: 'consultation_scheduled').count,
      'One-on-One' => Lead.where(current_stage: 'one_on_one').count,
      'Converted' => Lead.where(current_stage: 'converted').count
    }
  rescue => e
    Rails.logger.error "Error calculating lead stage distribution: #{e.message}"
    {
      'New Leads' => 0,
      'Contacted' => 0,
      'Consultation' => 0,
      'One-on-One' => 0,
      'Converted' => 0
    }
  end

  def calculate_customer_location
    # Calculate customer distribution by location (city/state)
    location_data = {}

    # Group customers by city or state, whichever is available
    Customer.group(:city).count.each do |city, count|
      next if city.blank?
      location_data[city.to_s.titleize] = count
    end

    # If no city data, try state
    if location_data.empty?
      Customer.group(:state).count.each do |state, count|
        next if state.blank?
        location_data[state.to_s.titleize] = count
      end
    end

    # If still no data, provide a default
    if location_data.empty?
      location_data = { 'Unknown' => Customer.count }
    end

    location_data
  rescue => e
    Rails.logger.error "Error calculating customer location: #{e.message}"
    { 'Unknown' => Customer.count }
  end

  def calculate_customer_acquisition_trend
    # Calculate customer acquisition trend for last 12 months
    trend_data = {}

    12.times do |i|
      month_date = (Date.current - i.months).beginning_of_month
      month_name = month_date.strftime('%b %Y')

      customer_count = Customer.where(created_at: month_date..(month_date.end_of_month)).count
      trend_data[month_name] = customer_count
    end

    # Return in chronological order (oldest to newest)
    trend_data.to_a.reverse.to_h
  rescue => e
    Rails.logger.error "Error calculating customer acquisition trend: #{e.message}"
    {
      'Jan 2024' => 0,
      'Feb 2024' => 0,
      'Mar 2024' => 0,
      'Apr 2024' => 0,
      'May 2024' => 0,
      'Jun 2024' => 0,
      'Jul 2024' => 0,
      'Aug 2024' => 0,
      'Sep 2024' => 0,
      'Oct 2024' => 0,
      'Nov 2024' => 0,
      'Dec 2024' => 0
    }
  end

  def calculate_active_customers
    # Count customers who have made policies in the last 6 months or are marked as active
    recent_policy_customers = Customer.joins(
      "LEFT JOIN health_insurances ON health_insurances.customer_id = customers.id " +
      "LEFT JOIN life_insurances ON life_insurances.customer_id = customers.id " +
      "LEFT JOIN motor_insurances ON motor_insurances.customer_id = customers.id"
    ).where(
      "health_insurances.created_at > ? OR life_insurances.created_at > ? OR motor_insurances.created_at > ? OR customers.status = true",
      6.months.ago, 6.months.ago, 6.months.ago
    ).distinct.count

    recent_policy_customers
  rescue => e
    Rails.logger.error "Error calculating active customers: #{e.message}"
    Customer.where(status: true).count rescue Customer.count
  end

  def calculate_converted_leads
    # Count leads that have been converted to customers with policies
    Lead.where(current_stage: ['policy_created', 'converted']).count
  rescue => e
    Rails.logger.error "Error calculating converted leads: #{e.message}"
    0
  end

  def calculate_new_leads
    # Count leads created in the last 7 days
    Lead.where('created_at >= ?', 7.days.ago).count
  rescue => e
    Rails.logger.error "Error calculating new leads: #{e.message}"
    0
  end

  def calculate_support_tickets
    # Count open support tickets (assuming you have a helpdesk model)
    if defined?(Helpdesk)
      Helpdesk.where(status: ['open', 'in_progress']).count
    elsif defined?(ClientRequest)
      ClientRequest.where(status: ['pending', 'in_progress']).count
    else
      # Default fallback
      0
    end
  rescue => e
    Rails.logger.error "Error calculating support tickets: #{e.message}"
    0
  end

  def calculate_docs_pending
    # Count pending documents across different models
    pending_count = 0

    # Check if Document model exists and count pending documents
    if defined?(Document)
      pending_count += Document.where(status: 'pending').count rescue 0
    end

    # Alternative: count policies without required documents
    # This is a placeholder - adjust based on your document requirements
    health_without_docs = HealthInsurance.left_joins(:documents).where(documents: { id: nil }).count rescue 0
    life_without_docs = LifeInsurance.left_joins(:documents).where(documents: { id: nil }).count rescue 0
    motor_without_docs = MotorInsurance.left_joins(:documents).where(documents: { id: nil }).count rescue 0

    pending_count + health_without_docs + life_without_docs + motor_without_docs
  rescue => e
    Rails.logger.error "Error calculating docs pending: #{e.message}"
    0
  end

  def calculate_claims_processing
    # Count claims being processed (assuming you have a claims model)
    if defined?(Claim)
      Claim.where(status: ['submitted', 'under_review', 'processing']).count
    else
      # Alternative: count policies with recent claims activity
      # This is a placeholder - adjust based on your claims system
      0
    end
  rescue => e
    Rails.logger.error "Error calculating claims processing: #{e.message}"
    0
  end

  def calculate_client_requests_count
    # Count active client requests
    if defined?(ClientRequest)
      ClientRequest.where(status: ['pending', 'in_progress']).count
    elsif defined?(Helpdesk)
      Helpdesk.where(status: ['open', 'in_progress']).count
    else
      # Alternative: count recent customer communications
      # This is a placeholder - adjust based on your system
      5
    end
  rescue => e
    Rails.logger.error "Error calculating client requests: #{e.message}"
    0
  end
end