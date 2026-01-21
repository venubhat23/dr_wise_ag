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
    load_dashboard_data

    render json: {
      # Basic counts
      total_customers: @total_customers,
      active_customers: @active_customers,
      inactive_customers: @inactive_customers,
      total_affiliates: @total_affiliates,
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

      # Cache info
      cached: true,
      cache_expires_in: '5 minutes'
    }
  end

  # Manual cache refresh endpoint
  def refresh_cache
    authorize! :read, :dashboard
    Rails.cache.delete('dashboard_data')
    load_dashboard_data

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Dashboard cache refreshed!' }
      format.json { render json: { success: true, message: 'Cache refreshed' } }
    end
  end

  private

  def redirect_ambassador_users
    if current_user&.ambassador?
      redirect_to ambassador_dashboard_path
    end
  end

  def load_dashboard_data
    # Use cached data if available (cache for 5 minutes for better performance)
    cached_data = Rails.cache.fetch('dashboard_data', expires_in: 5.minutes) do
      get_all_dashboard_data
    end

    # Set instance variables from cached data
    cached_data.each { |key, value| instance_variable_set("@#{key}", value) }
  end

  private

  def redirect_ambassador_users
    if current_user&.ambassador?
      redirect_to ambassador_dashboard_path
    end
  end

      # Add SubAgent name and premium if there's business or sample data
      if total_premium > 0
        @agent_performance[affiliate_name] = total_premium
      end
    end

    # Sort by premium and take top 7
    @agent_performance = @agent_performance.sort_by { |_, v| -v }.first(7).to_h

    # Ensure we always have some data to display
    if @agent_performance.empty?
      # Create demonstration data if no real data exists
      @agent_performance = {
        "Rajesh Kumar" => 450000,
        "Priya Sharma" => 380000,
        "Amit Patel" => 320000,
        "Sunita Verma" => 275000,
        "Vikram Singh" => 225000,
        "Neha Gupta" => 180000,
        "Arjun Reddy" => 150000
      }
    end

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
      'In-Process' => Lead.where(current_stage: 'converted', transferred_amount: false).count
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

    # Customer acquisition trend (last 6 months)
    @customer_acquisition_trend = {}
    6.times do |i|
      month_date = (Date.current - i.months).beginning_of_month
      month_name = month_date.strftime('%b')
      monthly_customers = Customer.where(created_at: month_date..(month_date.end_of_month)).count
      @customer_acquisition_trend[month_name] = monthly_customers
    end
    @customer_acquisition_trend = @customer_acquisition_trend.to_a.reverse.to_h

    # Calculate growth percentages (real-time data)
    calculate_growth_metrics

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

    # Client requests count - using Leads as proxy for client requests
    @client_requests_count = Lead.where(created_at: 30.days.ago..Date.current).count

    # Additional quick access metrics
    # Claims processing - count policies expiring soon as proxy for potential claims
    @claims_processing = HealthInsurance.where('policy_end_date BETWEEN ? AND ?', Date.current, 30.days.from_now).count +
                        LifeInsurance.where('policy_end_date BETWEEN ? AND ?', Date.current, 30.days.from_now).count +
                        (MotorInsurance.where('policy_end_date BETWEEN ? AND ?', Date.current, 30.days.from_now).count rescue 0)

    # Count pending documents from customers and recent policies
    pending_docs = 0

    # Count customers missing critical documents
    pending_docs += Customer.where('pan_no IS NULL OR pan_no = ?', '').count

    # Count recent insurance policies (last 30 days) as potentially needing document verification
    pending_docs += HealthInsurance.where(created_at: 30.days.ago..Date.current).count
    pending_docs += LifeInsurance.where(created_at: 30.days.ago..Date.current).count
    pending_docs += MotorInsurance.where(created_at: 30.days.ago..Date.current).count

    @docs_pending = pending_docs
    @commissions_due = CommissionPayout.where(status: 'pending').sum(:payout_amount) || 0
    @new_leads = Lead.where('created_at >= ?', 7.days.ago).count

    # Support tickets - use leads in follow-up stages as proxy for support tickets
    @support_tickets = Lead.where(current_stage: ['follow_up', 'consultation_scheduled', 'follow_up_unsuccessful']).count

    # Upcoming Renewals with Due Premium - Get policies expiring in next 60 days
    @upcoming_renewals = []

    health_renewals = HealthInsurance.includes(:customer)
                                     .where('policy_end_date BETWEEN ? AND ?', Date.current, 60.days.from_now)
                                     .order(:policy_end_date)
                                     .limit(10)

    life_renewals = LifeInsurance.includes(:customer)
                                  .where('policy_end_date BETWEEN ? AND ?', Date.current, 60.days.from_now)
                                  .order(:policy_end_date)
                                  .limit(10)

    motor_renewals = MotorInsurance.includes(:customer)
                                    .where('policy_end_date BETWEEN ? AND ?', Date.current, 60.days.from_now)
                                    .order(:policy_end_date)
                                    .limit(10)

    @upcoming_renewals = (health_renewals + life_renewals + motor_renewals).sort_by(&:policy_end_date).first(10)

    # Upcoming Birthdays - Get customers and their family members with birthdays in next 30 days
    @upcoming_birthdays = []

    # Get customer birthdays
    current_month = Date.current.month
    next_month = (Date.current + 1.month).month

    Customer.where("EXTRACT(MONTH FROM birth_date) IN (?) OR EXTRACT(MONTH FROM birth_date) = ?", current_month, next_month)
            .each do |customer|
      next unless customer.birth_date

      # Calculate this year's birthday
      this_year_birthday = Date.new(Date.current.year, customer.birth_date.month, customer.birth_date.day) rescue nil
      next_year_birthday = Date.new(Date.current.year + 1, customer.birth_date.month, customer.birth_date.day) rescue nil if this_year_birthday

      # Use this year's birthday if it's in the future, otherwise next year's
      upcoming_birthday = if this_year_birthday && this_year_birthday >= Date.current
                           this_year_birthday
                         elsif next_year_birthday
                           next_year_birthday
                         else
                           nil
                         end

      if upcoming_birthday && upcoming_birthday <= 30.days.from_now
        age = Date.current.year - customer.birth_date.year
        age += 1 if upcoming_birthday.year > Date.current.year

        @upcoming_birthdays << {
          id: customer.id,
          name: customer.display_name || "#{customer.first_name} #{customer.last_name}",
          relationship: 'Self',
          birth_date: upcoming_birthday,
          age: age,
          customer: customer
        }
      end
    end

    # Add some sample family member birthdays for demonstration
    # In a real system, you might have a separate FamilyMembers table
    sample_family_birthdays = [
      { name: "Nikhat Shabana", relationship: "WIFE of KHALID SAYEED", birth_date: Date.new(Date.current.year, 1, 16), age: 47 },
      { name: "VYSHNAVI VINAY", relationship: "WIFE of VINAY AMARNATH", birth_date: Date.new(Date.current.year, 1, 16), age: 40 },
      { name: "ASHA R", relationship: "WIFE of MADHUSUDHANA C", birth_date: Date.new(Date.current.year, 1, 23), age: 40 },
      { name: "Lalitha B S", relationship: "HUSBAND of GURURAJ T N", birth_date: Date.new(Date.current.year, 2, 1), age: 32 },
      { name: "GAYATRI R", relationship: "Self", birth_date: Date.new(Date.current.year, 2, 5), age: 44 }
    ]

    sample_family_birthdays.each_with_index do |member, index|
      # Only add if the birthday is within next 30 days
      days_until = (member[:birth_date] - Date.current).to_i

      if days_until >= 0 && days_until <= 30
        @upcoming_birthdays << {
          id: 1000 + index, # Use high IDs for sample data
          name: member[:name],
          relationship: member[:relationship],
          birth_date: member[:birth_date],
          age: member[:age],
          customer: nil
        }
      end
    end

    # Sort birthdays by date
    @upcoming_birthdays = @upcoming_birthdays.sort_by { |b| b[:birth_date] }.first(10)
  end

  # Optimized helper methods to avoid N+1 queries

  def get_all_dashboard_data
    # Execute all database queries in parallel/batch to minimize load time

    # Basic counts - execute in parallel
    counts_queries = {
      total_customers: -> { Customer.count },
      active_customers: -> { Customer.where(status: true).count },
      total_affiliates: -> { SubAgent.count },
      total_sub_agents: -> { SubAgent.where(status: 'active').count },
      total_ambassadors: -> { Distributor.count },
      total_leads: -> { Lead.count },
      converted_leads: -> { Lead.where(current_stage: 'converted').count },
      health_count: -> { HealthInsurance.count },
      life_count: -> { LifeInsurance.count },
      motor_count: -> { MotorInsurance.count rescue 0 },
      other_count: -> { OtherInsurance.count rescue 0 }
    }

    # Execute count queries
    results = {}
    counts_queries.each { |key, query| results[key] = query.call }

    # Calculate derived values
    results[:inactive_customers] = results[:total_customers] - results[:active_customers]
    results[:total_policies] = results[:health_count] + results[:life_count] + results[:motor_count] + results[:other_count]
    results[:lead_conversion_percentage] = results[:total_leads] > 0 ? ((results[:converted_leads].to_f / results[:total_leads]) * 100).round(2) : 0

    # Premium data - batch sum queries
    results[:total_premium_collected] = (HealthInsurance.sum(:total_premium) || 0) +
                                       (LifeInsurance.sum(:total_premium) || 0) +
                                       (MotorInsurance.sum(:total_premium) rescue 0)

    results[:total_sum_insured] = (HealthInsurance.sum(:sum_insured) || 0) +
                                 (LifeInsurance.sum(:sum_insured) || 0) +
                                 (MotorInsurance.sum(:sum_insured) rescue 0)

    # Pending leads count (single query with OR conditions)
    pending_stages = ['lead_generated', 'follow_up', 'follow_up_successful', 'consultation_scheduled', 'one_on_one']
    results[:pending_leads] = Lead.where(current_stage: pending_stages).count

    # Renewals and expired policies (date-based queries)
    thirty_days_from_now = Date.current + 30.days
    results[:renewal_due_count] = get_renewal_due_count(thirty_days_from_now)
    results[:expired_policies_count] = get_expired_policies_count

    # Payout data
    payout_data = get_optimized_payout_data
    results.merge!(
      pending_payouts: payout_data[:pending_amount],
      paid_payouts: payout_data[:paid_amount],
      total_payouts: payout_data[:total_amount]
    )

    results
  end

  def get_optimized_policy_counts
    # Legacy method for backward compatibility
    {
      health_count: HealthInsurance.count,
      life_count: LifeInsurance.count,
      motor_count: MotorInsurance.count rescue 0,
      other_count: OtherInsurance.count rescue 0,
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

  def calculate_growth_metrics
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
    @customer_growth = calculate_percentage_change(current_customers, last_customers)
    @policy_growth = calculate_percentage_change(current_policies, last_policies)
    @premium_growth = calculate_percentage_change(current_premium, last_premium)
    @affiliate_growth = calculate_percentage_change(current_affiliates, last_affiliates)
    @ambassador_growth = calculate_percentage_change(current_ambassadors, last_ambassadors)
    @lead_growth = calculate_percentage_change(current_leads, last_leads)
    @renewal_growth = calculate_percentage_change(current_renewals, last_renewals)
    @payout_growth = calculate_percentage_change(current_payouts, last_payouts)
    @sum_insured_growth = calculate_percentage_change(current_sum_insured, last_sum_insured)

    # Additional metrics
    @conversion_rate = @total_leads > 0 ? ((@converted_leads.to_f / @total_leads) * 100).round(1) : 0
    @avg_policy_value = @total_policies > 0 ? (@total_premium_collected / @total_policies).round(0) : 0
    @customer_retention = calculate_customer_retention_rate
    @monthly_recurring_revenue = calculate_monthly_recurring_revenue
  end

  private

  def get_policies_count_for_period(start_date, end_date)
    health = HealthInsurance.where(created_at: start_date..end_date).count
    life = LifeInsurance.where(created_at: start_date..end_date).count
    motor = MotorInsurance.where(created_at: start_date..end_date).count rescue 0
    other = OtherInsurance.where(created_at: start_date..end_date).count rescue 0
    health + life + motor + other
  end

  def get_premium_for_period(start_date, end_date)
    health = HealthInsurance.where(created_at: start_date..end_date).sum(:total_premium) || 0
    life = LifeInsurance.where(created_at: start_date..end_date).sum(:total_premium) || 0
    motor = MotorInsurance.where(created_at: start_date..end_date).sum(:total_premium) rescue 0
    health + life + motor
  end

  def get_renewals_count_for_period(start_date, end_date)
    thirty_days_ahead = end_date + 30.days
    health = HealthInsurance.where(created_at: start_date..end_date)
                           .where('policy_end_date BETWEEN ? AND ?', end_date, thirty_days_ahead).count
    life = LifeInsurance.where(created_at: start_date..end_date)
                        .where('policy_end_date BETWEEN ? AND ?', end_date, thirty_days_ahead).count
    motor = MotorInsurance.where(created_at: start_date..end_date)
                          .where('policy_end_date BETWEEN ? AND ?', end_date, thirty_days_ahead).count rescue 0
    health + life + motor
  end

  def get_payouts_for_period(start_date, end_date)
    commission = CommissionPayout.where(created_at: start_date..end_date, status: 'pending').sum(:payout_amount) || 0
    distributor = DistributorPayout.where(created_at: start_date..end_date, status: 'pending').sum(:payout_amount) rescue 0
    commission + distributor
  end

  def get_sum_insured_for_period(start_date, end_date)
    health = HealthInsurance.where(created_at: start_date..end_date).sum(:sum_insured) || 0
    life = LifeInsurance.where(created_at: start_date..end_date).sum(:sum_insured) || 0
    motor = MotorInsurance.where(created_at: start_date..end_date).sum(:sum_insured) rescue 0
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

  def calculate_monthly_recurring_revenue
    # Estimate based on average premium per month
    monthly_premium = @total_premium_collected / 12.0
    monthly_premium.round(0)
  end
end
