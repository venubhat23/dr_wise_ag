class Admin::Reports::ExpiredInsuranceReportsController < Admin::Reports::BaseController
  include ActionView::Helpers::NumberHelper

  def index
    # Check for pending download and trigger it
    if session[:pending_download].present?
      download_data = session[:pending_download]
      session.delete(:pending_download)

      # Generate the file data
      case download_data['format']
      when 'csv'
        csv_data = generate_csv_from_data(download_data['report_data'], download_data['report_name'], download_data['filters'])

        respond_to do |format|
          format.html do
            send_data csv_data,
              filename: "#{download_data['report_name'].parameterize}_#{Date.current.strftime('%Y%m%d')}.csv",
              type: 'text/csv',
              disposition: 'attachment'
          end
        end
        return
      end
    end

    # Normal index page rendering
    # Get saved reports for the listing
    @saved_reports = Report.where(report_type: 'expired_insurance')
                           .includes(:created_by)
                           .order(created_at: :desc)
                           .page(params[:page])
                           .per(10)

    # Calculate statistics
    @total_reports = Report.where(report_type: 'expired_insurance').count
    @this_month_reports = Report.where(report_type: 'expired_insurance')
                                .where(created_at: Date.current.beginning_of_month..Date.current.end_of_month)
                                .count
    @last_generated = Report.where(report_type: 'expired_insurance')
                            .maximum(:created_at)
    @total_premium_lost = calculate_total_premium_lost_from_reports

    respond_to do |format|
      format.html
    end
  end

  def generate
    # Show the generate form page
  end

  def preview
    @preview_data = generate_preview_data(preview_params)

    render partial: 'preview_table', layout: false
  end

  def create_report
    filters = {
      start_date: params[:start_date].present? ? Date.parse(params[:start_date]) : 30.days.ago.to_date,
      end_date: params[:end_date].present? ? Date.parse(params[:end_date]) : Date.current,
      policy_type: params[:policy_type].presence,
      status: params[:status].presence
    }.compact

    report_name = params[:report_name].presence || "Expired Insurance Report #{Date.current.strftime('%d %b %Y')}"

    # Generate report data with the same logic as preview
    report_data = generate_detailed_expired_insurance_report(filters)

    # Save to database if requested
    if params[:save_to_database] == "1"
      @report = Report.new(
        name: report_name,
        report_type: 'expired_insurance',
        filters: filters,
        report_data: report_data,
        status: true,
        generated_at: Time.current,
        created_by_id: current_user&.id
      )

      unless @report.save
        flash.now[:alert] = "Failed to save report: #{@report.errors.full_messages.join(', ')}"
        render :generate, status: :unprocessable_entity
        return
      end
    end

    # Set success message based on what was done
    if params[:save_to_database] == "1"
      if params[:export_format] == 'csv'
        flash[:success] = "✅ Success! Report '#{report_name}' has been saved to database and CSV file will download shortly!"
      else
        flash[:success] = "✅ Report '#{report_name}' has been successfully saved to database!"
      end
    else
      if params[:export_format] == 'csv'
        flash[:success] = "✅ CSV file will download shortly!"
      else
        flash[:info] = "Report generated successfully!"
      end
    end

    # Handle export format
    case params[:export_format]
    when 'csv'
      csv_data = generate_csv_from_data(report_data, report_name, filters)

      respond_to do |format|
        format.html do
          send_data csv_data,
            filename: "#{report_name.parameterize}_#{Date.current.strftime('%Y%m%d')}.csv",
            type: 'text/csv',
            disposition: 'attachment'
        end
        format.json do
          send_data csv_data,
            filename: "#{report_name.parameterize}_#{Date.current.strftime('%Y%m%d')}.csv",
            type: 'text/csv',
            disposition: 'attachment'
        end
      end

    else
      # No download, handle based on request type
      respond_to do |format|
        format.html { redirect_to admin_reports_expired_insurance_reports_path }
        format.json { render json: { status: 'success', message: 'Report generated successfully' } }
      end
    end
  end

  def show_saved_report
    @report = Report.find(params[:id])
    @preview_data = extract_preview_data_from_report(@report)
  end

  def destroy_saved_report
    @report = Report.find(params[:id])
    @report.destroy
    redirect_to admin_reports_expired_insurance_reports_path,
                notice: 'Report deleted successfully!'
  end

  def export_csv
    @report = Report.find(params[:id])
    csv_data = generate_csv_from_report(@report)

    send_data csv_data,
      filename: "expired_insurance_report_#{@report.created_at.strftime('%Y%m%d_%H%M%S')}.csv",
      type: 'text/csv',
      disposition: 'attachment'
  end

  private

  def preview_params
    params.permit(:start_date, :end_date, :policy_type, :status)
  end

  def generate_preview_data(filters)
    # Build the query based on filters
    policies = build_policy_query(filters)

    # Transform policies into preview data format
    policies.map do |policy|
      build_policy_preview_data(policy)
    end
  end

  def build_policy_query(filters)
    # Default date range for expired policies
    start_date = filters[:start_date] || 30.days.ago.to_date
    end_date = filters[:end_date] || Date.current

    # Start with base query depending on policy type filter
    if filters[:policy_type].present?
      case filters[:policy_type]
      when 'health'
        policies = HealthInsurance.includes(:customer, :sub_agent)
      when 'motor'
        policies = MotorInsurance.includes(:customer, :sub_agent)
      when 'life'
        policies = LifeInsurance.includes(:customer, :sub_agent) if defined?(LifeInsurance)
      end
    else
      # Combine all policy types
      health_policies = HealthInsurance.includes(:customer, :sub_agent)
      motor_policies = MotorInsurance.includes(:customer, :sub_agent)

      # Apply date filters for expired policies
      health_policies = health_policies.where('policy_end_date BETWEEN ? AND ?', start_date, end_date)
      motor_policies = motor_policies.where('policy_end_date BETWEEN ? AND ?', start_date, end_date)

      # Combine and return results
      policies = []
      policies += health_policies.to_a
      policies += motor_policies.to_a

      return policies
    end

    # Apply date filters for expired policies
    policies = policies.where('policy_end_date BETWEEN ? AND ?', start_date, end_date)

    # Apply status filter if needed (expired vs expiring soon)
    if filters[:status].present?
      case filters[:status]
      when 'expired'
        policies = policies.where('policy_end_date < ?', Date.current)
      when 'expiring_soon'
        policies = policies.where('policy_end_date BETWEEN ? AND ?', Date.current, 30.days.from_now)
      end
    end

    policies
  end

  def build_policy_preview_data(policy)
    policy_type = policy.class.name.underscore.gsub('_insurance', '')
    days_expired = policy.policy_end_date ? (Date.current - policy.policy_end_date).to_i : 0

    status = if policy.policy_end_date < Date.current
               'Expired'
             elsif policy.policy_end_date <= 30.days.from_now
               'Expiring Soon'
             else
               'Active'
             end

    {
      id: policy.id,
      policy_number: policy.policy_number,
      policy_type: policy_type,
      customer_name: policy.customer&.display_name || 'N/A',
      customer_email: policy.customer&.email,
      customer_mobile: policy.customer&.mobile,
      insurance_company: policy.insurance_company_name || 'N/A',
      policy_start_date: policy.policy_start_date,
      policy_end_date: policy.policy_end_date,
      days_expired: days_expired,
      premium_amount: policy.total_premium || 0,
      sum_insured: policy.try(:sum_insured) || policy.try(:total_idv) || 0,
      status: status,
      affiliate: policy.sub_agent&.display_name || 'Self',
      policy_object: policy
    }
  end

  def generate_detailed_expired_insurance_report(filters)
    preview_data = generate_preview_data(filters)

    {
      'statistics' => {
        'total_policies' => preview_data.size,
        'total_premium' => preview_data.sum { |p| p[:premium_amount] || 0 },
        'total_sum_insured' => preview_data.sum { |p| p[:sum_insured] || 0 },
        'expired_count' => preview_data.count { |p| p[:status] == 'Expired' },
        'expiring_soon_count' => preview_data.count { |p| p[:status] == 'Expiring Soon' }
      },
      'policies' => preview_data,
      'filters' => filters
    }
  end

  def extract_preview_data_from_report(report)
    report.report_data['policies'] || []
  end

  def generate_csv_from_report(report)
    report_data = report.report_data || {}
    report_name = report.name || 'Expired Insurance Report'

    # Extract filters from report metadata if available
    filters = {
      start_date: report.filters&.dig('start_date') || 'All time',
      end_date: report.filters&.dig('end_date') || 'All time',
      policy_type: report.filters&.dig('policy_type') || 'All',
      status: report.filters&.dig('status') || 'All'
    }

    generate_csv_from_data(report_data, report_name, filters)
  end

  def calculate_total_premium_lost_from_reports
    reports = Report.where(report_type: 'expired_insurance')
    total = 0
    reports.each do |report|
      premium = report.report_data&.dig('statistics', 'total_premium')
      total += premium.to_f if premium
    end
    total
  end

  def generate_csv_from_data(report_data, report_name, filters)
    require 'csv'

    policies = report_data['policies'] || []
    statistics = report_data['statistics'] || {}

    CSV.generate(headers: true) do |csv|
      # Add report header
      csv << ["Expired Insurance Report: #{report_name}"]
      csv << ["Generated on: #{Date.current.strftime('%d %b %Y')}"]
      csv << []

      # Add filters information
      csv << ["Report Filters:"]
      csv << ["Date Range:", "#{filters[:start_date]} to #{filters[:end_date]}"]
      csv << ["Policy Type:", filters[:policy_type] || "All Types"]
      csv << ["Status:", filters[:status] || "All Status"]
      csv << []

      # Add summary statistics
      csv << ["Summary Statistics:"]
      csv << ["Total Policies:", statistics['total_policies']]
      csv << ["Total Premium:", "Rs.#{statistics['total_premium']}"]
      csv << ["Total Sum Insured:", "Rs.#{statistics['total_sum_insured']}"]
      csv << ["Expired Count:", statistics['expired_count']]
      csv << ["Expiring Soon:", statistics['expiring_soon_count']]
      csv << []

      # Add policy details header
      csv << ["Policy Details:"]
      csv << [
        'Policy Number', 'Policy Type', 'Customer Name', 'Customer Email', 'Customer Mobile',
        'Insurance Company', 'Policy Start Date', 'Policy End Date', 'Days Expired',
        'Premium Amount', 'Sum Insured', 'Status', 'Affiliate'
      ]

      policies.each do |policy|
        csv << [
          policy['policy_number'],
          policy['policy_type']&.capitalize,
          policy['customer_name'],
          policy['customer_email'],
          policy['customer_mobile'],
          policy['insurance_company'],
          policy['policy_start_date'],
          policy['policy_end_date'],
          policy['days_expired'],
          policy['premium_amount'],
          policy['sum_insured'],
          policy['status'],
          policy['affiliate']
        ]
      end
    end
  end
end