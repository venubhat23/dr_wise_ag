class Admin::ReportsController < Admin::ApplicationController

  # GET /admin/reports/commission
  def commission
    @date_range = params[:date_range] || '30_days'

    case @date_range
    when '7_days'
      start_date = 7.days.ago
    when '30_days'
      start_date = 30.days.ago
    when '3_months'
      start_date = 3.months.ago
    when '6_months'
      start_date = 6.months.ago
    when '1_year'
      start_date = 1.year.ago
    else
      start_date = 30.days.ago
    end

    # Commission calculations would go here
    # This is a placeholder implementation
    @total_commission = Policy.where(created_at: start_date..Time.current).sum(:total_premium) * 0.1 rescue 0
    @commission_by_agent = User.where(user_type: ['agent', 'sub_agent'])
                               .joins(:policies)
                               .where(policies: { created_at: start_date..Time.current })
                               .group('users.first_name', 'users.last_name')
                               .sum('policies.total_premium * 0.1') rescue {}
  end

  # GET /admin/reports/expired_insurance
  def expired_insurance
    @expired_policies = Policy.where('end_date < ?', Date.current)
                              .includes(:customer, :insurance_company)
                              .order(:end_date) rescue []
  end

  # GET /admin/reports/payment_due
  def payment_due
    # Logic for payment due reports
    @payment_due_policies = Policy.active
                                  .where('end_date > ? AND end_date <= ?', Date.current, 30.days.from_now)
                                  .includes(:customer)
                                  .order(:end_date) rescue []
  end

  # GET /admin/reports/upcoming_renewal
  def upcoming_renewal
    @renewal_policies = Policy.where('end_date BETWEEN ? AND ?', Date.current, 60.days.from_now)
                              .includes(:customer, :insurance_company)
                              .order(:end_date) rescue []
  end

  # GET /admin/reports/upcoming_payment
  def upcoming_payment
    @upcoming_payments = Policy.active
                               .where('end_date BETWEEN ? AND ?', Date.current, 30.days.from_now)
                               .includes(:customer)
                               .order(:end_date) rescue []
  end

  # GET /admin/reports/leads
  def leads
    @date_range = params[:date_range] || '30_days'

    case @date_range
    when '7_days'
      start_date = 7.days.ago
    when '30_days'
      start_date = 30.days.ago
    when '3_months'
      start_date = 3.months.ago
    when '6_months'
      start_date = 6.months.ago
    when '1_year'
      start_date = 1.year.ago
    else
      start_date = 30.days.ago
    end

    @leads_data = {
      total_leads: Lead.where(created_date: start_date..Time.current).count,
      conversion_rate: 0
    }

    if Lead.column_names.include?('current_stage')
      @leads_by_stage = Lead.where(created_date: start_date..Time.current)
                           .group(:current_stage)
                           .count
    else
      @leads_by_stage = {}
    end
  rescue
    @leads_data = { total_leads: 0, conversion_rate: 0 }
    @leads_by_stage = {}
  end

  # GET /admin/reports/sessions
  def sessions
    # User session analytics would go here
    @active_users = User.active.count
    @total_sessions = User.count # Placeholder
    @session_data = {
      today: 0,
      this_week: 0,
      this_month: 0
    }
  end
end