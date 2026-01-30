class DashboardController < ApplicationController
  skip_load_and_authorize_resource
  before_action :redirect_ambassador_users

  def index
    authorize! :read, :dashboard
    load_dashboard_data
  end

  def beautiful
    authorize! :read, :dashboard
    load_dashboard_data
    render 'beautiful_dashboard', layout: false
  end

  def ultra
    authorize! :read, :dashboard
    load_dashboard_data
    render 'ultra_attractive_dashboard', layout: false
  end

  def stats
    authorize! :read, :dashboard

    # Use instant stats for API endpoints
    stats_data = DashboardTieredCacheService.fetch_stats(mode: :instant)

    render json: stats_data.merge({
      # API metadata
      cached: true,
      cache_type: stats_data[:cached_from] || 'tiered_cache',
      cache_age: stats_data[:cache_age_seconds] || 0,
      generated_at: Time.current.iso8601
    })
  rescue => e
    Rails.logger.error "Stats API failed: #{e.message}"
    render json: { error: 'Stats temporarily unavailable' }, status: 503
  end

  # Manual cache refresh endpoint
  def refresh_cache
    authorize! :read, :dashboard

    # Clear all cache tiers
    Rails.cache.clear
    Thread.current[:dashboard_tier_cache] = nil

    # Refresh materialized view
    DashboardInstantService.refresh_materialized_view!

    # Warm up cache in background
    DashboardCacheWarmerJob.perform_later

    load_dashboard_data

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Dashboard cache refreshed!' }
      format.json { render json: { success: true, message: 'Cache refreshed' } }
    end
  end

  # Performance monitoring endpoint
  def performance
    authorize! :read, :dashboard

    report = DashboardPerformanceMonitor.performance_report

    render json: {
      performance: report,
      health_check: DashboardPerformanceMonitor.health_check,
      timestamp: Time.current.iso8601
    }
  end

  # Health check endpoint for monitoring
  def health
    health_status = DashboardPerformanceMonitor.health_check

    status_code = health_status[:overall_status] == :healthy ? 200 : 503

    render json: health_status, status: status_code
  end

  private

  def redirect_ambassador_users
    if current_user&.ambassador?
      redirect_to ambassador_dashboard_path
    end
  end

  def load_dashboard_data
    start_time = Time.current

    # Use ultra-fast tiered caching
    cached_data = DashboardTieredCacheService.fetch_stats(mode: :auto)

    # Track performance
    DashboardPerformanceMonitor.track_dashboard_load(
      start_time: start_time,
      end_time: Time.current,
      cache_hit: cached_data[:cached_from].present?,
      data_source: cached_data[:cached_from] || 'unknown'
    )

    # Set instance variables from cached data
    cached_data.each { |key, value| instance_variable_set("@#{key}", value) }
  rescue => e
    Rails.logger.error "Dashboard data loading failed: #{e.message}"
    # Fallback to basic counts if ultra-fast service fails
    @total_customers = Customer.count
    @total_policies = 0
  end

  private

  def redirect_ambassador_users
    if current_user&.ambassador?
      redirect_to ambassador_dashboard_path
    end
  end

  # Optimized helper methods to avoid N+1 queries

  def get_all_dashboard_data
    # Execute all database queries in parallel/batch to minimize load time
    # Use pluck and select to reduce memory usage

    # Use database connection pool for parallel queries
    results = {}

    # Batch count queries using single SQL with UNION for better performance
    count_results = ActiveRecord::Base.connection.execute("
      SELECT 'total_customers' as metric, COUNT(*) as count FROM customers
      UNION ALL
      SELECT 'active_customers', COUNT(*) FROM customers WHERE status = true
      UNION ALL
      SELECT 'total_ambassadors', COUNT(*) FROM distributors
      UNION ALL
      SELECT 'total_leads', COUNT(*) FROM leads
      UNION ALL
      SELECT 'converted_leads', COUNT(*) FROM leads WHERE current_stage = 'converted'
      UNION ALL
      SELECT 'health_count', COUNT(*) FROM health_insurances
      UNION ALL
      SELECT 'life_count', COUNT(*) FROM life_insurances
    ")

    # Process count results
    count_results.each do |row|
      results[row['metric'].to_sym] = row['count']
    end

    # Handle optional tables that might not exist
    results[:motor_count] = (MotorInsurance.count rescue 0)
    results[:other_count] = (OtherInsurance.count rescue 0)

    # Calculate active affiliates (only those with policies)
    results[:total_affiliates] = calculate_active_affiliates_with_policies

    # Calculate derived values
    results[:inactive_customers] = results[:total_customers] - results[:active_customers]
    results[:total_policies] = results[:health_count] + results[:life_count] + results[:motor_count] + results[:other_count]
    results[:lead_conversion_percentage] = results[:total_leads] > 0 ? ((results[:converted_leads].to_f / results[:total_leads]) * 100).round(2) : 0

    # Premium data - single query with UNION for better performance
    premium_results = ActiveRecord::Base.connection.execute("
      SELECT
        COALESCE(SUM(total_premium), 0) as total_premium,
        COALESCE(SUM(sum_insured), 0) as total_sum_insured
      FROM (
        SELECT total_premium, sum_insured FROM health_insurances
        UNION ALL
        SELECT total_premium, sum_insured FROM life_insurances
      ) as combined_insurance
    ").first

    results[:total_premium_collected] = (premium_results['total_premium'] || 0).to_f
    results[:total_sum_insured] = (premium_results['total_sum_insured'] || 0).to_f

    # Add motor insurance if table exists
    begin
      motor_data = MotorInsurance.select('COALESCE(SUM(total_premium), 0) as premium, COALESCE(SUM(sum_insured), 0) as sum').first
      results[:total_premium_collected] += motor_data.premium.to_f
      results[:total_sum_insured] += motor_data.sum.to_f
    rescue
      # Motor insurance table doesn't exist
    end

    # Pending leads count (single query with OR conditions)
    pending_stages = ['lead_generated', 'follow_up', 'follow_up_successful', 'consultation_scheduled', 'one_on_one']
    results[:pending_leads] = Lead.where(current_stage: pending_stages).count

    # Renewals and expired policies (date-based queries)
    thirty_days_from_now = Date.current + 30.days
    results[:renewal_due_count] = get_renewal_due_count(thirty_days_from_now)
    results[:expired_policies_count] = get_expired_policies_count
    results[:renewal_status] = get_renewal_status_counts

    # Payout data
    payout_data = get_optimized_payout_data
    results.merge!(
      pending_payouts: payout_data[:pending_amount],
      paid_payouts: payout_data[:paid_amount],
      total_payouts: payout_data[:total_amount]
    )

    # Calculate growth metrics
    growth_metrics = calculate_growth_metrics_data(results)
    results.merge!(growth_metrics)

    # Add recent activities data
    results[:recent_policies] = get_recent_policies
    results[:recent_leads] = get_recent_leads

    results
  end

  def get_optimized_policy_counts
    # Legacy method for backward compatibility
    {
      health_count: HealthInsurance.count,
      life_count: LifeInsurance.count,
      motor_count: (MotorInsurance.count rescue 0),
      other_count: (OtherInsurance.count rescue 0),
      total_count: HealthInsurance.count + LifeInsurance.count + (MotorInsurance.count rescue 0) + (OtherInsurance.count rescue 0)
    }
  end

  def get_optimized_premium_data
    # Simpler direct sum queries
    health_premium = HealthInsurance.sum(:total_premium) || 0
    life_premium = LifeInsurance.sum(:total_premium) || 0
    motor_premium = begin
      MotorInsurance.sum(:total_premium) || 0
    rescue
      0
    end

    health_sum = HealthInsurance.sum(:sum_insured) || 0
    life_sum = LifeInsurance.sum(:sum_insured) || 0
    motor_sum = begin
      MotorInsurance.sum(:sum_insured) || 0
    rescue
      0
    end

    {
      total_premium: health_premium + life_premium + motor_premium,
      total_sum_insured: health_sum + life_sum + motor_sum
    }
  end

  def get_renewal_due_count(thirty_days_from_now)
    # Use single UNION query for better performance
    sql = "
      SELECT COUNT(*) as count FROM (
        SELECT id FROM health_insurances WHERE policy_end_date BETWEEN ? AND ?
        UNION ALL
        SELECT id FROM life_insurances WHERE policy_end_date BETWEEN ? AND ?
      ) as renewals
    "

    result = ActiveRecord::Base.connection.exec_query(
      sql,
      'SQL',
      [[nil, Date.current], [nil, thirty_days_from_now], [nil, Date.current], [nil, thirty_days_from_now]]
    )

    count = result.first['count'].to_i

    # Add motor and other insurances if they exist
    begin
      if ActiveRecord::Base.connection.table_exists?('motor_insurances')
        count += MotorInsurance.where('policy_end_date BETWEEN ? AND ?', Date.current, thirty_days_from_now).count
      end
    rescue
    end

    begin
      if ActiveRecord::Base.connection.table_exists?('other_insurances')
        count += OtherInsurance.where('policy_end_date BETWEEN ? AND ?', Date.current, thirty_days_from_now).count
      end
    rescue
    end

    count
  end

  def get_expired_policies_count
    # Use single UNION query for better performance
    sql = "
      SELECT COUNT(*) as count FROM (
        SELECT id FROM health_insurances WHERE policy_end_date < ?
        UNION ALL
        SELECT id FROM life_insurances WHERE policy_end_date < ?
      ) as expired
    "

    result = ActiveRecord::Base.connection.exec_query(
      sql,
      'SQL',
      [[nil, Date.current], [nil, Date.current]]
    )

    count = result.first['count'].to_i

    # Add motor and other insurances if they exist
    begin
      if ActiveRecord::Base.connection.table_exists?('motor_insurances')
        count += MotorInsurance.where('policy_end_date < ?', Date.current).count
      end
    rescue
    end

    begin
      if ActiveRecord::Base.connection.table_exists?('other_insurances')
        count += OtherInsurance.where('policy_end_date < ?', Date.current).count
      end
    rescue
    end

    count
  end

  def get_optimized_payout_data
    # Use single query to get all payout data at once
    commission_data = CommissionPayout
      .group(:status)
      .sum(:payout_amount)

    commission_pending = commission_data['pending'] || 0
    commission_paid = commission_data['paid'] || 0
    commission_total = CommissionPayout.sum(:payout_amount) || 0

    distributor_pending = 0
    distributor_paid = 0
    distributor_total = 0

    # Check if distributor payouts exist
    begin
      if ActiveRecord::Base.connection.table_exists?('distributor_payouts')
        distributor_data = DistributorPayout
          .group(:status)
          .sum(:payout_amount)

        distributor_pending = distributor_data['pending'] || 0
        distributor_paid = distributor_data['paid'] || 0
        distributor_total = DistributorPayout.sum(:payout_amount) || 0
      end
    rescue
    end

    {
      pending_amount: commission_pending + distributor_pending,
      paid_amount: commission_paid + distributor_paid,
      total_amount: commission_total + distributor_total
    }
  end

  def calculate_growth_metrics_data(results)
    # Get data for current month and last month
    current_month_start = Date.current.beginning_of_month
    last_month_start = 1.month.ago.beginning_of_month
    last_month_end = 1.month.ago.end_of_month

    # Current month data
    current_customers = Customer.where('created_at >= ?', current_month_start).count
    current_policies = get_policies_count_for_period(current_month_start, Date.current)
    current_premium = get_premium_for_period(current_month_start, Date.current)
    current_affiliates = SubAgent.where('created_at >= ?', current_month_start).count
    current_ambassadors = Distributor.where('created_at >= ?', current_month_start).count
    current_leads = Lead.where('created_at >= ?', current_month_start).count
    current_renewals = get_renewals_count_for_period(current_month_start, Date.current)
    current_payouts = get_payouts_for_period(current_month_start, Date.current)
    current_sum_insured = get_sum_insured_for_period(current_month_start, Date.current)

    # Last month data
    last_customers = Customer.where(created_at: last_month_start..last_month_end).count
    last_policies = get_policies_count_for_period(last_month_start, last_month_end)
    last_premium = get_premium_for_period(last_month_start, last_month_end)
    last_affiliates = SubAgent.where(created_at: last_month_start..last_month_end).count
    last_ambassadors = Distributor.where(created_at: last_month_start..last_month_end).count
    last_leads = Lead.where(created_at: last_month_start..last_month_end).count
    last_renewals = get_renewals_count_for_period(last_month_start, last_month_end)
    last_payouts = get_payouts_for_period(last_month_start, last_month_end)
    last_sum_insured = get_sum_insured_for_period(last_month_start, last_month_end)

    # Calculate growth percentages
    customer_growth = calculate_percentage_change(current_customers, last_customers)
    policy_growth = calculate_percentage_change(current_policies, last_policies)
    premium_growth = calculate_percentage_change(current_premium, last_premium)
    affiliate_growth = calculate_percentage_change(current_affiliates, last_affiliates)
    ambassador_growth = calculate_percentage_change(current_ambassadors, last_ambassadors)
    lead_growth = calculate_percentage_change(current_leads, last_leads)
    renewal_growth = calculate_percentage_change(current_renewals, last_renewals)
    payout_growth = calculate_percentage_change(current_payouts, last_payouts)
    sum_insured_growth = calculate_percentage_change(current_sum_insured, last_sum_insured)

    # Additional metrics
    conversion_rate = results[:total_leads] > 0 ? ((results[:converted_leads].to_f / results[:total_leads]) * 100).round(1) : 0
    avg_policy_value = results[:total_policies] > 0 ? (results[:total_premium_collected] / results[:total_policies]).round(0) : 0
    customer_retention = calculate_customer_retention_rate
    monthly_recurring_revenue = (results[:total_premium_collected] / 12.0).round(0)
    commissions_due = results[:pending_payouts] || 0

    {
      customer_growth: customer_growth,
      policy_growth: policy_growth,
      premium_growth: premium_growth,
      affiliate_growth: affiliate_growth,
      ambassador_growth: ambassador_growth,
      lead_growth: lead_growth,
      renewal_growth: renewal_growth,
      payout_growth: payout_growth,
      sum_insured_growth: sum_insured_growth,
      conversion_rate: conversion_rate,
      avg_policy_value: avg_policy_value,
      customer_retention: customer_retention,
      monthly_recurring_revenue: monthly_recurring_revenue,
      commissions_due: commissions_due
    }
  end

  private

  def get_policies_count_for_period(start_date, end_date)
    health = HealthInsurance.where(created_at: start_date..end_date).count
    life = LifeInsurance.where(created_at: start_date..end_date).count
    motor = (MotorInsurance.where(created_at: start_date..end_date).count rescue 0)
    other = (OtherInsurance.where(created_at: start_date..end_date).count rescue 0)
    health + life + motor + other
  end

  def get_premium_for_period(start_date, end_date)
    health = HealthInsurance.where(created_at: start_date..end_date).sum(:total_premium) || 0
    life = LifeInsurance.where(created_at: start_date..end_date).sum(:total_premium) || 0
    motor = (MotorInsurance.where(created_at: start_date..end_date).sum(:total_premium) rescue 0)
    health + life + motor
  end

  def get_renewals_count_for_period(start_date, end_date)
    thirty_days_ahead = end_date + 30.days
    health = HealthInsurance.where(created_at: start_date..end_date)
                           .where('policy_end_date BETWEEN ? AND ?', end_date, thirty_days_ahead).count
    life = LifeInsurance.where(created_at: start_date..end_date)
                        .where('policy_end_date BETWEEN ? AND ?', end_date, thirty_days_ahead).count
    motor = (MotorInsurance.where(created_at: start_date..end_date)
                          .where('policy_end_date BETWEEN ? AND ?', end_date, thirty_days_ahead).count rescue 0)
    health + life + motor
  end

  def get_payouts_for_period(start_date, end_date)
    commission = CommissionPayout.where(created_at: start_date..end_date, status: 'pending').sum(:payout_amount) || 0
    distributor = (DistributorPayout.where(created_at: start_date..end_date, status: 'pending').sum(:payout_amount) rescue 0)
    commission + distributor
  end

  def get_sum_insured_for_period(start_date, end_date)
    health = HealthInsurance.where(created_at: start_date..end_date).sum(:sum_insured) || 0
    life = LifeInsurance.where(created_at: start_date..end_date).sum(:sum_insured) || 0
    motor = (MotorInsurance.where(created_at: start_date..end_date).sum(:sum_insured) rescue 0)
    health + life + motor
  end

  def calculate_percentage_change(current_value, previous_value)
    return 0 if previous_value == 0
    return 100 if previous_value == 0 && current_value > 0
    ((current_value.to_f - previous_value.to_f) / previous_value.to_f * 100).round(1)
  end

  def calculate_customer_retention_rate
    # Calculate retention rate for customers who joined 2+ months ago
    two_months_ago = 2.months.ago.beginning_of_month
    old_customers = Customer.where('created_at < ?', two_months_ago).count
    active_old_customers = Customer.where('created_at < ?', two_months_ago).where(status: true).count

    old_customers > 0 ? ((active_old_customers.to_f / old_customers.to_f) * 100).round(1) : 0
  end

  def get_renewal_status_counts
    # Get renewal counts for current month
    current_month_start = Date.current.beginning_of_month

    # Count renewed policies this month (policies with policy_type = 'Renewal')
    renewed_count = 0

    begin
      renewed_count += HealthInsurance.where('created_at >= ?', current_month_start)
                                     .where(policy_type: 'Renewal').count
      renewed_count += LifeInsurance.where('created_at >= ?', current_month_start)
                                   .where(policy_type: 'Renewal').count
      renewed_count += (MotorInsurance.where('created_at >= ?', current_month_start)
                                     .where(policy_type: 'Renewal').count rescue 0)
    rescue => e
      Rails.logger.error "Error calculating renewal status: #{e.message}"
      renewed_count = 0
    end

    {
      'Renewed' => renewed_count,
      'Pending' => get_renewal_due_count(Date.current + 30.days),
      'Expired' => get_expired_policies_count
    }
  end

  def get_recent_policies
    # Use single query with UNION to get all recent policies at once
    # This avoids N+1 queries and multiple database round trips
    sql = "
      SELECT * FROM (
        SELECT
          'Health Insurance' as policy_type,
          h.policy_number,
          h.total_premium,
          h.created_at,
          c.display_name as customer_name
        FROM health_insurances h
        LEFT JOIN customers c ON h.customer_id = c.id
        ORDER BY h.created_at DESC
        LIMIT 5
      ) AS health
      UNION ALL
      SELECT * FROM (
        SELECT
          'Life Insurance' as policy_type,
          l.policy_number,
          l.total_premium,
          l.created_at,
          c.display_name as customer_name
        FROM life_insurances l
        LEFT JOIN customers c ON l.customer_id = c.id
        ORDER BY l.created_at DESC
        LIMIT 5
      ) AS life
    "

    # Add motor insurance if it exists
    begin
      if ActiveRecord::Base.connection.table_exists?('motor_insurances')
        sql += "
          UNION ALL
          SELECT * FROM (
            SELECT
              'Motor Insurance' as policy_type,
              m.policy_number,
              m.total_premium,
              m.created_at,
              c.display_name as customer_name
            FROM motor_insurances m
            LEFT JOIN customers c ON m.customer_id = c.id
            ORDER BY m.created_at DESC
            LIMIT 5
          ) AS motor
        "
      end
    rescue
      # Motor insurance table doesn't exist
    end

    sql += " ORDER BY created_at DESC LIMIT 10"

    results = ActiveRecord::Base.connection.execute(sql)
    results.map do |row|
      {
        type: row['policy_type'],
        customer: row['customer_name'] || 'Unknown',
        policy_number: row['policy_number'],
        premium: row['total_premium'].to_f,
        date: row['created_at']
      }
    end
  rescue => e
    Rails.logger.error "Error fetching recent policies: #{e.message}"
    []
  end

  def get_recent_leads
    # Use select to only fetch needed columns, reducing memory usage
    Lead.select(:id, :lead_id, :name, :current_stage, :created_at)
        .order(created_at: :desc)
        .limit(10)
  rescue => e
    Rails.logger.error "Error fetching recent leads: #{e.message}"
    []
  end

  def calculate_active_affiliates_with_policies
    # Count affiliates who have at least one policy
    active_count = 0

    SubAgent.find_each do |affiliate|
      policies_count = 0
      policies_count += HealthInsurance.where(sub_agent_id: affiliate.id).count rescue 0
      policies_count += LifeInsurance.where(sub_agent_id: affiliate.id).count rescue 0
      policies_count += MotorInsurance.where(sub_agent_id: affiliate.id).count rescue 0

      active_count += 1 if policies_count > 0
    end

    active_count
  rescue => e
    Rails.logger.error "Error calculating active affiliates: #{e.message}"
    0
  end

end
