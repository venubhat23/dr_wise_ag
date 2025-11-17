class DashboardController < ApplicationController
  skip_load_and_authorize_resource

  def index
    authorize! :read, :dashboard

    # Summary statistics
    @total_customers = Customer.active.count
    @total_agents = User.where(user_type: ['agent', 'sub_agent']).active.count
    @total_policies = Policy.active.count
    @total_premium_collected = Policy.active.sum(:total_premium)
    @total_sum_insured = Policy.active.sum(:sum_insured)
    @total_leads = Lead.count
    @renewal_due_count = Policy.expiring_soon.count
    @pending_referral_payouts = Lead.where(current_stage: 'converted').count

    # Charts data
    @policy_type_distribution = Policy.active.group(:insurance_type).count
    @premium_collection_trend = Policy.active
                                      .where(created_at: 12.months.ago..Time.current)
                                      .group_by_month(:created_at)
                                      .sum(:total_premium)

    @lead_conversion_funnel = {
      'Leads Generated' => Lead.count,
      'Consultation' => Lead.consultation.count,
      'One-on-One' => Lead.one_on_one.count,
      'Converted to Customer' => Lead.converted.count,
      'Policy Created' => Lead.policy_created.count
    }

    @agent_performance = User.where(user_type: ['agent', 'sub_agent'])
                            .joins(:policies)
                            .group('users.first_name', 'users.last_name')
                            .sum('policies.total_premium')
                            .first(10)

    @renewal_status = {
      'Renewed' => Policy.where(policy_type: 'renewal').count,
      'Pending' => Policy.expiring_soon.count,
      'Expired' => Policy.expired.count
    }

    # Recent activities
    @recent_policies = Policy.active.includes(:customer, :insurance_company)
                             .order(created_at: :desc).limit(5)
    @recent_customers = Customer.active.order(created_at: :desc).limit(5)
    @recent_leads = Lead.order(created_date: :desc).limit(5)
  end
end
