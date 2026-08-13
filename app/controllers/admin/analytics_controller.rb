require 'ostruct'

class Admin::AnalyticsController < Admin::ApplicationController
  def index
    setup_filter_dates
    # Always use filtered queries so dashboard and analytics show matching data
    # for the same date range. setup_filter_dates defaults to the current year
    # when no params are present, which mirrors the dashboard's default behaviour.
    load_filtered_analytics_data

    # AJAX chart-data requests return JSON from the already-loaded instance vars
    if request.xhr? && params[:chart].present?
      render json: get_chart_data(params[:chart])
      return
    end
  end

  def refresh
    refresh_analytics_cache
    redirect_to admin_analytics_path, notice: 'Analytics data has been refreshed!'
  end

  def card_detail
    setup_filter_dates
    metric  = params[:metric].to_s
    records = fetch_analytics_card_records(metric)
    render json: { records: records, metric: metric, count: records.size }
  rescue => e
    render json: { error: e.message }, status: 422
  end

  private

  # DR-wise filter: admin-added policies only (source of truth matches list pages).
  DRWISE = { is_admin_added: true, is_customer_added: false, is_agent_added: false }.freeze

  def setup_filter_dates
    current_year = Date.current.year

    if params[:financial_year].present?
      fy = params[:financial_year].to_i.clamp(2000, 2100)
      @filter_financial_year = fy
      @filter_year  = fy
      @filter_month = nil
      @filter_start_date = Date.new(fy - 1, 4, 1)
      @filter_end_date   = Date.new(fy,     3, 31)
    else
      @filter_financial_year = nil
      @filter_year  = params[:year].present? ? params[:year].to_i.clamp(2000, 2100) : current_year
      @filter_month = params[:month].present? ? params[:month].to_i.clamp(1, 12) : nil
      @filter_start_date = if params[:start_date].present?
        date = Date.parse(params[:start_date]) rescue nil
        (date && date.year >= 2000 && date.year <= 2100) ? date : Date.new(@filter_year, 1, 1)
      else
        Date.new(@filter_year, 1, 1)
      end
      @filter_end_date = if params[:end_date].present?
        date = Date.parse(params[:end_date]) rescue nil
        (date && date.year >= 2000 && date.year <= 2100) ? date : Date.new(@filter_year, 12, 31)
      else
        Date.new(@filter_year, 12, 31)
      end

      if @filter_month.present?
        @filter_start_date = Date.new(@filter_year, @filter_month, 1)
        @filter_end_date   = @filter_start_date.end_of_month
      end
    end
  end

  def has_filter_params?
    params[:year].present? || params[:month].present? || params[:start_date].present? || params[:end_date].present?
  end

  def load_filtered_analytics_data
    Rails.logger.info "🔍 Loading filtered analytics data for period: #{@filter_start_date} to #{@filter_end_date}"

    # Reuses the dashboard's cache-gen key so both pages invalidate together
    # (bumped on health/life insurance writes — see DashboardOptimizable).
    cache_gen = Rails.cache.read("dashboard_cache_gen") || "0"
    cache_key = "analytics_filtered_data_#{cache_gen}_#{@filter_start_date}_#{@filter_end_date}_v2"

    filtered_data = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      get_filtered_analytics_data(@filter_start_date, @filter_end_date)
    end

    # Set instance variables from filtered data
    filtered_data.each { |key, value| instance_variable_set("@#{key}", value) }

    # @recent_leads is cached as plain attribute hashes (see get_filtered_analytics_data) —
    # wrap back into OpenStructs so the view can keep calling lead.method_name on it.
    @recent_leads = (@recent_leads || []).map { |attrs| OpenStruct.new(attrs) }

    # Investor/agent/retention figures are period-independent — cached under
    # their own key (shared across every date filter) instead of being part
    # of the per-period cache above.
    independent_cache_key = "analytics_period_independent_data_#{cache_gen}_v1"
    independent_data = Rails.cache.fetch(independent_cache_key, expires_in: 5.minutes) do
      get_period_independent_analytics_data
    end
    independent_data.each { |key, value| instance_variable_set("@#{key}", value) }
  end

  def get_filtered_analytics_data(start_date, end_date)
    # Time ranges
    @current_month = start_date.beginning_of_month
    @last_month = (start_date - 1.month).beginning_of_month
    @current_year = start_date.beginning_of_year
    @last_year = (start_date - 1.year).beginning_of_year

    # Core metrics for the filtered period
    # Policies/premium use policy_start_date; people/leads use created_at
    dt_start = start_date.beginning_of_day
    dt_end   = end_date.end_of_day
    @total_customers   = Customer.where(created_at: dt_start..dt_end).count
    @total_affiliates  = SubAgent.where(created_at: dt_start..dt_end).count
    @total_ambassadors = Distributor.where(created_at: dt_start..dt_end).count

    # Monthly trends within the filtered period (up to 12 months). Policy
    # distribution, total policies/premium, and the premium/acquisition trend
    # charts are all sums or reshapes of these same per-month figures, so
    # derive them here instead of re-querying the whole range again per metric
    # (was 4 duplicate group-by queries plus 8 more for the plain totals).
    trend_data = calculate_monthly_trends_for_period(start_date, end_date)
    @monthly_trends = trend_data[:trends]
    totals = trend_data[:totals]

    @policy_distribution = {
      'Life Insurance'   => totals[:life_count],
      'Health Insurance' => totals[:health_count],
      'Motor Insurance'  => totals[:motor_count],
      'Other Insurance'  => totals[:other_count]
    }
    @total_policies = totals[:health_count] + totals[:life_count] + totals[:motor_count] + totals[:other_count]
    @total_premium  = totals[:health_premium] + totals[:life_premium] + totals[:motor_premium] + totals[:other_premium]

    @premium_revenue_trend = @monthly_trends.transform_values { |v| v[:premium].round(0) }
    @customer_acquisition_trend = @monthly_trends.transform_values { |v| v[:customers] }

    # Growth metrics (compare with previous period of same duration)
    # Use .to_i to get integer days; avoid double .days conversion which overflows PostgreSQL
    days_in_period = (end_date - start_date).to_i
    previous_end   = start_date - 1.day
    previous_start = [start_date - days_in_period, Date.new(1900, 1, 1)].max

    customer_current, customer_previous   = growth_counts(Customer, start_date, end_date, previous_start, previous_end)
    affiliate_current, affiliate_previous = growth_counts(SubAgent, start_date, end_date, previous_start, previous_end)
    @customer_growth  = calculate_percentage_change(customer_current, customer_previous)
    @affiliate_growth = calculate_percentage_change(affiliate_current, affiliate_previous)

    previous_totals = previous_period_policy_premium_totals(previous_start, previous_end)
    @policy_growth  = calculate_percentage_change(@total_policies, previous_totals[:policies])
    @premium_growth = calculate_percentage_change(@total_premium, previous_totals[:premium])

    # Top performing affiliates for the period
    @top_affiliates = calculate_top_affiliates_for_period(start_date, end_date)

    # Recent activities for the period
    @recent_policies = get_recent_policies_for_period(start_date, end_date)
    @recent_leads = Lead.where(created_at: dt_start..dt_end).order(created_at: :desc).limit(10)

    # Batch-resolve each lead's customer sub_agent (by contact number) in one
    # query instead of the view calling Customer.find_by per row (was 10
    # queries for 10 recent leads).
    contact_numbers = @recent_leads.map(&:contact_number).compact.uniq
    @recent_leads_sub_agent_by_contact = Customer.where(mobile: contact_numbers).pluck(:mobile, :sub_agent).to_h

    # Commission analytics for the period
    @commission_summary = calculate_commission_summary_for_period(start_date, end_date)

    # Renewal analytics for the period
    @renewal_analytics = calculate_renewal_analytics_for_period(start_date, end_date)

    # Lead analytics for the period — funnel, stage distribution, new/converted
    # lead counts, and conversion rate are all derived from this single
    # grouped-by-stage query instead of 6 separate Lead counts.
    lead_stage_counts = (Lead.where(created_at: dt_start..dt_end).group(:current_stage).count rescue {})
    @lead_conversion_funnel  = build_lead_conversion_funnel(lead_stage_counts)
    @lead_stage_distribution = build_lead_stage_distribution(lead_stage_counts)
    @new_leads       = lead_stage_counts.values.sum
    @converted_leads = (lead_stage_counts['policy_created'] || 0) + (lead_stage_counts['converted'] || 0)
    converted_only    = lead_stage_counts['converted'] || 0
    @conversion_rate = @new_leads > 0 ? ((converted_only.to_f / @new_leads.to_f) * 100).round(1) : 0

    # Customer location analytics for the period
    @customer_location = calculate_customer_location_for_period(start_date, end_date, @total_customers)

    # Additional metrics
    @avg_policy_value = @total_policies > 0 ? (@total_premium / @total_policies).round(0) : 0
    @commissions_due = (@commission_summary[:total_commission_due] || 0).to_f

    # Top customers by premium for the filtered period
    @top_customers_by_premium = calculate_top_customers_by_premium_for_period(start_date, end_date)

    # Investor analytics, agent performance/commission/customer data, and
    # customer retention are all-time figures independent of the date filter —
    # loaded and cached separately (see get_period_independent_analytics_data)
    # so switching between date ranges doesn't recompute them every time.

    # Operational quick-insights for the filtered period
    # (@converted_leads and @new_leads were already derived above from lead_stage_counts)
    @active_customers = Customer.where(created_at: dt_start..dt_end).where(status: true).count rescue Customer.where(created_at: dt_start..dt_end).count
    @support_tickets  = calculate_support_tickets
    @docs_pending     = 0
    @claims_processing = 0
    @client_requests_count = 0
    @data_is_cached   = false

    # Full snapshot of everything computed above, so the caller can cache the
    # whole result instead of recomputing ~140 queries on every page load.
    # @recent_leads is an unloaded AR::Relation — materialize it to plain
    # attribute hashes so it round-trips through the cache safely.
    {
      current_month: @current_month, last_month: @last_month,
      current_year: @current_year, last_year: @last_year,
      total_customers: @total_customers, total_policies: @total_policies,
      total_premium: @total_premium, total_affiliates: @total_affiliates,
      total_ambassadors: @total_ambassadors,
      customer_growth: @customer_growth, policy_growth: @policy_growth,
      premium_growth: @premium_growth, affiliate_growth: @affiliate_growth,
      policy_distribution: @policy_distribution, monthly_trends: @monthly_trends,
      top_affiliates: @top_affiliates, recent_policies: @recent_policies,
      recent_leads: @recent_leads.to_a.map(&:attributes),
      recent_leads_sub_agent_by_contact: @recent_leads_sub_agent_by_contact,
      commission_summary: @commission_summary, renewal_analytics: @renewal_analytics,
      lead_conversion_funnel: @lead_conversion_funnel,
      lead_stage_distribution: @lead_stage_distribution,
      customer_location: @customer_location, conversion_rate: @conversion_rate,
      avg_policy_value: @avg_policy_value, commissions_due: @commissions_due,
      top_customers_by_premium: @top_customers_by_premium,
      premium_revenue_trend: @premium_revenue_trend,
      customer_acquisition_trend: @customer_acquisition_trend,
      active_customers: @active_customers, converted_leads: @converted_leads,
      new_leads: @new_leads, support_tickets: @support_tickets,
      docs_pending: @docs_pending, claims_processing: @claims_processing,
      client_requests_count: @client_requests_count,
      filter_start_date: start_date,
      filter_end_date: end_date,
      filter_year: start_date.year,
      filter_month: start_date.month == end_date.month ? start_date.month : nil
    }
  end

  # Investor analytics, agent performance/commission/customer data, and
  # customer retention don't depend on the date filter at all, so they're
  # loaded and cached independently from the per-period data — switching
  # between date ranges reuses this instead of recomputing ~15 queries.
  def get_period_independent_analytics_data
    {
      total_investors: (Investor.count rescue 0),
      investor_status_distribution: calculate_investor_status_distribution,
      top_investors_by_ambassadors: calculate_top_investors_by_ambassadors,
      top_investors_by_commission: calculate_top_investors_by_commission,
      agent_performance: calculate_agent_performance,
      agent_commission: calculate_agent_commission,
      agent_customer_data: calculate_agent_customer_data,
      customer_retention: calculate_customer_retention
    }
  end

  # Helper methods for filtered calculations

  # Single query per model returning both the current- and previous-period
  # counts via FILTER, instead of two separate .where(...).count calls.
  def growth_counts(model, current_start, current_end, previous_start, previous_end)
    sql = ActiveRecord::Base.sanitize_sql_array([
      "SELECT COUNT(*) FILTER (WHERE created_at >= :cs AND created_at <= :ce) AS current_count, " \
      "COUNT(*) FILTER (WHERE created_at >= :ps AND created_at <= :pe) AS previous_count " \
      "FROM #{model.quoted_table_name} WHERE created_at >= :ps AND created_at <= :ce",
      cs: current_start, ce: current_end, ps: previous_start, pe: previous_end
    ])
    row = ActiveRecord::Base.connection.select_one(sql)
    [row['current_count'].to_i, row['previous_count'].to_i]
  rescue => e
    Rails.logger.error "growth_counts error (#{model.name}): #{e.message}"
    [0, 0]
  end

  def calculate_percentage_change(current, previous)
    return 0 if previous.to_f == 0
    ((current.to_f - previous.to_f) / previous.to_f * 100).round(1)
  end

  # One query per model (count + sum together) for the previous-period
  # comparison, instead of 4 count queries + 4 sum queries.
  def previous_period_policy_premium_totals(previous_start, previous_end)
    range = previous_start..previous_end
    policies = 0
    premium  = 0.0
    [HealthInsurance, LifeInsurance, MotorInsurance, OtherInsurance].each do |klass|
      cnt, sum = klass.where(DRWISE).where(policy_start_date: range)
                      .pluck(Arel.sql('COUNT(*)'), Arel.sql('COALESCE(SUM(net_premium), 0)')).first
      policies += cnt.to_i
      premium  += sum.to_f
    rescue => e
      Rails.logger.error "previous_period_policy_premium_totals error (#{klass.name}): #{e.message}"
    end
    { policies: policies, premium: premium }
  end

  # Was issuing ~10 queries per month in the range (one COUNT/SUM call at a
  # time inside a while loop) — a full-year filter meant 120+ queries just for
  # this one chart. Batched to 8 fixed group-by queries regardless of range
  # length, and the per-model totals are returned alongside the trend so
  # callers don't need to re-query the same range for plain period totals.
  def calculate_monthly_trends_for_period(start_date, end_date)
    range_date = start_date..end_date
    range_ts   = start_date.beginning_of_day..end_date.end_of_day

    to_key = ->(ts) { ts.to_date.strftime('%Y-%m') }
    idx    = ->(h)  { h.transform_keys { |k| to_key.(k) } }

    c_counts  = idx.(Customer.where(created_at: range_ts).group("DATE_TRUNC('month', created_at)").count)
    ld_counts = idx.(Lead.where(created_at: range_ts).group("DATE_TRUNC('month', created_at)").count)

    hc = idx.(HealthInsurance.where(DRWISE).where(policy_start_date: range_date).group("DATE_TRUNC('month', policy_start_date)").count)
    lc = idx.(LifeInsurance.where(DRWISE).where(policy_start_date: range_date).group("DATE_TRUNC('month', policy_start_date)").count)
    mc = idx.((MotorInsurance.where(DRWISE).where(policy_start_date: range_date).group("DATE_TRUNC('month', policy_start_date)").count rescue {}))
    oc = idx.((OtherInsurance.where(DRWISE).where(policy_start_date: range_date).group("DATE_TRUNC('month', policy_start_date)").count rescue {}))

    hp = idx.(HealthInsurance.where(DRWISE).where(policy_start_date: range_date).group("DATE_TRUNC('month', policy_start_date)").sum(:net_premium))
    lp = idx.(LifeInsurance.where(DRWISE).where(policy_start_date: range_date).group("DATE_TRUNC('month', policy_start_date)").sum(:net_premium))
    mp = idx.((MotorInsurance.where(DRWISE).where(policy_start_date: range_date).group("DATE_TRUNC('month', policy_start_date)").sum(:net_premium) rescue {}))
    op = idx.((OtherInsurance.where(DRWISE).where(policy_start_date: range_date).group("DATE_TRUNC('month', policy_start_date)").sum(:net_premium) rescue {}))

    trends = {}
    current_date = start_date.beginning_of_month

    while current_date <= end_date
      k = current_date.strftime('%Y-%m')
      trends[current_date.strftime('%b %Y')] = {
        customers: c_counts[k]  || 0,
        policies:  (hc[k] || 0) + (lc[k] || 0) + (mc[k] || 0) + (oc[k] || 0),
        premium:   (hp[k] || 0) + (lp[k] || 0) + (mp[k] || 0) + (op[k] || 0),
        leads:     ld_counts[k] || 0
      }

      current_date = current_date.next_month.beginning_of_month
    end

    totals = {
      health_count: hc.values.sum, life_count: lc.values.sum,
      motor_count: mc.values.sum, other_count: oc.values.sum,
      health_premium: hp.values.sum(0.0), life_premium: lp.values.sum(0.0),
      motor_premium: mp.values.sum(0.0), other_premium: op.values.sum(0.0)
    }

    { trends: trends, totals: totals }
  end

  def calculate_top_affiliates_for_period(start_date, end_date)
    # Previously a triple LEFT JOIN (one per insurance type, each pre-filtered by
    # date/DRWISE) - same row-explosion shape as #calculate_customer_retention for
    # any sub-agent with policies across multiple types. Three independent grouped
    # counts + a Ruby merge, then a single lookup for just the top 10 IDs.
    policy_counts_by_sub_agent = Hash.new(0)
    [HealthInsurance, LifeInsurance, MotorInsurance].each do |klass|
      klass.where(DRWISE)
           .where(policy_start_date: start_date..end_date)
           .where.not(sub_agent_id: nil)
           .group(:sub_agent_id)
           .count
           .each { |sid, c| policy_counts_by_sub_agent[sid] += c }
    end

    top_ids = policy_counts_by_sub_agent.sort_by { |sid, c| [-c, sid] }.first(10).map(&:first)
    return [] if top_ids.empty?

    agents_by_id = SubAgent.where(id: top_ids).index_by(&:id)

    top_ids.filter_map do |sid|
      agent = agents_by_id[sid]
      next unless agent
      OpenStruct.new(
        id: agent.id,
        first_name: agent.first_name,
        last_name: agent.last_name,
        status: agent.status || 'active',
        policies_count: policy_counts_by_sub_agent[sid]
      )
    end
  rescue => e
    Rails.logger.error "Error calculating top affiliates for period: #{e.message}"
    []
  end

  def get_recent_policies_for_period(start_date, end_date)
    policies = []

    HealthInsurance.where(DRWISE).includes(:customer).where(policy_start_date: start_date..end_date).order(policy_start_date: :desc).limit(3).each do |policy|
      policies << {
        type: 'Health Insurance',
        customer: policy.customer&.display_name&.presence || 'Unknown',
        policy_number: policy.policy_number,
        premium: policy.net_premium.to_f,
        date: policy.policy_start_date
      }
    end

    LifeInsurance.where(DRWISE).includes(:customer).where(policy_start_date: start_date..end_date).order(policy_start_date: :desc).limit(3).each do |policy|
      policies << {
        type: 'Life Insurance',
        customer: policy.customer&.display_name&.presence || 'Unknown',
        policy_number: policy.policy_number,
        premium: policy.net_premium.to_f,
        date: policy.policy_start_date
      }
    end

    begin
      MotorInsurance.where(DRWISE).includes(:customer).where(policy_start_date: start_date..end_date).order(policy_start_date: :desc).limit(2).each do |policy|
        policies << {
          type: 'Motor Insurance',
          customer: policy.customer&.display_name&.presence || 'Unknown',
          policy_number: policy.policy_number,
          premium: policy.net_premium.to_f,
          date: policy.policy_start_date
        }
      end
    rescue; end

    policies.sort_by { |p| p[:date] || Date.new(1900) }.reverse.first(10)
  end

  def calculate_top_customers_by_premium_for_period(start_date, end_date)
    range = start_date..end_date
    totals = Hash.new(0.0)

    [HealthInsurance, LifeInsurance].each do |model|
      model.where(DRWISE).where(policy_start_date: range)
           .joins(:customer)
           .group("CONCAT(customers.first_name, ' ', customers.last_name)")
           .sum(:net_premium)
           .each { |name, amt| totals[name.strip] += amt.to_f }
    end

    begin
      MotorInsurance.where(DRWISE).where(policy_start_date: range)
                    .joins(:customer)
                    .group("CONCAT(customers.first_name, ' ', customers.last_name)")
                    .sum(:net_premium)
                    .each { |name, amt| totals[name.strip] += amt.to_f }
    rescue; end

    totals.sort_by { |_, v| -v }.first(8).to_h
  rescue => e
    Rails.logger.error "Error calculating top customers: #{e.message}"
    {}
  end

  # Single query with FILTER clauses instead of 4 separate SUMs.
  def calculate_commission_summary_for_period(start_date, end_date)
    dt_start = start_date.beginning_of_day
    dt_end   = end_date.end_of_day
    sql = ActiveRecord::Base.sanitize_sql_array([<<~SQL, dt_start: dt_start, dt_end: dt_end])
      SELECT
        COALESCE(SUM(payout_amount) FILTER (WHERE status = 'pending'), 0) AS total_commission_due,
        COALESCE(SUM(payout_amount) FILTER (WHERE status = 'paid'), 0) AS total_commission_paid,
        COALESCE(SUM(payout_amount) FILTER (WHERE payout_to = 'sub_agent' AND status = 'pending'), 0) AS affiliate_commissions,
        COALESCE(SUM(payout_amount) FILTER (WHERE payout_to = 'ambassador' AND status = 'pending'), 0) AS ambassador_commissions
      FROM commission_payouts
      WHERE created_at BETWEEN :dt_start AND :dt_end
    SQL
    row = ActiveRecord::Base.connection.select_one(sql)
    {
      total_commission_due:   row['total_commission_due'].to_f,
      total_commission_paid:  row['total_commission_paid'].to_f,
      affiliate_commissions:  row['affiliate_commissions'].to_f,
      ambassador_commissions: row['ambassador_commissions'].to_f
    }
  rescue => e
    Rails.logger.error "Error calculating commission summary for period: #{e.message}"
    { total_commission_due: 0, total_commission_paid: 0, affiliate_commissions: 0, ambassador_commissions: 0 }
  end

  # Renewal analytics used to run ~16 queries (expiring soon/later, expired,
  # and renewal-rate counts, each queried per insurance type). One FILTER
  # query per model now returns all four buckets at once, and the renewal
  # rate's "eligible" count is just the Health+Life expired count (it's the
  # same condition), so it needs no query of its own.
  def calculate_renewal_analytics_for_period(start_date, end_date)
    end_plus_30 = end_date + 30.days
    end_plus_60 = end_date + 60.days
    today = Date.current

    expiring_soon = 0
    expiring_later = 0
    expired = 0
    renewal_eligible = 0
    renewed = 0

    [[HealthInsurance, true], [LifeInsurance, true], [MotorInsurance, false], [OtherInsurance, false]].each do |klass, counts_for_renewal_rate|
      row = renewal_counts_for_model(klass, start_date, end_date, end_plus_30, end_plus_60, today)
      next unless row

      expiring_soon  += row['expiring_soon'].to_i
      expiring_later += row['expiring_later'].to_i
      expired        += row['expired'].to_i

      next unless counts_for_renewal_rate
      renewal_eligible += row['expired'].to_i
      renewed          += row['renewed'].to_i
    end

    {
      expiring_soon: expiring_soon,
      expiring_later: expiring_later,
      expired: expired,
      renewal_rate: renewal_eligible > 0 ? ((renewed.to_f / renewal_eligible.to_f) * 100).round(1) : 0
    }
  end

  def renewal_counts_for_model(klass, start_date, end_date, end_plus_30, end_plus_60, today)
    sql = ActiveRecord::Base.sanitize_sql_array([<<~SQL, start_date: start_date, end_date: end_date, end_plus_30: end_plus_30, end_plus_60: end_plus_60, today: today])
      SELECT
        COUNT(*) FILTER (WHERE policy_end_date BETWEEN :end_date AND :end_plus_30) AS expiring_soon,
        COUNT(*) FILTER (WHERE policy_end_date BETWEEN :end_plus_30 AND :end_plus_60) AS expiring_later,
        COUNT(*) FILTER (WHERE policy_end_date < :today) AS expired,
        COUNT(*) FILTER (WHERE policy_type = 'Renewal') AS renewed
      FROM #{klass.quoted_table_name}
      WHERE is_admin_added = TRUE AND is_customer_added = FALSE AND is_agent_added = FALSE
        AND policy_start_date BETWEEN :start_date AND :end_date
    SQL
    ActiveRecord::Base.connection.select_one(sql)
  rescue => e
    Rails.logger.error "renewal_counts_for_model error (#{klass.name}): #{e.message}"
    nil
  end

  # Was 5 separate COUNT queries (one per stage); now built from a single
  # pre-fetched stage_counts hash (see build_lead_stage_distribution, which
  # reuses the exact same query).
  def build_lead_conversion_funnel(stage_counts)
    {
      'Lead Generated'           => stage_counts['lead_generated'] || 0,
      'Consultation Scheduled'   => stage_counts['consultation_scheduled'] || 0,
      'One on One'               => stage_counts['one_on_one'] || 0,
      'Follow Up'                => (stage_counts['follow_up'] || 0) + (stage_counts['re_follow_up'] || 0),
      'Converted'                => stage_counts['converted'] || 0
    }
  rescue => e
    Rails.logger.error "Error building lead conversion funnel: #{e.message}"
    { 'Lead Generated' => 0, 'Consultation Scheduled' => 0, 'One on One' => 0, 'Follow Up' => 0, 'Converted' => 0 }
  end

  # Was 9 separate COUNT queries (one per stage); now built from the same
  # pre-fetched stage_counts hash as build_lead_conversion_funnel.
  def build_lead_stage_distribution(stage_counts)
    {
      'Lead Generated'         => stage_counts['lead_generated'] || 0,
      'Consultation Scheduled' => stage_counts['consultation_scheduled'] || 0,
      'One on One'             => stage_counts['one_on_one'] || 0,
      'Follow Up'              => (stage_counts['follow_up'] || 0) + (stage_counts['re_follow_up'] || 0),
      'Follow Up Successful'   => stage_counts['follow_up_successful'] || 0,
      'Follow Up Unsuccessful' => stage_counts['follow_up_unsuccessful'] || 0,
      'Not Interested'         => stage_counts['not_interested'] || 0,
      'Converted'              => stage_counts['converted'] || 0,
      'Lead Closed'            => stage_counts['lead_closed'] || 0
    }
  rescue => e
    Rails.logger.error "Error building lead stage distribution: #{e.message}"
    { 'Lead Generated' => 0, 'Consultation Scheduled' => 0, 'One on One' => 0, 'Follow Up' => 0,
      'Follow Up Successful' => 0, 'Follow Up Unsuccessful' => 0, 'Not Interested' => 0,
      'Converted' => 0, 'Lead Closed' => 0 }
  end

  def calculate_customer_location_for_period(start_date, end_date, total_customers = nil)
    dt_start = start_date.beginning_of_day
    dt_end   = end_date.end_of_day
    location_data = {}

    Customer.where(created_at: dt_start..dt_end).group(:city).count.each do |city, count|
      next if city.blank?
      location_data[city.to_s.titleize] = count
    end

    if location_data.empty?
      Customer.where(created_at: dt_start..dt_end).group(:state).count.each do |state, count|
        next if state.blank?
        location_data[state.to_s.titleize] = count
      end
    end

    # Falls back to the already-known total instead of re-querying the same
    # count when neither city nor state grouping produced anything.
    location_data = { 'Unknown' => total_customers || Customer.where(created_at: dt_start..dt_end).count } if location_data.empty?
    location_data
  rescue => e
    Rails.logger.error "Error calculating customer location for period: #{e.message}"
    { 'Unknown' => 0 }
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
    AnalyticsCache.clear_cache('main_analytics_v3')
    load_fresh_analytics_data
  end

  def load_analytics_data
    cache_identifier = 'main_analytics_v3'

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
    cache_identifier = 'main_analytics_v3'
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
      'Life Insurance'   => LifeInsurance.where(DRWISE).count,
      'Health Insurance' => HealthInsurance.where(DRWISE).count,
      'Motor Insurance'  => (MotorInsurance.where(DRWISE).count rescue 0),
      'Other Insurance'  => (OtherInsurance.where(DRWISE).count rescue 0)
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

    # Actual commission per agent from CommissionPayout records
    @agent_commission = calculate_agent_commission

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

    # Investor analytics
    @total_investors = Investor.count rescue 0
    @investor_status_distribution = calculate_investor_status_distribution
    @top_investors_by_ambassadors = calculate_top_investors_by_ambassadors
    @top_investors_by_commission = calculate_top_investors_by_commission

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
      agent_performance: @agent_performance.transform_values(&:to_f),
      agent_customer_data: @agent_customer_data,
      agent_commission: @agent_commission.transform_values(&:to_f),
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
      client_requests_count: @client_requests_count,
      total_investors: @total_investors,
      investor_status_distribution: @investor_status_distribution,
      top_investors_by_ambassadors: @top_investors_by_ambassadors,
      top_investors_by_commission: @top_investors_by_commission
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

    @recent_policies = (cached_data['recent_policies'] || []).map do |p|
      {
        type:    p['type'],
        customer: p['customer'],
        policy_number: p['policy_number'],
        premium:  p['premium'].to_f,
        date:    p['date'].present? ? Time.parse(p['date']) : nil
      }
    end

    # Convert recent leads back to objects for view compatibility
    @recent_leads = (cached_data['recent_leads'] || []).map do |lead_hash|
      OpenStruct.new(lead_hash)
    end
    @commission_summary = cached_data['commission_summary']
    @renewal_analytics = cached_data['renewal_analytics']
    @agent_performance = (cached_data['agent_performance'] || {}).transform_values(&:to_f)
    @agent_customer_data = cached_data['agent_customer_data']
    @agent_commission = (cached_data['agent_commission'] || {}).transform_values(&:to_f)
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
    @total_investors = cached_data['total_investors'] || 0
    @investor_status_distribution = cached_data['investor_status_distribution'] || { 'Active' => 0, 'Inactive' => 0 }
    @top_investors_by_ambassadors = cached_data['top_investors_by_ambassadors'] || {}
    @top_investors_by_commission = cached_data['top_investors_by_commission'] || {}
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
    HealthInsurance.where(DRWISE).count +
    LifeInsurance.where(DRWISE).count +
    (MotorInsurance.where(DRWISE).count rescue 0) +
    (OtherInsurance.where(DRWISE).count rescue 0)
  end

  def calculate_total_premium_collected
    (HealthInsurance.where(DRWISE).sum(:net_premium) || 0) +
    (LifeInsurance.where(DRWISE).sum(:net_premium) || 0) +
    (MotorInsurance.where(DRWISE).sum(:net_premium) || 0 rescue 0) +
    (OtherInsurance.where(DRWISE).sum(:net_premium) || 0 rescue 0)
  end

  def calculate_growth_percentage(model, period_start)
    current_count = model.where('created_at >= ?', period_start).count
    previous_count = model.where(created_at: (period_start - 1.month)..(period_start - 1.day)).count

    return 0 if previous_count == 0
    ((current_count.to_f - previous_count.to_f) / previous_count.to_f * 100).round(1)
  end

  def calculate_premium_growth
    current_premium = HealthInsurance.where(DRWISE).where(policy_start_date: @current_month..).sum(:net_premium) +
                      LifeInsurance.where(DRWISE).where(policy_start_date: @current_month..).sum(:net_premium) +
                      (MotorInsurance.where(DRWISE).where(policy_start_date: @current_month..).sum(:net_premium) || 0 rescue 0) +
                      (OtherInsurance.where(DRWISE).where(policy_start_date: @current_month..).sum(:net_premium) || 0 rescue 0)

    previous_premium = HealthInsurance.where(DRWISE).where(policy_start_date: @last_month..(@current_month - 1.day)).sum(:net_premium) +
                       LifeInsurance.where(DRWISE).where(policy_start_date: @last_month..(@current_month - 1.day)).sum(:net_premium) +
                       (MotorInsurance.where(DRWISE).where(policy_start_date: @last_month..(@current_month - 1.day)).sum(:net_premium) || 0 rescue 0) +
                       (OtherInsurance.where(DRWISE).where(policy_start_date: @last_month..(@current_month - 1.day)).sum(:net_premium) || 0 rescue 0)

    return 0 if previous_premium == 0
    ((current_premium.to_f - previous_premium.to_f) / previous_premium.to_f * 100).round(1)
  end

  def calculate_monthly_trends
    start_date = 11.months.ago.beginning_of_month
    range_date = start_date.to_date..Date.current
    range_ts   = start_date.beginning_of_day..Time.current.end_of_day

    to_key = ->(ts) { ts.to_date.strftime('%Y-%m') }
    idx    = ->(h)  { h.transform_keys { |k| to_key.(k) } }

    c_counts  = idx.(Customer.where(created_at: range_ts).group("DATE_TRUNC('month', created_at)").count)
    ld_counts = idx.(Lead.where(created_at: range_ts).group("DATE_TRUNC('month', created_at)").count)

    hc = idx.(HealthInsurance.where(DRWISE).where(policy_start_date: range_date).group("DATE_TRUNC('month', policy_start_date)").count)
    lc = idx.(LifeInsurance.where(DRWISE).where(policy_start_date: range_date).group("DATE_TRUNC('month', policy_start_date)").count)
    mc = idx.((MotorInsurance.where(DRWISE).where(policy_start_date: range_date).group("DATE_TRUNC('month', policy_start_date)").count rescue {}))
    oc = idx.((OtherInsurance.where(DRWISE).where(policy_start_date: range_date).group("DATE_TRUNC('month', policy_start_date)").count rescue {}))

    hp = idx.(HealthInsurance.where(DRWISE).where(policy_start_date: range_date).group("DATE_TRUNC('month', policy_start_date)").sum(:net_premium))
    lp = idx.(LifeInsurance.where(DRWISE).where(policy_start_date: range_date).group("DATE_TRUNC('month', policy_start_date)").sum(:net_premium))
    mp = idx.((MotorInsurance.where(DRWISE).where(policy_start_date: range_date).group("DATE_TRUNC('month', policy_start_date)").sum(:net_premium) rescue {}))
    op = idx.((OtherInsurance.where(DRWISE).where(policy_start_date: range_date).group("DATE_TRUNC('month', policy_start_date)").sum(:net_premium) rescue {}))

    trends = {}
    12.times do |i|
      month_date = (Date.current - i.months).beginning_of_month
      k = month_date.strftime('%Y-%m')
      trends[month_date.strftime('%b %Y')] = {
        customers: c_counts[k]  || 0,
        policies:  (hc[k] || 0) + (lc[k] || 0) + (mc[k] || 0) + (oc[k] || 0),
        premium:   (hp[k] || 0) + (lp[k] || 0) + (mp[k] || 0) + (op[k] || 0),
        leads:     ld_counts[k] || 0
      }
    end
    trends.to_a.reverse.to_h
  end

  def calculate_top_affiliates
    health_counts = HealthInsurance.group(:sub_agent_id).count
    life_counts   = LifeInsurance.group(:sub_agent_id).count
    motor_counts  = MotorInsurance.group(:sub_agent_id).count

    all_ids = (health_counts.keys + life_counts.keys + motor_counts.keys).uniq.compact
    totals  = all_ids.map do |id|
      [(health_counts[id] || 0) + (life_counts[id] || 0) + (motor_counts[id] || 0), id]
    end.select { |cnt, _| cnt > 0 }.sort_by { |cnt, _| -cnt }.first(10)

    top_ids = totals.map(&:last)
    agents  = SubAgent.where(id: top_ids).index_by(&:id)

    totals.filter_map do |cnt, id|
      agent = agents[id]
      next unless agent
      OpenStruct.new(
        id: agent.id, first_name: agent.first_name, last_name: agent.last_name,
        status: agent.status || 'active', policies_count: cnt
      )
    end
  rescue => e
    Rails.logger.error "Error calculating top affiliates: #{e.message}"
    []
  end

  def get_recent_policies
    policies = []

    HealthInsurance.where(DRWISE).includes(:customer).order(created_at: :desc).limit(3).each do |policy|
      policies << {
        type: 'Health Insurance',
        customer: policy.customer&.display_name&.presence || 'Unknown',
        policy_number: policy.policy_number,
        premium: policy.net_premium.to_f,
        date: policy.created_at
      }
    end

    LifeInsurance.where(DRWISE).includes(:customer).order(created_at: :desc).limit(3).each do |policy|
      policies << {
        type: 'Life Insurance',
        customer: policy.customer&.display_name&.presence || 'Unknown',
        policy_number: policy.policy_number,
        premium: policy.net_premium.to_f,
        date: policy.created_at
      }
    end

    begin
      MotorInsurance.where(DRWISE).includes(:customer).order(created_at: :desc).limit(2).each do |policy|
        policies << {
          type: 'Motor Insurance',
          customer: policy.customer&.display_name&.presence || 'Unknown',
          policy_number: policy.policy_number,
          premium: policy.net_premium.to_f,
          date: policy.created_at
        }
      end
    rescue; end

    policies.sort_by { |p| p[:date] || Time.at(0) }.reverse.first(10)
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
    HealthInsurance.where(DRWISE).where(policy_end_date: start_date..end_date).count +
    LifeInsurance.where(DRWISE).where(policy_end_date: start_date..end_date).count +
    (MotorInsurance.where(DRWISE).where(policy_end_date: start_date..end_date).count rescue 0) +
    (OtherInsurance.where(DRWISE).where(policy_end_date: start_date..end_date).count rescue 0)
  end

  def calculate_expired_policies
    HealthInsurance.where(DRWISE).where('policy_end_date < ?', Date.current).count +
    LifeInsurance.where(DRWISE).where('policy_end_date < ?', Date.current).count +
    (MotorInsurance.where(DRWISE).where('policy_end_date < ?', Date.current).count rescue 0) +
    (OtherInsurance.where(DRWISE).where('policy_end_date < ?', Date.current).count rescue 0)
  end

  def calculate_renewal_rate
    total_eligible = LifeInsurance.where(DRWISE).where('policy_end_date < ?', Date.current).count +
                     HealthInsurance.where(DRWISE).where('policy_end_date < ?', Date.current).count
    renewed = LifeInsurance.where(DRWISE).where(policy_type: 'Renewal').count +
              HealthInsurance.where(DRWISE).where(policy_type: 'Renewal').count

    return 0 if total_eligible == 0
    ((renewed.to_f / total_eligible.to_f) * 100).round(1)
  end

  # Was 3 separate GROUP BY queries (one per insurance type, then merged in
  # Ruby); now a single UNION ALL query joined to sub_agents once.
  def calculate_agent_performance
    sql = <<~SQL
      SELECT CONCAT(sub_agents.first_name, ' ', sub_agents.last_name) AS name, SUM(combined.net_premium) AS premium
      FROM (
        SELECT sub_agent_id, net_premium FROM health_insurances
        UNION ALL
        SELECT sub_agent_id, net_premium FROM life_insurances
        UNION ALL
        SELECT sub_agent_id, net_premium FROM motor_insurances
      ) combined
      JOIN sub_agents ON sub_agents.id = combined.sub_agent_id
      GROUP BY name
    SQL

    agent_premiums = {}
    ActiveRecord::Base.connection.select_all(sql).each do |row|
      agent_premiums[row['name']] = row['premium'].to_f
    end

    agent_premiums.sort_by { |_, premium| -premium }.to_h
  rescue => e
    Rails.logger.error "Error calculating agent performance: #{e.message}"
    {}
  end

  # Was 3 separate GROUP BY queries (one per insurance type, then merged in
  # Ruby); now a single UNION ALL query joined to sub_agents once.
  def calculate_agent_commission
    sql = <<~SQL
      SELECT CONCAT(sub_agents.first_name, ' ', sub_agents.last_name) AS name, SUM(combined.commission) AS commission
      FROM (
        SELECT sub_agent_id, sub_agent_commission_amount AS commission FROM health_insurances WHERE sub_agent_id IS NOT NULL
        UNION ALL
        SELECT sub_agent_id, sub_agent_commission_amount FROM life_insurances WHERE sub_agent_id IS NOT NULL
        UNION ALL
        SELECT sub_agent_id, sub_agent_commission_amount FROM motor_insurances WHERE sub_agent_id IS NOT NULL
      ) combined
      JOIN sub_agents ON sub_agents.id = combined.sub_agent_id
      GROUP BY name
    SQL

    agent_commissions = {}
    ActiveRecord::Base.connection.select_all(sql).each do |row|
      agent_commissions[row['name']] = row['commission'].to_f
    end

    agent_commissions
  rescue => e
    Rails.logger.error "Error calculating agent commission: #{e.message}"
    {}
  end

  def calculate_agent_customer_data
    # Calculate customer counts for each agent to avoid DB calls in view.
    # Aggregate counts are computed once per sub_agent_id (not once per SubAgent
    # in a loop) since `.count`/`.distinct.count` always issue a fresh query
    # regardless of `.includes`.
    agent_customers = {}

    customer_counts = Customer.group(:sub_agent_id).count
    health_customer_counts = HealthInsurance.where.not(sub_agent_id: nil).group(:sub_agent_id).distinct.count(:customer_id)
    life_customer_counts = LifeInsurance.where.not(sub_agent_id: nil).group(:sub_agent_id).distinct.count(:customer_id)
    motor_customer_counts = MotorInsurance.where.not(sub_agent_id: nil).group(:sub_agent_id).distinct.count(:customer_id)

    SubAgent.find_each do |sub_agent|
      agent_name = "#{sub_agent.first_name} #{sub_agent.last_name}"

      # Direct customer count
      customer_count = customer_counts[sub_agent.id] || 0

      # Unique customers from each insurance type
      health_customers = health_customer_counts[sub_agent.id] || 0
      life_customers = life_customer_counts[sub_agent.id] || 0
      motor_customers = motor_customer_counts[sub_agent.id] || 0

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
    total_leads = Lead.count
    converted = Lead.where(current_stage: 'converted').count

    return 0 if total_leads == 0
    ((converted.to_f / total_leads.to_f) * 100).round(1)
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

    # Previously a triple LEFT JOIN across all 3 insurance tables with no WHERE
    # clause - for a customer with H health + L life + M motor policies, that's
    # H*L*M joined rows before GROUP BY collapses them. Three independent grouped
    # counts (no join) + a Ruby merge avoids the row explosion entirely.
    policy_counts_by_customer = Hash.new(0)
    [HealthInsurance, LifeInsurance, MotorInsurance].each do |klass|
      klass.group(:customer_id).count.each { |cid, c| policy_counts_by_customer[cid] += c }
    end
    customers_with_multiple_policies = policy_counts_by_customer.count { |_, c| c > 1 }

    ((customers_with_multiple_policies.to_f / total_customers.to_f) * 100).round(1)
  rescue => e
    Rails.logger.error "Error calculating customer retention: #{e.message}"
    0
  end

  # Was 5 separate COUNT queries (one per stage); now one grouped query.
  def calculate_lead_conversion_funnel
    stage_counts = Lead.group(:current_stage).count
    {
      'Lead Generated'           => stage_counts['lead_generated'] || 0,
      'Consultation Scheduled'   => stage_counts['consultation_scheduled'] || 0,
      'One on One'               => stage_counts['one_on_one'] || 0,
      'Follow Up'                => (stage_counts['follow_up'] || 0) + (stage_counts['re_follow_up'] || 0),
      'Converted'                => stage_counts['converted'] || 0
    }
  rescue => e
    Rails.logger.error "Error calculating lead conversion funnel: #{e.message}"
    { 'Lead Generated' => 0, 'Consultation Scheduled' => 0, 'One on One' => 0, 'Follow Up' => 0, 'Converted' => 0 }
  end

  # Was 9 separate COUNT queries (one per stage); now one grouped query.
  def calculate_lead_stage_distribution
    stage_counts = Lead.group(:current_stage).count
    {
      'Lead Generated'         => stage_counts['lead_generated'] || 0,
      'Consultation Scheduled' => stage_counts['consultation_scheduled'] || 0,
      'One on One'             => stage_counts['one_on_one'] || 0,
      'Follow Up'              => (stage_counts['follow_up'] || 0) + (stage_counts['re_follow_up'] || 0),
      'Follow Up Successful'   => stage_counts['follow_up_successful'] || 0,
      'Follow Up Unsuccessful' => stage_counts['follow_up_unsuccessful'] || 0,
      'Not Interested'         => stage_counts['not_interested'] || 0,
      'Converted'              => stage_counts['converted'] || 0,
      'Lead Closed'            => stage_counts['lead_closed'] || 0
    }
  rescue => e
    Rails.logger.error "Error calculating lead stage distribution: #{e.message}"
    { 'Lead Generated' => 0, 'Consultation Scheduled' => 0, 'One on One' => 0, 'Follow Up' => 0,
      'Follow Up Successful' => 0, 'Follow Up Unsuccessful' => 0, 'Not Interested' => 0,
      'Converted' => 0, 'Lead Closed' => 0 }
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
    start_date = 11.months.ago.beginning_of_month
    raw_counts = Customer
      .where(created_at: start_date.beginning_of_day..Time.current.end_of_day)
      .group("DATE_TRUNC('month', created_at)")
      .count

    counts_by_month = raw_counts.each_with_object({}) do |(ts, cnt), h|
      h[ts.to_date.strftime('%Y-%m')] = cnt
    end

    trend_data = {}
    12.times do |i|
      month_date = (Date.current - i.months).beginning_of_month
      trend_data[month_date.strftime('%b %Y')] = counts_by_month[month_date.strftime('%Y-%m')] || 0
    end
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
    start_date = 11.months.ago.beginning_of_month.to_date
    range_date = start_date..Date.current
    to_key     = ->(ts) { ts.to_date.strftime('%Y-%m') }

    h_sums = HealthInsurance.where(DRWISE).where(policy_start_date: range_date)
                            .group("DATE_TRUNC('month', policy_start_date)").sum(:net_premium)
                            .transform_keys { |k| to_key.(k) }
    l_sums = LifeInsurance.where(DRWISE).where(policy_start_date: range_date)
                          .group("DATE_TRUNC('month', policy_start_date)").sum(:net_premium)
                          .transform_keys { |k| to_key.(k) }
    m_sums = (MotorInsurance.where(DRWISE).where(policy_start_date: range_date)
                            .group("DATE_TRUNC('month', policy_start_date)").sum(:net_premium)
                            .transform_keys { |k| to_key.(k) } rescue {})

    trend_data = {}
    12.times do |i|
      month_date = (Date.current - i.months).beginning_of_month
      k = month_date.strftime('%Y-%m')
      total = (h_sums[k] || 0) + (l_sums[k] || 0) + (m_sums[k] || 0)
      trend_data[month_date.strftime('%b %Y')] = total.round(0)
    end
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

  def calculate_investor_status_distribution
    # nil status is treated as active (default). Single query with FILTER
    # instead of two separate COUNTs.
    active_count, inactive_count = Investor.pluck(
      Arel.sql('COUNT(*) FILTER (WHERE status = 0 OR status IS NULL)'),
      Arel.sql('COUNT(*) FILTER (WHERE status = 1)')
    ).first
    { 'Active' => active_count.to_i, 'Inactive' => inactive_count.to_i }
  rescue => e
    Rails.logger.error "Error calculating investor status distribution: #{e.message}"
    { 'Active' => 0, 'Inactive' => 0 }
  end

  def calculate_top_investors_by_ambassadors
    return {} unless Distributor.column_names.include?('investor_id')

    result = {}
    Investor.joins("LEFT JOIN distributors ON distributors.investor_id = investors.id")
            .group('investors.id, investors.first_name, investors.last_name')
            .select('investors.id, investors.first_name, investors.last_name, COUNT(distributors.id) as ambassador_count')
            .order('ambassador_count DESC')
            .limit(10)
            .each do |inv|
      name = "#{inv.first_name} #{inv.last_name}".strip
      result[name] = inv.ambassador_count.to_i
    end
    result
  rescue => e
    Rails.logger.error "Error calculating top investors by ambassadors: #{e.message}"
    {}
  end

  def calculate_top_investors_by_commission
    investor_commissions = {}
    [HealthInsurance, MotorInsurance].each do |model|
      model.where.not(investor_id: nil)
           .joins("JOIN investors ON investors.id = #{model.table_name}.investor_id")
           .group("CONCAT(investors.first_name, ' ', investors.last_name)")
           .sum(:investor_commission_amount)
           .each do |name, commission|
        investor_commissions[name] = (investor_commissions[name] || 0) + commission.to_f
      end
    end
    investor_commissions.sort_by { |_, v| -v }.first(10).to_h
  rescue => e
    Rails.logger.error "Error calculating top investors by commission: #{e.message}"
    {}
  end

  def fetch_analytics_card_records(metric)
    start_date = @filter_start_date
    end_date   = @filter_end_date
    dt_start   = start_date.beginning_of_day
    dt_end     = end_date.end_of_day
    range      = start_date..end_date

    case metric
    when 'customers'
      Customer.where(created_at: dt_start..dt_end).order(created_at: :desc).map do |c|
        { type: 'Customer', name: c.display_name, created_at: c.created_at.strftime('%d-%m-%Y'),
          city: c.city.to_s, phone: c.mobile.to_s }
      end
    when 'policies', 'premium'
      analytics_collect_policies(range)
    when 'leads'
      Lead.where(created_at: dt_start..dt_end).order(created_at: :desc).map do |l|
        { type: 'Lead', name: l.name.to_s, stage: l.current_stage.to_s.humanize,
          created_at: l.created_at.strftime('%d-%m-%Y') }
      end
    when 'investors'
      Investor.order(first_name: :asc, last_name: :asc).map do |i|
        { type: 'Investor', name: i.display_name.to_s, created_at: i.created_at.strftime('%d-%m-%Y') }
      end
    when 'affiliates'
      SubAgent.order(created_at: :desc).map do |a|
        { type: 'Affiliate', name: "#{a.first_name} #{a.last_name}".strip,
          created_at: a.created_at.strftime('%d-%m-%Y'), status: a.status.to_s }
      end
    else
      []
    end
  rescue => e
    Rails.logger.error "analytics card_detail error: #{e.message}"
    []
  end

  def analytics_collect_policies(range)
    policies = []
    HealthInsurance.where(DRWISE).where(policy_start_date: range).includes(:customer).order(policy_start_date: :desc).each do |p|
      policies << analytics_format_policy(p, 'Health', 'health')
    end
    LifeInsurance.where(DRWISE).where(policy_start_date: range).includes(:customer).order(policy_start_date: :desc).each do |p|
      policies << analytics_format_policy(p, 'Life', 'life')
    end
    begin
      MotorInsurance.where(DRWISE).where(policy_start_date: range).includes(:customer).order(policy_start_date: :desc).each do |p|
        policies << analytics_format_policy(p, 'Motor', 'motor')
      end
    rescue; end
    begin
      OtherInsurance.where(DRWISE).where(policy_start_date: range).includes(:customer).order(policy_start_date: :desc).each do |p|
        policies << analytics_format_policy(p, 'Other', 'other')
      end
    rescue; end
    policies.sort_by { |p| [p[:policy_start_date_raw] || '0000-00-00', p[:created_at_raw] || '0000-00-00'] }.reverse
  end

  def analytics_format_policy(p, type, route_key)
    { type: type,
      policy_number: p.policy_number.to_s,
      policy_link: "/admin/insurance/#{route_key}/#{p.id}",
      drwise: p.is_admin_added == true && p.is_customer_added == false && p.is_agent_added == false,
      customer: p.customer&.display_name || 'Unknown',
      policy_start_date: p.policy_start_date&.strftime('%d-%m-%Y'),
      policy_start_date_raw: p.policy_start_date.to_s,
      policy_end_date: p.policy_end_date&.strftime('%d-%m-%Y'),
      created_at: p.created_at.strftime('%d-%m-%Y'),
      created_at_raw: p.created_at.strftime('%Y-%m-%d'),
      net_premium: p.net_premium.to_f.round(2),
      total_premium: p.total_premium.to_f.round(2) }
  end
end