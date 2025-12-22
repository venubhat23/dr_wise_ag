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
      client_requests_count: @client_requests_count,
      commissions_due: @commissions_due,
      support_tickets: @support_tickets,
      total_customers: @total_customers,
      total_agents: @total_agents,
      total_policies: @total_policies,
      total_premium_collected: @total_premium_collected,
      pending_payouts: @pending_payouts,
      renewal_due_count: @renewal_due_count,
      new_leads: @new_leads,
      last_updated: Time.current.strftime('%H:%M:%S')
    }
  end

  private

  def load_dashboard_data
    # Summary statistics with real data
    @total_customers = Customer.count
    @total_agents = User.where(user_type: ['agent', 'sub_agent']).count
    @total_policies = HealthInsurance.count + LifeInsurance.count + MotorInsurance.count + OtherInsurance.count

    # Calculate total premium from all insurance types
    health_premium = HealthInsurance.sum(:total_premium) || 0
    life_premium = LifeInsurance.sum(:total_premium) || 0
    motor_premium = MotorInsurance.sum(:total_premium) || 0
    # OtherInsurance doesn't have total_premium, get from associated policies
    other_premium = 0
    @total_premium_collected = health_premium + life_premium + motor_premium + other_premium

    # Calculate total sum insured
    health_sum = HealthInsurance.sum(:sum_insured) || 0
    life_sum = LifeInsurance.sum(:sum_insured) || 0
    motor_sum = MotorInsurance.sum(:sum_insured) || 0  # Changed from insured_declared_value to sum_insured
    # OtherInsurance doesn't have sum_insured
    other_sum = 0
    @total_sum_insured = health_sum + life_sum + motor_sum + other_sum

    @total_leads = Lead.count

    # Count renewals due (policies expiring within 30 days)
    thirty_days_from_now = Date.current + 30.days
    @renewal_due_count = HealthInsurance.where('policy_end_date <= ?', thirty_days_from_now).count +
                         LifeInsurance.where('policy_end_date <= ?', thirty_days_from_now).count +
                         MotorInsurance.where('policy_end_date <= ?', thirty_days_from_now).count +
                         OtherInsurance.where('policy_end_date <= ?', thirty_days_from_now).count

    # Pending payouts calculation
    @pending_payouts = CommissionPayout.where(status: 'pending').sum(:payout_amount) || 0
    @pending_payouts += DistributorPayout.where(status: 'pending').sum(:payout_amount) || 0

    # Policy type distribution for chart
    @policy_type_distribution = {
      'Health Insurance' => HealthInsurance.count,
      'Life Insurance' => LifeInsurance.count,
      'Motor Insurance' => MotorInsurance.count,
      'Other Insurance' => OtherInsurance.count
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
end
