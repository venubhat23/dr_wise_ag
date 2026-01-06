class DashboardController < ApplicationController
  skip_load_and_authorize_resource

  def index
    authorize! :read, :dashboard
    load_dashboard_data
  end

  def stats
    authorize! :read, :dashboard
    load_dashboard_data

    render json: {
      # Basic counts
      total_customers: @total_customers,
      active_customers: @active_customers,
      inactive_customers: @inactive_customers,
      total_agents: @total_agents,
      total_sub_agents: @total_sub_agents,
      total_policies: @total_policies,

      # Financial data
      total_premium_collected: @total_premium_collected,
      total_sum_insured: @total_sum_insured,
      pending_payouts: @pending_payouts,
      paid_payouts: @paid_payouts,
      total_payouts: @total_payouts,

      # Lead metrics
      total_leads: @total_leads,
      converted_leads: @converted_leads,
      pending_leads: @pending_leads,
      lead_conversion_percentage: @lead_conversion_percentage,

      # Policy status
      renewal_due_count: @renewal_due_count,
      expired_policies_count: @expired_policies_count,

      # Charts data
      policy_type_distribution: @policy_type_distribution,

      # Support
      client_requests_count: @client_requests_count,
      support_tickets: @support_tickets,
      commissions_due: @commissions_due,
      new_leads: @new_leads,

      # Performance metrics
      renewal_status: @renewal_status,
      referral_status: @referral_status,
      customer_location: @customer_location,

      # Timestamp
      last_updated: Time.current.strftime('%Y-%m-%d %H:%M:%S'),
      cache_key: "dashboard_#{Time.current.to_i}"
    }
  end

  private

  def load_dashboard_data
    # Optimize with a single query for basic counts
    policy_counts = get_optimized_policy_counts

    # Summary statistics with real data
    @total_customers = Customer.count
    @total_agents = User.where(user_type: ['agent', 'sub_agent']).count
    @total_sub_agents = SubAgent.where(status: 'active').count
    @total_policies = policy_counts[:total_count]

    # Calculate totals from optimized queries
    premium_data = get_optimized_premium_data
    @total_premium_collected = premium_data[:total_premium]
    @total_sum_insured = premium_data[:total_sum_insured]

    # Additional real-time metrics
    @active_customers = Customer.where(status: true).count
    @inactive_customers = @total_customers - @active_customers

    @total_leads = Lead.count
    @converted_leads = Lead.where(current_stage: ['converted', 'policy_created']).count
    @pending_leads = Lead.where(current_stage: ['new', 'contacted', 'consultation', 'one_on_one']).count

    # Lead conversion percentage
    @lead_conversion_percentage = @total_leads > 0 ? ((@converted_leads.to_f / @total_leads) * 100).round(2) : 0

    # Count renewals due (policies expiring within 30 days) - optimized
    thirty_days_from_now = Date.current + 30.days
    @renewal_due_count = get_renewal_due_count(thirty_days_from_now)

    # Expired policies count
    @expired_policies_count = get_expired_policies_count

    # Pending payouts calculation - optimized
    payout_data = get_optimized_payout_data
    @pending_payouts = payout_data[:pending_amount]
    @paid_payouts = payout_data[:paid_amount]
    @total_payouts = payout_data[:total_amount]

    # Policy type distribution for chart with percentages
    @policy_type_distribution = {
      'Health Insurance' => {
        count: policy_counts[:health_count],
        percentage: policy_counts[:total_count] > 0 ? ((policy_counts[:health_count].to_f / policy_counts[:total_count]) * 100).round(2) : 0
      },
      'Life Insurance' => {
        count: policy_counts[:life_count],
        percentage: policy_counts[:total_count] > 0 ? ((policy_counts[:life_count].to_f / policy_counts[:total_count]) * 100).round(2) : 0
      },
      'Motor Insurance' => {
        count: policy_counts[:motor_count],
        percentage: policy_counts[:total_count] > 0 ? ((policy_counts[:motor_count].to_f / policy_counts[:total_count]) * 100).round(2) : 0
      },
      'Other Insurance' => {
        count: policy_counts[:other_count],
        percentage: policy_counts[:total_count] > 0 ? ((policy_counts[:other_count].to_f / policy_counts[:total_count]) * 100).round(2) : 0
      }
    }

    # Premium collection trend by month (last 12 months)
    @premium_collection_trend = {}
    12.times do |i|
      month_date = (Date.current - i.months).beginning_of_month
      month_name = month_date.strftime('%b')

      monthly_premium = HealthInsurance.where(created_at: month_date..(month_date.end_of_month)).sum(:total_premium) +
                        LifeInsurance.where(created_at: month_date..(month_date.end_of_month)).sum(:total_premium) +
                        MotorInsurance.where(created_at: month_date..(month_date.end_of_month)).sum(:total_premium)
                        # OtherInsurance doesn't have total_premium column

      @premium_collection_trend[month_name] = monthly_premium
    end
    @premium_collection_trend = @premium_collection_trend.to_a.reverse.to_h

    # Lead conversion funnel
    @lead_conversion_funnel = {
      'Leads Generated' => Lead.count,
      'Consultation' => Lead.where(current_stage: 'consultation').count,
      'One-on-One' => Lead.where(current_stage: 'one_on_one').count,
      'Converted' => Lead.where(current_stage: 'converted').count,
      'Policy Created' => Lead.where(current_stage: 'policy_created').count
    }

    # Agent performance - top agents by premium
    @agent_performance = {}

    # Get top sub agents by name from customers table
    agent_names = Customer.where.not(sub_agent: ['Self', nil, '']).group(:sub_agent).count.keys

    agent_names.first(10).each do |agent_name|
      # Calculate total premium from all insurance types for customers with this agent
      customer_ids = Customer.where(sub_agent: agent_name).pluck(:id)

      if customer_ids.any?
        total_agent_premium = HealthInsurance.where(customer_id: customer_ids).sum(:total_premium) +
                             LifeInsurance.where(customer_id: customer_ids).sum(:total_premium) +
                             MotorInsurance.where(customer_id: customer_ids).sum(:total_premium)
                             # OtherInsurance doesn't have total_premium column

        @agent_performance[agent_name] = total_agent_premium if total_agent_premium > 0
      end
    end
    @agent_performance = @agent_performance.sort_by { |_, v| -v }.first(7).to_h

    # Renewal status overview
    expired_policies = HealthInsurance.where('policy_end_date < ?', Date.current).count +
                      LifeInsurance.where('policy_end_date < ?', Date.current).count +
                      MotorInsurance.where('policy_end_date < ?', Date.current).count +
                      OtherInsurance.where('policy_end_date < ?', Date.current).count

    renewed_policies = HealthInsurance.where(policy_type: 'renewal').count +
                      LifeInsurance.where(policy_type: 'renewal').count +
                      MotorInsurance.where(policy_type: 'renewal').count
                      # OtherInsurance doesn't have policy_type column

    @renewal_status = {
      'Renewed' => renewed_policies,
      'Pending' => @renewal_due_count,
      'Expired' => expired_policies
    }

    # Referral settlement status
    @referral_status = {
      'Paid' => Lead.where(transferred_amount: true).count,
      'Pending' => Lead.where(current_stage: 'converted', transferred_amount: false).count,
      'In-Process' => Lead.where(current_stage: 'policy_created', transferred_amount: false).count
    }

    # Commission summary by month
    @commission_summary = {
      'main_agent' => {},
      'sub_agent' => {},
      'tds' => {}
    }

    12.times do |i|
      month_date = (Date.current - i.months).beginning_of_month
      month_name = month_date.strftime('%b')

      # Get commission data from commission payouts
      main_commission = CommissionPayout.where(
        created_at: month_date..(month_date.end_of_month),
        payout_to: 'main_agent'
      ).sum(:payout_amount)

      sub_commission = CommissionPayout.where(
        created_at: month_date..(month_date.end_of_month),
        payout_to: 'sub_agent'
      ).sum(:payout_amount)

      # Calculate TDS (assuming 10% for demonstration)
      total_commission = main_commission + sub_commission
      tds_amount = total_commission * 0.1

      @commission_summary['main_agent'][month_name] = main_commission
      @commission_summary['sub_agent'][month_name] = sub_commission
      @commission_summary['tds'][month_name] = tds_amount
    end

    # Customer geographic distribution
    @customer_location = Customer.group(:state).count.sort_by { |_, v| -v }.first(8).to_h

    # Recent activities for display
    @recent_policies = []
    recent_health = HealthInsurance.includes(:customer).order(created_at: :desc).limit(2)
    recent_life = LifeInsurance.includes(:customer).order(created_at: :desc).limit(2)
    recent_motor = MotorInsurance.includes(:customer).order(created_at: :desc).limit(1)

    @recent_policies = (recent_health + recent_life + recent_motor).sort_by(&:created_at).reverse.first(5)

    @recent_customers = Customer.order(created_at: :desc).limit(5)
    @recent_leads = Lead.order(created_at: :desc).limit(5)

    # Policies expiring soon for renewal section
    @renewal_policies = []
    health_renewals = HealthInsurance.includes(:customer)
                                    .where('policy_end_date BETWEEN ? AND ?', Date.current, thirty_days_from_now)
                                    .order(:policy_end_date)
                                    .limit(5)
    life_renewals = LifeInsurance.includes(:customer)
                                 .where('policy_end_date BETWEEN ? AND ?', Date.current, thirty_days_from_now)
                                 .order(:policy_end_date)
                                 .limit(5)
    motor_renewals = MotorInsurance.includes(:customer)
                                   .where('policy_end_date BETWEEN ? AND ?', Date.current, thirty_days_from_now)
                                   .order(:policy_end_date)
                                   .limit(5)

    @renewal_policies = (health_renewals + life_renewals + motor_renewals).sort_by(&:policy_end_date).first(10)

    # Expired policies for expired section
    @expired_policies = []
    health_expired = HealthInsurance.includes(:customer)
                                   .where('policy_end_date < ?', Date.current)
                                   .order(policy_end_date: :desc)
                                   .limit(5)
    life_expired = LifeInsurance.includes(:customer)
                                .where('policy_end_date < ?', Date.current)
                                .order(policy_end_date: :desc)
                                .limit(5)
    motor_expired = MotorInsurance.includes(:customer)
                                  .where('policy_end_date < ?', Date.current)
                                  .order(policy_end_date: :desc)
                                  .limit(5)

    @expired_policies = (health_expired + life_expired + motor_expired).sort_by(&:policy_end_date).reverse.first(10)

    # Client requests count (if ClientRequest model exists)
    @client_requests_count = ClientRequest.count

    # Additional quick access metrics
    @claims_processing = 0  # Will be updated when claims model is available

    # Count pending documents from all insurance types and customers
    pending_docs = 0
    pending_docs += Customer.joins(:documents).count rescue 0
    pending_docs += HealthInsurance.count rescue 0  # Assuming each needs document verification
    pending_docs += LifeInsurance.count rescue 0
    pending_docs += MotorInsurance.count rescue 0
    @docs_pending = pending_docs

    @commissions_due = CommissionPayout.where(status: 'pending').sum(:payout_amount) || 0
    @new_leads = Lead.where('created_at >= ?', 7.days.ago).count

    # Use ClientRequest as support tickets - count unresolved requests
    @support_tickets = ClientRequest.where(status: ['pending', 'in_progress']).count
  end

  # Optimized helper methods to avoid N+1 queries

  def get_optimized_policy_counts
    # Single query to get all policy counts
    health_count = HealthInsurance.count
    life_count = LifeInsurance.count
    motor_count = MotorInsurance.count rescue 0
    other_count = OtherInsurance.count rescue 0

    {
      health_count: health_count,
      life_count: life_count,
      motor_count: motor_count,
      other_count: other_count,
      total_count: health_count + life_count + motor_count + other_count
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
    # Single query for renewal counts
    health_renewals = HealthInsurance.where('policy_end_date BETWEEN ? AND ?', Date.current, thirty_days_from_now).count
    life_renewals = LifeInsurance.where('policy_end_date BETWEEN ? AND ?', Date.current, thirty_days_from_now).count

    motor_renewals = begin
      MotorInsurance.where('policy_end_date BETWEEN ? AND ?', Date.current, thirty_days_from_now).count
    rescue
      0
    end

    other_renewals = begin
      OtherInsurance.where('policy_end_date BETWEEN ? AND ?', Date.current, thirty_days_from_now).count
    rescue
      0
    end

    health_renewals + life_renewals + motor_renewals + other_renewals
  end

  def get_expired_policies_count
    # Single query for expired policies
    health_expired = HealthInsurance.where('policy_end_date < ?', Date.current).count
    life_expired = LifeInsurance.where('policy_end_date < ?', Date.current).count

    motor_expired = begin
      MotorInsurance.where('policy_end_date < ?', Date.current).count
    rescue
      0
    end

    other_expired = begin
      OtherInsurance.where('policy_end_date < ?', Date.current).count
    rescue
      0
    end

    health_expired + life_expired + motor_expired + other_expired
  end

  def get_optimized_payout_data
    # Optimized payout queries
    commission_pending = CommissionPayout.where(status: 'pending').sum(:payout_amount) || 0
    commission_paid = CommissionPayout.where(status: 'paid').sum(:payout_amount) || 0
    commission_total = CommissionPayout.sum(:payout_amount) || 0

    distributor_pending = begin
      DistributorPayout.where(status: 'pending').sum(:payout_amount) || 0
    rescue
      0
    end

    distributor_paid = begin
      DistributorPayout.where(status: 'paid').sum(:payout_amount) || 0
    rescue
      0
    end

    distributor_total = begin
      DistributorPayout.sum(:payout_amount) || 0
    rescue
      0
    end

    {
      pending_amount: commission_pending + distributor_pending,
      paid_amount: commission_paid + distributor_paid,
      total_amount: commission_total + distributor_total
    }
  end
end
