class Admin::Reports::CommissionReportsController < Admin::Reports::BaseController
  def index
    @commission_payouts = CommissionPayout.all

    # Apply filters
    @commission_payouts = apply_date_filters(@commission_payouts, :created_at)
    @commission_payouts = apply_basic_search(@commission_payouts) if params[:search].present?
    @commission_payouts = @commission_payouts.where(payout_to: params[:payout_to]) if params[:payout_to].present?
    @commission_payouts = @commission_payouts.where(policy_type: params[:policy_type]) if params[:policy_type].present?
    @commission_payouts = @commission_payouts.where(status: params[:status]) if params[:status].present?

    # Statistics
    @statistics = calculate_commission_statistics(@commission_payouts)

    # Paginate
    @commission_payouts = paginate_results(@commission_payouts)

    respond_to do |format|
      format.html
      format.csv { export_commission_csv }
    end
  end

  def export
    redirect_to admin_reports_commission_reports_path(format: :csv, **params.permit!)
  end

  def generate
    # Show the generate form page
  end

  def create_report
    filters = {
      start_date: params[:start_date].present? ? Date.parse(params[:start_date]) : 1.month.ago.to_date,
      end_date: params[:end_date].present? ? Date.parse(params[:end_date]) : Date.current,
      payout_to: params[:payout_to],
      policy_type: params[:policy_type],
      status: params[:status]
    }.compact

    report_name = params[:report_name].presence || "Commission Report #{Date.current.strftime('%d %b %Y')}"

    # Generate report data
    report_data = Report.generate_detailed_commission_report(filters)

    # Save the report
    @report = Report.new(
      name: report_name,
      report_type: 'commission',
      filters: filters,
      report_data: report_data,
      status: true,
      generated_at: Time.current,
      created_by: current_user
    )

    if @report.save
      redirect_to saved_reports_admin_reports_commission_reports_path,
                  notice: 'Commission report generated and saved successfully!'
    else
      render :generate, status: :unprocessable_entity
    end
  end

  def saved_reports
    @saved_reports = Report.where(report_type: 'commission')
                           .includes(:created_by)
                           .recent
                           .page(params[:page])
                           .per(10)
  end

  def show_saved_report
    @report = Report.find(params[:id])
    @report_data = @report.report_data
    @statistics = @report_data['statistics']
    @payouts = @report_data['payouts']
  end

  def destroy_saved_report
    @report = Report.find(params[:id])
    @report.destroy
    redirect_to saved_reports_admin_reports_commission_reports_path,
                notice: 'Report deleted successfully!'
  end

  private

  def apply_basic_search(scope)
    search_term = "%#{params[:search]}%"
    # Search by transaction_id, reference_number, or notes since these are searchable fields
    scope.where("transaction_id ILIKE ? OR reference_number ILIKE ? OR notes ILIKE ?",
                search_term, search_term, search_term)
  end

  def calculate_commission_statistics(payouts)
    total_commission = payouts.sum(:payout_amount) || 0

    # Calculate total TDS using the model methods
    total_tds = payouts.to_a.sum { |payout| payout.tds_amount || 0 }

    {
      total_records: payouts.count,
      total_commission: total_commission,
      total_tds: total_tds,
      net_payout: total_commission - total_tds,
      by_type: payouts.group(:payout_to).sum(:payout_amount),
      by_policy_type: payouts.group(:policy_type).sum(:payout_amount),
      by_status: payouts.group(:status).count,
      date_range: {
        start_date: params[:start_date] || 1.month.ago.to_date,
        end_date: params[:end_date] || Date.current
      }
    }
  end

  def export_commission_csv
    require 'csv'

    # Get all commission payouts for export
    payouts = CommissionPayout.all
    payouts = apply_date_filters(payouts, :created_at)
    payouts = apply_basic_search(payouts) if params[:search].present?
    payouts = payouts.where(payout_to: params[:payout_to]) if params[:payout_to].present?
    payouts = payouts.where(policy_type: params[:policy_type]) if params[:policy_type].present?
    payouts = payouts.where(status: params[:status]) if params[:status].present?

    csv_data = CSV.generate(headers: true) do |csv|
      csv << [
        'Policy Number', 'Policy Type', 'Customer Name', 'Recipient Type',
        'Recipient Name', 'Commission Amount', 'TDS Amount', 'Net Amount',
        'Status', 'Payout Date', 'Transaction ID', 'Reference Number'
      ]

      payouts.find_each do |payout|
        csv << [
          payout.policy_number,
          payout.policy_type.humanize,
          payout.customer_name,
          payout.payout_to.humanize,
          payout.recipient_name,
          payout.payout_amount || 0,
          payout.tds_amount || 0,
          payout.net_amount || 0,
          payout.status.humanize,
          payout.payout_date,
          payout.transaction_id,
          payout.reference_number
        ]
      end
    end

    send_data csv_data,
      filename: "commission_report_#{Date.current.strftime('%Y%m%d')}.csv",
      type: 'text/csv',
      disposition: 'attachment'
  end
end