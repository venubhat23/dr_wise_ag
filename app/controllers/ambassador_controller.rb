class AmbassadorController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_ambassador_user
  before_action :setup_ambassador_data

  def dashboard
    # Common data setup handled by before_action

    # Recent commission activity
    @recent_commission_activity = get_recent_commission_activity

    # Monthly commission trends (last 6 months)
    @monthly_trends = get_monthly_commission_trends
  end

  def commission_details
    # Common data setup handled by before_action

    # Monthly commission trends (needed for the view)
    @monthly_trends = get_monthly_commission_trends

    # Recent commission activity
    @recent_commission_activity = get_recent_commission_activity

    # Get all commission data with filters
    @commission_data = get_filtered_commission_data

    # Pagination (safely handle if Kaminari is available)
    if @commission_data.respond_to?(:page)
      @commission_data = @commission_data.page(params[:page]).per(20)
    end
  end

  def payout_history
    # Common data setup handled by before_action

    # Get payout history
    @payouts = get_ambassador_payouts.order(created_at: :desc)

    # Pagination (safely handle if Kaminari is available)
    if @payouts.respond_to?(:page)
      @payouts = @payouts.page(params[:page]).per(15)
    end

    # Summary statistics
    @total_earned = @payouts.where(status: 'paid').sum(:payout_amount)
    @pending_amount = @payouts.where(status: 'pending').sum(:payout_amount)
    @total_policies = get_total_policies_count
  end

  private

  def setup_ambassador_data
    @ambassador = current_user
    @distributor = Distributor.find_by(email: @ambassador.email)

    if @distributor.nil?
      redirect_to root_path, alert: 'Ambassador profile not found.'
      return
    end

    # Get assigned affiliates with their detailed information
    @assigned_affiliates = @distributor.assigned_sub_agents.includes(
      :distributor_assignment
    ).order('sub_agents.created_at DESC')

    # Calculate statistics for all affiliates in one batched pass instead of
    # ~25 queries per affiliate (was O(N) HealthInsurance/LifeInsurance/
    # MotorInsurance/CommissionPayout lookups per affiliate on every page load).
    @affiliate_stats = batch_calculate_affiliate_stats(@assigned_affiliates.to_a)

    # Overall distributor statistics
    @distributor_stats = calculate_distributor_stats
  end

  def ensure_ambassador_user
    unless current_user&.ambassador?
      redirect_to root_path, alert: 'Access denied. Ambassador access required.'
    end
  end

  def batch_calculate_affiliate_stats(affiliates)
    return {} if affiliates.empty?

    affiliate_ids = affiliates.map(&:id)

    health = HealthInsurance.where(sub_agent_id: affiliate_ids)
                             .select(:id, :sub_agent_id, :customer_id, :policy_number, :total_premium, :created_at).to_a
    life   = LifeInsurance.where(sub_agent_id: affiliate_ids)
                           .select(:id, :sub_agent_id, :customer_id, :policy_number, :total_premium, :created_at).to_a
    motor  = MotorInsurance.where(sub_agent_id: affiliate_ids)
                            .select(:id, :sub_agent_id, :customer_id, :policy_number, :total_premium, :created_at, :main_agent_commission_amount).to_a

    health_by_affiliate = health.group_by(&:sub_agent_id)
    life_by_affiliate   = life.group_by(&:sub_agent_id)
    motor_by_affiliate  = motor.group_by(&:sub_agent_id)

    h_comm = CommissionPayout.where(policy_type: 'health', policy_id: health.map(&:id), payout_to: 'ambassador').group(:policy_id).sum(:payout_amount)
    l_comm = CommissionPayout.where(policy_type: 'life',   policy_id: life.map(&:id),   payout_to: 'ambassador').group(:policy_id).sum(:payout_amount)
    m_comm = CommissionPayout.where(policy_type: 'motor',  policy_id: motor.map(&:id),  payout_to: 'ambassador').group(:policy_id).sum(:payout_amount)

    # Other insurance: one grouped query instead of N per-affiliate queries.
    other_by_affiliate = Hash.new { |h, k| h[k] = { count: 0, premium: 0.0, commission: 0.0 } }
    if defined?(OtherInsurance)
      begin
        has_commission_col = OtherInsurance.column_names.include?('commission_amount')
        commission_expr = has_commission_col ? 'COALESCE(SUM(commission_amount),0)' : 'COALESCE(SUM(total_premium),0) * 0.05'
        OtherInsurance.where(sub_agent_id: affiliate_ids)
                      .group(:sub_agent_id)
                      .pluck(:sub_agent_id, Arel.sql('COUNT(*)'), Arel.sql('COALESCE(SUM(total_premium),0)'), Arel.sql(commission_expr))
                      .each do |sub_agent_id, count, premium, commission|
          other_by_affiliate[sub_agent_id] = { count: count.to_i, premium: premium.to_f, commission: commission.to_f }
        end
      rescue => e
        Rails.logger.debug "Could not load other insurance data: #{e.message}"
      end
    end

    all_customer_ids = (health.map(&:customer_id) + life.map(&:customer_id) + motor.map(&:customer_id)).compact.uniq
    customers_by_id = Customer.where(id: all_customer_ids).index_by(&:id)

    affiliate_ids.index_with do |aid|
      h_policies = health_by_affiliate[aid] || []
      l_policies = life_by_affiliate[aid] || []
      m_policies = motor_by_affiliate[aid] || []
      other = other_by_affiliate[aid]

      health_commission = h_policies.sum { |p| h_comm[p.id].to_f }
      life_commission   = l_policies.sum { |p| l_comm[p.id].to_f }
      motor_commission  = m_policies.sum { |p| m_comm[p.id].to_f }
      other_commission  = other[:commission]

      total_policies = h_policies.size + l_policies.size + m_policies.size + other[:count]
      total_premium  = h_policies.sum { |p| p.total_premium.to_f } +
                        l_policies.sum { |p| p.total_premium.to_f } +
                        m_policies.sum { |p| p.total_premium.to_f } +
                        other[:premium]
      total_commission = (health_commission + life_commission + motor_commission + other_commission).to_f

      customer_ids = (h_policies.map(&:customer_id) + l_policies.map(&:customer_id) + m_policies.map(&:customer_id)).compact.uniq

      recent = []
      h_policies.sort_by(&:created_at).reverse.first(3).each do |p|
        recent << { type: 'Health', policy_number: p.policy_number, customer: customers_by_id[p.customer_id]&.display_name || 'Unknown', premium: p.total_premium, commission: h_comm[p.id].to_f, created_at: p.created_at }
      end
      l_policies.sort_by(&:created_at).reverse.first(3).each do |p|
        recent << { type: 'Life', policy_number: p.policy_number, customer: customers_by_id[p.customer_id]&.display_name || 'Unknown', premium: p.total_premium, commission: l_comm[p.id].to_f, created_at: p.created_at }
      end
      m_policies.sort_by(&:created_at).reverse.first(2).each do |p|
        recent << { type: 'Motor', policy_number: p.policy_number, customer: customers_by_id[p.customer_id]&.display_name || 'Unknown', premium: p.total_premium, commission: p.main_agent_commission_amount || 0, created_at: p.created_at }
      end
      recent = recent.sort_by { |r| r[:created_at] }.reverse.first(5)

      {
        total_policies: total_policies,
        total_premium: total_premium,
        total_commission: total_commission,
        health_policies: h_policies.size,
        health_commission: health_commission,
        life_policies: l_policies.size,
        life_commission: life_commission,
        motor_policies: m_policies.size,
        motor_commission: motor_commission,
        other_policies: other[:count],
        other_commission: other_commission,
        recent_policies: recent,
        customers_count: customer_ids.size,
        joined_date: affiliates.find { |a| a.id == aid }&.created_at
      }
    end
  end

  def calculate_distributor_stats
    total_policies = 0
    total_premium = 0.0
    total_commission = 0.0
    total_customers = 0

    @assigned_affiliates.each do |affiliate|
      stats = @affiliate_stats[affiliate.id]
      total_policies += stats[:total_policies]
      total_premium += stats[:total_premium]
      total_commission += stats[:total_commission]
      total_customers += stats[:customers_count]
    end

    {
      total_affiliates: @assigned_affiliates.count,
      active_affiliates: @assigned_affiliates.active.count,
      total_policies: total_policies,
      total_premium: total_premium,
      total_commission: total_commission,
      total_customers: total_customers,
      avg_policies_per_affiliate: @assigned_affiliates.count > 0 ? (total_policies.to_f / @assigned_affiliates.count).round(2) : 0
    }
  end

  def get_recent_commission_activity
    activities = []
    affiliate_ids = @assigned_affiliates.pluck(:id)

    # Get recent ambassador commission payouts for all policies handled by assigned affiliates
    recent_payouts = CommissionPayout.where(payout_to: 'ambassador')
                                    .order(payout_date: :desc, created_at: :desc)
                                    .limit(10)
                                    .to_a

    # Batch-load the policies for these payouts (3 queries total) instead of
    # one find_by per payout, and use .includes instead of .joins so
    # policy.customer below doesn't re-query.
    ids_by_type = recent_payouts.group_by(&:policy_type).transform_values { |ps| ps.map(&:policy_id) }
    health_by_id = HealthInsurance.includes(:customer).where(id: ids_by_type['health'] || [], sub_agent_id: affiliate_ids).index_by(&:id)
    life_by_id   = LifeInsurance.includes(:customer).where(id: ids_by_type['life'] || [], sub_agent_id: affiliate_ids).index_by(&:id)
    motor_by_id  = MotorInsurance.includes(:customer).where(id: ids_by_type['motor'] || [], sub_agent_id: affiliate_ids).index_by(&:id)
    type_labels  = { 'health' => 'Health Insurance Commission', 'life' => 'Life Insurance Commission', 'motor' => 'Motor Insurance Commission' }

    recent_payouts.each do |payout|
      policy = case payout.policy_type
               when 'health' then health_by_id[payout.policy_id]
               when 'life'   then life_by_id[payout.policy_id]
               when 'motor'  then motor_by_id[payout.policy_id]
               end

      next unless policy

      activities << {
        type: type_labels[payout.policy_type],
        description: "Commission from #{policy.customer.display_name}",
        amount: payout.payout_amount,
        policy_number: policy.policy_number,
        date: payout.payout_date || policy.created_at,
        status: payout.status
      }
    end

    activities
  end

  def get_monthly_commission_trends
    affiliate_ids = @assigned_affiliates.pluck(:id)
    range_start = 5.months.ago.beginning_of_month
    range_end   = Time.current.end_of_month

    # One query per policy type covering the whole 6-month window instead of
    # 3 queries per month (18 total), plus batched commission sums instead
    # of a CommissionPayout query per policy type per month.
    health = HealthInsurance.where(sub_agent_id: affiliate_ids, created_at: range_start..range_end).select(:id, :created_at).to_a
    life   = LifeInsurance.where(sub_agent_id: affiliate_ids, created_at: range_start..range_end).select(:id, :created_at).to_a
    motor  = MotorInsurance.where(sub_agent_id: affiliate_ids, created_at: range_start..range_end).select(:id, :created_at).to_a

    h_comm = CommissionPayout.where(policy_type: 'health', policy_id: health.map(&:id), payout_to: 'ambassador').group(:policy_id).sum(:payout_amount)
    l_comm = CommissionPayout.where(policy_type: 'life',   policy_id: life.map(&:id),   payout_to: 'ambassador').group(:policy_id).sum(:payout_amount)
    m_comm = CommissionPayout.where(policy_type: 'motor',  policy_id: motor.map(&:id),  payout_to: 'ambassador').group(:policy_id).sum(:payout_amount)

    trends = {}
    6.times do |i|
      month = i.months.ago
      month_key = month.strftime("%Y-%m")
      month_range = month.beginning_of_month..month.end_of_month

      h_this_month = health.select { |p| month_range.cover?(p.created_at) }
      l_this_month = life.select   { |p| month_range.cover?(p.created_at) }
      m_this_month = motor.select  { |p| month_range.cover?(p.created_at) }

      monthly_commission = h_this_month.sum { |p| h_comm[p.id].to_f } +
                            l_this_month.sum { |p| l_comm[p.id].to_f } +
                            m_this_month.sum { |p| m_comm[p.id].to_f }

      trends[month_key] = {
        month: month.strftime("%B %Y"),
        commission: monthly_commission,
        policies_count: h_this_month.size + l_this_month.size + m_this_month.size
      }
    end

    trends.sort_by { |k, v| k }.reverse.to_h
  end

  def get_filtered_commission_data
    # This would contain detailed commission breakdown logic
    # For now, return empty relation
    Payout.none
  end

  def get_ambassador_payouts
    # Get payouts related to this ambassador/distributor
    if defined?(DistributorPayout)
      DistributorPayout.where(distributor_id: @distributor.id)
    else
      Payout.none
    end
  end

  def get_total_policies_count
    health_count = HealthInsurance.where(sub_agent_id: @assigned_affiliates.pluck(:id)).count
    life_count = LifeInsurance.where(sub_agent_id: @assigned_affiliates.pluck(:id)).count
    motor_count = MotorInsurance.where(sub_agent_id: @assigned_affiliates.pluck(:id)).count

    health_count + life_count + motor_count
  end
end