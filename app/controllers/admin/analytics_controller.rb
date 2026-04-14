require 'ostruct'

class Admin::AnalyticsController < Admin::ApplicationController
  def index
    # Handle date filter parameters
    setup_filter_dates

    # Check for refresh parameter
    if params[:refresh] == 'true'
      refresh_analytics_cache
    end

    # Load analytics data (filtered or cached)
    if has_filter_params?
      load_filtered_analytics_data
    else
      load_analytics_data
    end

    # Handle AJAX requests for chart data
    if request.xhr? && params[:chart].present?
      chart_name = params[:chart]
      render json: get_chart_data(chart_name)
      return
    end
  end

  def refresh
    refresh_analytics_cache
    redirect_to admin_analytics_path, notice: 'Analytics data has been refreshed!'
  end

  private

  def setup_filter_dates
    # Get date filter parameters (default to current year)
    current_year = Date.current.year
    @filter_year = params[:year].present? ? params[:year].to_i : current_year
    @filter_month = params[:month].present? ? params[:month].to_i : nil
    @filter_start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.new(@filter_year, 1, 1)
    @filter_end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.new(@filter_year, 12, 31)

    # If month is specified, filter by that month
    if @filter_month.present?
      @filter_start_date = Date.new(@filter_year, @filter_month, 1)
      @filter_end_date = @filter_start_date.end_of_month
    end
  end

  def has_filter_params?
    params[:year].present? || params[:month].present? || params[:start_date].present? || params[:end_date].present?
  end

  def load_filtered_analytics_data
    Rails.logger.info "🔍 Loading filtered analytics data for period: #{@filter_start_date} to #{@filter_end_date}"

    # Use the same filtered data approach as dashboard controller
    filtered_data = get_filtered_analytics_data(@filter_start_date, @filter_end_date)

    # Set instance variables from filtered data
    filtered_data.each { |key, value| instance_variable_set("@#{key}", value) }
  end

  def get_filtered_analytics_data(start_date, end_date)
    # Time ranges
    @current_month = start_date.beginning_of_month
    @last_month = (start_date - 1.month).beginning_of_month
    @current_year = start_date.beginning_of_year
    @last_year = (start_date - 1.year).beginning_of_year

    # Core metrics for the filtered period
    @total_customers = Customer.where(created_at: start_date..end_date).count
    @total_policies = calculate_total_policies_for_period(start_date, end_date)
    @total_premium = calculate_total_premium_for_period(start_date, end_date)
    @total_affiliates = SubAgent.where(created_at: start_date..end_date).count
    @total_ambassadors = Distributor.where(created_at: start_date..end_date).count

    # Growth metrics (compare with previous period of same duration)
    period_duration = (end_date - start_date).days
    previous_start = start_date - period_duration.days
    previous_end = start_date - 1.day

    @customer_growth = calculate_growth_for_period(Customer, start_date, end_date, previous_start, previous_end)
    @policy_growth = calculate_policy_growth_for_period(start_date, end_date, previous_start, previous_end)
    @premium_growth = calculate_premium_growth_for_period(start_date, end_date, previous_start, previous_end)
    @affiliate_growth = calculate_growth_for_period(SubAgent, start_date, end_date, previous_start, previous_end)

    # Policy distribution for the filtered period
    @policy_distribution = {
      'Life Insurance' => LifeInsurance.where(product_through_dr: true, created_at: start_date..end_date).count,
      'Health Insurance' => HealthInsurance.where(product_through_dr: true, created_at: start_date..end_date).count,
      'Motor Insurance' => MotorInsurance.where(product_through_dr: true, created_at: start_date..end_date).count,
      'Other Insurance' => OtherInsurance.where(product_through_dr: true, created_at: start_date..end_date).count
    }

    # Monthly trends within the filtered period (up to 12 months)
    @monthly_trends = calculate_monthly_trends_for_period(start_date, end_date)

    # Top performing affiliates for the period
    @top_affiliates = calculate_top_affiliates_for_period(start_date, end_date)

    # Recent activities for the period
    @recent_policies = get_recent_policies_for_period(start_date, end_date)
    @recent_leads = Lead.where(created_at: start_date..end_date).order(created_at: :desc).limit(10)

    # Commission analytics for the period
    @commission_summary = calculate_commission_summary_for_period(start_date, end_date)

    # Renewal analytics for the period
    @renewal_analytics = calculate_renewal_analytics_for_period(start_date, end_date)

    # Lead analytics for the period
    @lead_conversion_funnel = calculate_lead_conversion_funnel_for_period(start_date, end_date)
    @lead_stage_distribution = calculate_lead_stage_distribution_for_period(start_date, end_date)

    # Customer location analytics for the period
    @customer_location = calculate_customer_location_for_period(start_date, end_date)

    # Additional metrics
    @conversion_rate = calculate_conversion_rate_for_period(start_date, end_date)
    @avg_policy_value = @total_policies > 0 ? (@total_premium / @total_policies).round(0) : 0
    @commissions_due = (@commission_summary[:total_commission_due] || 0).to_f

    # Return the instance variables as a hash for consistency
    {
      filter_start_date: start_date,
      filter_end_date: end_date,
      filter_year: start_date.year,
      filter_month: start_date.month == end_date.month ? start_date.month : nil
    }
  end

  # Helper methods for filtered calculations
  def calculate_total_policies_for_period(start_date, end_date)
    HealthInsurance.where(product_through_dr: true, created_at: start_date..end_date).count +
    LifeInsurance.where(product_through_dr: true, created_at: start_date..end_date).count +
    MotorInsurance.where(product_through_dr: true, created_at: start_date..end_date).count +
    OtherInsurance.where(product_through_dr: true, created_at: start_date..end_date).count
  end

  def calculate_total_premium_for_period(start_date, end_date)
    health_premium = HealthInsurance.where(product_through_dr: true, created_at: start_date..end_date).sum(:total_premium) || 0
    life_premium = LifeInsurance.where(product_through_dr: true, created_at: start_date..end_date).sum(:total_premium) || 0
    motor_premium = MotorInsurance.where(product_through_dr: true, created_at: start_date..end_date).sum(:total_premium) || 0
    health_premium + life_premium + motor_premium
  end

  def calculate_growth_for_period(model, current_start, current_end, previous_start, previous_end)
    current_count = model.where(created_at: current_start..current_end).count
    previous_count = model.where(created_at: previous_start..previous_end).count

    return 0 if previous_count == 0
    ((current_count.to_f - previous_count.to_f) / previous_count.to_f * 100).round(1)
  end

  def calculate_policy_growth_for_period(current_start, current_end, previous_start, previous_end)
    current_policies = calculate_total_policies_for_period(current_start, current_end)
    previous_policies = calculate_total_policies_for_period(previous_start, previous_end)

    return 0 if previous_policies == 0
    ((current_policies.to_f - previous_policies.to_f) / previous_policies.to_f * 100).round(1)
  end

  def calculate_premium_growth_for_period(current_start, current_end, previous_start, previous_end)
    current_premium = calculate_total_premium_for_period(current_start, current_end)
    previous_premium = calculate_total_premium_for_period(previous_start, previous_end)

    return 0 if previous_premium == 0
    ((current_premium.to_f - previous_premium.to_f) / previous_premium.to_f * 100).round(1)
  end

  def calculate_monthly_trends_for_period(start_date, end_date)
    trends = {}
    current_date = start_date.beginning_of_month

    while current_date <= end_date
      month_end = [current_date.end_of_month, end_date].min
      month_name = current_date.strftime('%b %Y')

      trends[month_name] = {
        customers: Customer.where(created_at: current_date..month_end).count,
        policies: calculate_policies_for_month_in_period(current_date, month_end),
        premium: calculate_premium_for_month_in_period(current_date, month_end),
        leads: Lead.where(created_at: current_date..month_end).count
      }

      current_date = current_date.next_month.beginning_of_month
    end

    trends
  end

  def calculate_policies_for_month_in_period(month_start, month_end)
    HealthInsurance.where(product_through_dr: true, created_at: month_start..month_end).count +
    LifeInsurance.where(product_through_dr: true, created_at: month_start..month_end).count +
    MotorInsurance.where(product_through_dr: true, created_at: month_start..month_end).count +
    OtherInsurance.where(product_through_dr: true, created_at: month_start..month_end).count
  end

  def calculate_premium_for_month_in_period(month_start, month_end)
    HealthInsurance.where(product_through_dr: true, created_at: month_start..month_end).sum(:total_premium) +
    LifeInsurance.where(product_through_dr: true, created_at: month_start..month_end).sum(:total_premium) +
    MotorInsurance.where(product_through_dr: true, created_at: month_start..month_end).sum(:total_premium)
  end

  def calculate_top_affiliates_for_period(start_date, end_date)
    # Optimized query to avoid N+1 - calculate all at once using SQL
    affiliate_data = SubAgent.joins(
      "LEFT JOIN health_insurances hi ON hi.sub_agent_id = sub_agents.id AND hi.created_at BETWEEN '#{start_date}' AND '#{end_date}'" +
      " LEFT JOIN life_insurances li ON li.sub_agent_id = sub_agents.id AND li.created_at BETWEEN '#{start_date}' AND '#{end_date}'" +
      " LEFT JOIN motor_insurances mi ON mi.sub_agent_id = sub_agents.id AND mi.created_at BETWEEN '#{start_date}' AND '#{end_date}'"
    )
    .select("sub_agents.id, sub_agents.first_name, sub_agents.last_name, sub_agents.status,
             (COALESCE(COUNT(DISTINCT hi.id), 0) + COALESCE(COUNT(DISTINCT li.id), 0) + COALESCE(COUNT(DISTINCT mi.id), 0)) as policies_count")
    .group("sub_agents.id, sub_agents.first_name, sub_agents.last_name, sub_agents.status")
    .having("(COALESCE(COUNT(DISTINCT hi.id), 0) + COALESCE(COUNT(DISTINCT li.id), 0) + COALESCE(COUNT(DISTINCT mi.id), 0)) > 0")
    .order("policies_count DESC")
    .limit(10)

    affiliate_data.map { |agent| OpenStruct.new(
      id: agent.id,
      first_name: agent.first_name,
      last_name: agent.last_name,
      status: agent.status || 'active',
      policies_count: agent.policies_count
    )}
  rescue => e
    Rails.logger.error "Error calculating top affiliates for period: #{e.message}"
    []
  end

  def get_recent_policies_for_period(start_date, end_date)
    policies = []

    # Get recent health insurance policies for the period
    HealthInsurance.includes(:customer).where(created_at: start_date..end_date).order(created_at: :desc).limit(3).each do |policy|
      policies << {
        type: 'Health Insurance',
        customer: policy.customer.display_name,
        policy_number: policy.policy_number,
        premium: policy.total_premium,
        date: policy.created_at
      }
    end

    # Get recent life insurance policies for the period
    LifeInsurance.includes(:customer).where(created_at: start_date..end_date).order(created_at: :desc).limit(3).each do |policy|
      policies << {
        type: 'Life Insurance',
        customer: policy.customer.display_name,
        policy_number: policy.policy_number,
        premium: policy.total_premium,
        date: policy.created_at
      }
    end

    # Get recent motor insurance policies for the period
    MotorInsurance.includes(:customer).where(created_at: start_date..end_date).order(created_at: :desc).limit(2).each do |policy|
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

  def calculate_commission_summary_for_period(start_date, end_date)
    {
      total_commission_due: CommissionPayout.where(status: 'pending', created_at: start_date..end_date).sum(:payout_amount),
      total_commission_paid: CommissionPayout.where(status: 'paid', created_at: start_date..end_date).sum(:payout_amount),
      affiliate_commissions: CommissionPayout.where(payout_to: 'sub_agent', status: 'pending', created_at: start_date..end_date).sum(:payout_amount),
      ambassador_commissions: CommissionPayout.where(payout_to: 'ambassador', status: 'pending', created_at: start_date..end_date).sum(:payout_amount)
    }
  end

  def calculate_renewal_analytics_for_period(start_date, end_date)
    end_plus_30 = end_date + 30.days
    end_plus_60 = end_date + 60.days

    {
      expiring_soon: calculate_expiring_policies_for_period(start_date, end_date, end_date, end_plus_30),
      expiring_later: calculate_expiring_policies_for_period(start_date, end_date, end_plus_30, end_plus_60),
      expired: calculate_expired_policies_for_period(start_date, end_date),
      renewal_rate: calculate_renewal_rate_for_period(start_date, end_date)
    }
  end

  def calculate_expiring_policies_for_period(created_start, created_end, expiry_start, expiry_end)
    HealthInsurance.where(created_at: created_start..created_end, policy_end_date: expiry_start..expiry_end).count +
    LifeInsurance.where(created_at: created_start..created_end, policy_end_date: expiry_start..expiry_end).count +
    MotorInsurance.where(created_at: created_start..created_end, policy_end_date: expiry_start..expiry_end).count +
    OtherInsurance.where(created_at: created_start..created_end, policy_end_date: expiry_start..expiry_end).count
  end

  def calculate_expired_policies_for_period(start_date, end_date)
    HealthInsurance.where(created_at: start_date..end_date).where('policy_end_date < ?', Date.current).count +
    LifeInsurance.where(created_at: start_date..end_date).where('policy_end_date < ?', Date.current).count +
    MotorInsurance.where(created_at: start_date..end_date).where('policy_end_date < ?', Date.current).count +
    OtherInsurance.where(created_at: start_date..end_date).where('policy_end_date < ?', Date.current).count
  end

  def calculate_renewal_rate_for_period(start_date, end_date)
    # Calculate renewal rate for policies created in the period
    total_eligible = LifeInsurance.where(created_at: start_date..end_date).where('policy_end_date < ?', Date.current).count +
                     HealthInsurance.where(created_at: start_date..end_date).where('policy_end_date < ?', Date.current).count
    renewed = LifeInsurance.where(created_at: start_date..end_date, policy_type: 'Renewal').count +
              HealthInsurance.where(created_at: start_date..end_date, policy_type: 'Renewal').count

    return 0 if total_eligible == 0
    ((renewed.to_f / total_eligible.to_f) * 100).round(1)
  end

  def calculate_lead_conversion_funnel_for_period(start_date, end_date)
    {
      'Leads Generated' => Lead.where(created_at: start_date..end_date).count,
      'Contacted' => Lead.where(created_at: start_date..end_date, current_stage: ['contacted', 'interested', 'quoted', 'policy_created']).count,
      'Interested' => Lead.where(created_at: start_date..end_date, current_stage: ['interested', 'quoted', 'policy_created']).count,
      'Quoted' => Lead.where(created_at: start_date..end_date, current_stage: ['quoted', 'policy_created']).count,
      'Converted' => Lead.where(created_at: start_date..end_date, current_stage: 'policy_created').count
    }
  rescue => e
    Rails.logger.error "Error calculating lead conversion funnel for period: #{e.message}"
    {
      'Leads Generated' => 0,
      'Contacted' => 0,
      'Interested' => 0,
      'Quoted' => 0,
      'Converted' => 0
    }
  end

  def calculate_lead_stage_distribution_for_period(start_date, end_date)
    {
      'New Leads' => Lead.where(created_at: start_date..end_date, current_stage: 'lead_generated').count,
      'Contacted' => Lead.where(created_at: start_date..end_date, current_stage: ['follow_up', 'follow_up_successful']).count,
      'Consultation' => Lead.where(created_at: start_date..end_date, current_stage: 'consultation_scheduled').count,
      'One-on-One' => Lead.where(created_at: start_date..end_date, current_stage: 'one_on_one').count,
      'Converted' => Lead.where(created_at: start_date..end_date, current_stage: 'converted').count
    }
  rescue => e
    Rails.logger.error "Error calculating lead stage distribution for period: #{e.message}"
    {
      'New Leads' => 0,
      'Contacted' => 0,
      'Consultation' => 0,
      'One-on-One' => 0,
      'Converted' => 0
    }
  end

  def calculate_customer_location_for_period(start_date, end_date)
    location_data = {}

    # Group customers by city for the period
    Customer.where(created_at: start_date..end_date).group(:city).count.each do |city, count|
      next if city.blank?
      location_data[city.to_s.titleize] = count
    end

    # If no city data, try state
    if location_data.empty?
      Customer.where(created_at: start_date..end_date).group(:state).count.each do |state, count|
        next if state.blank?
        location_data[state.to_s.titleize] = count
      end
    end

    # If still no data, provide a default
    if location_data.empty?
      location_data = { 'Unknown' => Customer.where(created_at: start_date..end_date).count }
    end

    location_data
  rescue => e
    Rails.logger.error "Error calculating customer location for period: #{e.message}"
    { 'Unknown' => Customer.where(created_at: start_date..end_date).count }
  end

  def calculate_conversion_rate_for_period(start_date, end_date)
    total_leads = Lead.where(created_at: start_date..end_date).count
    total_policies = @total_policies || 0

    return 0 if total_leads == 0
    ((total_policies.to_f / total_leads.to_f) * 100).round(1)
  rescue => e
    Rails.logger.error "Error calculating conversion rate for period: #{e.message}"
    0
  end

  def get_chart_data(chart_name)
    case chart_name
    when 'policyDistribution'
      {
        labels: @policy_distribution.keys,
        data: @policy_distribution.values
      }
    when 'monthlyTrends'
      {
        labels: @monthly_trends.keys,
        datasets: [
          {
            label: 'Customers',
            data: @monthly_trends.values.map { |v| v[:customers] }
          },
          {
            label: 'Policies',
            data: @monthly_trends.values.map { |v| v[:policies] }
          }
        ]
      }
    when 'leadConversion'
      {
        labels: @lead_conversion_funnel.keys,
        data: @lead_conversion_funnel.values
      }
    when 'leadStage'
      {
        labels: @lead_stage_distribution.keys,
        data: @lead_stage_distribution.values
      }
    else
      { error: 'Chart not found' }
    end
  end

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
      'Life Insurance' => LifeInsurance.where(product_through_dr: true).count,
      'Health Insurance' => HealthInsurance.where(product_through_dr: true).count,
      'Motor Insurance' => MotorInsurance.where(product_through_dr: true).count,
      'Other Insurance' => OtherInsurance.where(product_through_dr: true).count
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

    # Premium Revenue Trend (last 12 months)
    @premium_revenue_trend = calculate_premium_revenue_trend

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
      premium_revenue_trend: @premium_revenue_trend,
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
    @premium_revenue_trend = cached_data['premium_revenue_trend']
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
    HealthInsurance.where(product_through_dr: true).count + LifeInsurance.where(product_through_dr: true).count + MotorInsurance.where(product_through_dr: true).count + OtherInsurance.where(product_through_dr: true).count
  end

  def calculate_total_premium_collected
    health_premium = HealthInsurance.where(product_through_dr: true).sum(:total_premium) || 0
    life_premium = LifeInsurance.where(product_through_dr: true).sum(:total_premium) || 0
    motor_premium = MotorInsurance.where(product_through_dr: true).sum(:total_premium) || 0
    health_premium + life_premium + motor_premium
  end

  def calculate_growth_percentage(model, period_start)
    current_count = model.where('created_at >= ?', period_start).count
    previous_count = model.where(created_at: (period_start - 1.month)..(period_start - 1.day)).count

    return 0 if previous_count == 0
    ((current_count.to_f - previous_count.to_f) / previous_count.to_f * 100).round(1)
  end

  def calculate_premium_growth
    current_premium = HealthInsurance.where(product_through_dr: true, created_at: @current_month..).sum(:total_premium) +
                      LifeInsurance.where(product_through_dr: true, created_at: @current_month..).sum(:total_premium) +
                      MotorInsurance.where(product_through_dr: true, created_at: @current_month..).sum(:total_premium)

    previous_premium = HealthInsurance.where(product_through_dr: true, created_at: @last_month..(@current_month - 1.day)).sum(:total_premium) +
                       LifeInsurance.where(product_through_dr: true, created_at: @last_month..(@current_month - 1.day)).sum(:total_premium) +
                       MotorInsurance.where(product_through_dr: true, created_at: @last_month..(@current_month - 1.day)).sum(:total_premium)

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
    HealthInsurance.where(product_through_dr: true, created_at: month_date..(month_date.end_of_month)).count +
    LifeInsurance.where(product_through_dr: true, created_at: month_date..(month_date.end_of_month)).count +
    MotorInsurance.where(product_through_dr: true, created_at: month_date..(month_date.end_of_month)).count +
    OtherInsurance.where(product_through_dr: true, created_at: month_date..(month_date.end_of_month)).count
  end

  def calculate_premium_for_month(month_date)
    HealthInsurance.where(product_through_dr: true, created_at: month_date..(month_date.end_of_month)).sum(:total_premium) +
    LifeInsurance.where(product_through_dr: true, created_at: month_date..(month_date.end_of_month)).sum(:total_premium) +
    MotorInsurance.where(product_through_dr: true, created_at: month_date..(month_date.end_of_month)).sum(:total_premium)
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

  def calculate_premium_revenue_trend
    # Calculate premium revenue trend for last 12 months
    trend_data = {}

    12.times do |i|
      month_date = (Date.current - i.months).beginning_of_month
      month_name = month_date.strftime('%b %Y')

      # Calculate total premium for the month across all insurance types
      health_premium = HealthInsurance.where(created_at: month_date..(month_date.end_of_month)).sum(:total_premium)
      life_premium = LifeInsurance.where(created_at: month_date..(month_date.end_of_month)).sum(:total_premium)
      motor_premium = MotorInsurance.where(created_at: month_date..(month_date.end_of_month)).sum(:total_premium)

      total_premium = health_premium + life_premium + motor_premium
      trend_data[month_name] = total_premium.round(0)
    end

    # Return in chronological order (oldest to newest)
    trend_data.to_a.reverse.to_h
  rescue => e
    Rails.logger.error "Error calculating premium revenue trend: #{e.message}"
    {}
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