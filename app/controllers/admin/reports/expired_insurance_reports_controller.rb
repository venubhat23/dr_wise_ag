class Admin::Reports::ExpiredInsuranceReportsController < Admin::Reports::BaseController
  def index
    # Combine all insurance types
    @expired_policies = []

    # Health Insurance
    health_policies = HealthInsurance.includes(:customer, :sub_agent)
                                   .where('policy_end_date < ?', Date.current)
    @expired_policies += health_policies.map { |p| format_policy_data(p, 'Health') }

    # Motor Insurance
    motor_policies = MotorInsurance.includes(:customer, :sub_agent)
                                 .where('policy_end_date < ?', Date.current)
    @expired_policies += motor_policies.map { |p| format_policy_data(p, 'Motor') }

    # Life Insurance
    life_policies = LifeInsurance.includes(:customer, :sub_agent)
                               .where('policy_end_date < ?', Date.current)
    @expired_policies += life_policies.map { |p| format_policy_data(p, 'Life') }

    # Apply filters
    @expired_policies = filter_expired_policies(@expired_policies)

    # Statistics
    @statistics = {
      total_expired: @expired_policies.count,
      by_type: @expired_policies.group_by { |p| p[:insurance_type] }.transform_values(&:count),
      total_premium_lost: @expired_policies.sum { |p| p[:total_premium] },
      expiry_ranges: {
        'Last 30 days' => @expired_policies.count { |p| p[:days_expired] <= 30 },
        'Last 90 days' => @expired_policies.count { |p| p[:days_expired] <= 90 },
        'Last year' => @expired_policies.count { |p| p[:days_expired] <= 365 },
        'More than 1 year' => @expired_policies.count { |p| p[:days_expired] > 365 }
      }
    }

    # Paginate manually
    @expired_policies = Kaminari.paginate_array(@expired_policies).page(params[:page]).per(50)

    respond_to do |format|
      format.html
      format.csv { export_expired_policies_csv }
    end
  end

  def export
    # Similar to index but for CSV export
    redirect_to admin_reports_expired_insurance_reports_path(format: :csv)
  end

  private

  def format_policy_data(policy, type)
    {
      id: policy.id,
      insurance_type: type,
      policy_number: policy.policy_number,
      customer_name: policy.customer&.display_name || 'Unknown',
      customer_email: policy.customer&.email,
      customer_mobile: policy.customer&.mobile,
      policy_end_date: policy.policy_end_date,
      days_expired: (Date.current - policy.policy_end_date).to_i,
      total_premium: policy.total_premium || 0,
      sum_insured: policy.try(:sum_insured) || policy.try(:total_idv) || 0,
      affiliate: policy.sub_agent&.display_name || 'Self',
      policy_object: policy
    }
  end

  def filter_expired_policies(policies)
    # Filter by insurance type
    policies = policies.select { |p| p[:insurance_type] == params[:insurance_type] } if params[:insurance_type].present?

    # Filter by expiry range
    if params[:expiry_range].present?
      case params[:expiry_range]
      when 'last_30_days'
        policies = policies.select { |p| p[:days_expired] <= 30 }
      when 'last_90_days'
        policies = policies.select { |p| p[:days_expired] <= 90 }
      when 'last_year'
        policies = policies.select { |p| p[:days_expired] <= 365 }
      when 'more_than_year'
        policies = policies.select { |p| p[:days_expired] > 365 }
      end
    end

    # Filter by search
    if params[:search].present?
      search_term = params[:search].downcase
      policies = policies.select do |p|
        p[:customer_name].downcase.include?(search_term) ||
        p[:policy_number].downcase.include?(search_term) ||
        p[:customer_email]&.downcase&.include?(search_term)
      end
    end

    policies
  end

  def export_expired_policies_csv
    require 'csv'

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['Policy Number', 'Insurance Type', 'Customer Name', 'Customer Email',
             'Customer Mobile', 'Policy End Date', 'Days Expired', 'Total Premium',
             'Sum Insured', 'Affiliate']

      @expired_policies.each do |policy|
        csv << [
          policy[:policy_number], policy[:insurance_type], policy[:customer_name],
          policy[:customer_email], policy[:customer_mobile], policy[:policy_end_date],
          policy[:days_expired], policy[:total_premium], policy[:sum_insured],
          policy[:affiliate]
        ]
      end
    end

    send_data csv_data,
      filename: "expired_insurance_report_#{Date.current.strftime('%Y%m%d')}.csv",
      type: 'text/csv',
      disposition: 'attachment'
  end
end