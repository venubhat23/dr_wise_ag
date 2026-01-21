class Admin::Reports::LeadsReportsController < Admin::Reports::BaseController
  def index
    @leads = Lead.includes(:customer, :sub_agent)

    # Apply filters
    @leads = apply_date_filters(@leads, :created_date)
    @leads = apply_search_filters(@leads, ['name', 'contact_number', 'email'])
    @leads = @leads.where(current_stage: params[:stage]) if params[:stage].present?
    @leads = @leads.where(product_subcategory: params[:product_type]) if params[:product_type].present?
    @leads = @leads.where(customer_type: params[:customer_type]) if params[:customer_type].present?
    @leads = @leads.where('affiliate_id = ?', params[:affiliate_id]) if params[:affiliate_id].present?

    # Lead source filter
    if params[:source].present?
      case params[:source]
      when 'direct'
        @leads = @leads.where(is_direct: true)
      when 'affiliate'
        @leads = @leads.where(is_direct: false)
      end
    end

    # Statistics
    @statistics = calculate_lead_statistics(@leads)

    # Paginate
    @leads = paginate_results(@leads)

    respond_to do |format|
      format.html
      format.csv { export_to_csv(@leads, 'leads_report') }
    end
  end

  def export
    redirect_to admin_reports_leads_reports_path(format: :csv)
  end

  private

  def calculate_lead_statistics(leads)
    total_leads = leads.count

    {
      total_leads: total_leads,
      by_stage: leads.group(:current_stage).count,
      by_product_type: leads.group(:product_subcategory).count,
      by_customer_type: leads.group(:customer_type).count,
      by_source: {
        'Direct' => leads.where(is_direct: true).count,
        'Affiliate' => leads.where(is_direct: false).count
      },
      conversion_stats: {
        converted: leads.where(current_stage: 'policy_created').count,
        in_progress: leads.where.not(current_stage: ['policy_created', 'lost', 'cancelled']).count,
        lost: leads.where(current_stage: 'lost').count,
        cancelled: leads.where(current_stage: 'cancelled').count
      },
      monthly_trend: leads.group_by_month(:created_date, last: 12).count,
      affiliate_performance: leads.joins(:sub_agent)
                                .group('sub_agents.display_name')
                                .count
                                .sort_by { |k, v| -v }
                                .first(10)
                                .to_h
    }
  end
end