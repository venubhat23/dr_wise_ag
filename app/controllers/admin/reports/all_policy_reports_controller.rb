class Admin::Reports::AllPolicyReportsController < Admin::Reports::BaseController
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
    @saved_reports = AllPolicyReport.includes(:created_by)
                                    .order(created_at: :desc)
                                    .page(params[:page])
                                    .per(10)

    # Calculate statistics
    @total_reports = AllPolicyReport.count
    @this_month_reports = AllPolicyReport.where(created_at: Date.current.beginning_of_month..Date.current.end_of_month).count
    @last_generated = AllPolicyReport.maximum(:created_at)
    @total_policies = calculate_total_policies_from_reports

    respond_to do |format|
      format.html
    end
  end

  def new
    # Show the generate form page
  end

  def preview
    @preview_data = generate_preview_data(preview_params)

    render partial: 'preview_table', layout: false
  end

  def create
    filters = {
      policy_type: params[:policy_type].presence
    }.compact

    report_name = params[:report_name].presence || "All Policy Report #{Date.current.strftime('%d %b %Y')}"

    # Generate report data with the same logic as preview
    report_data = generate_detailed_policy_report(filters)

    # Save to database if requested
    if params[:save_to_database] == "1"
      @report = AllPolicyReport.new(
        name: report_name,
        policy_type: filters[:policy_type],
        report_data: report_data,
        created_by_id: current_user&.id,
        created_at: Time.current
      )

      unless @report.save
        flash.now[:alert] = "Failed to save report: #{@report.errors.full_messages.join(', ')}"
        render :new, status: :unprocessable_entity
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
        format.html { redirect_to admin_reports_all_policy_reports_path }
        format.json { render json: { status: 'success', message: 'Report generated successfully' } }
      end
    end
  end

  def show
    @report = AllPolicyReport.find(params[:id])
    @preview_data = extract_preview_data_from_report(@report)
  end

  def destroy
    @report = AllPolicyReport.find(params[:id])
    @report.destroy
    redirect_to admin_reports_all_policy_reports_path,
                notice: 'Report deleted successfully!'
  end

  def export_csv
    @report = AllPolicyReport.find(params[:id])
    csv_data = generate_csv_from_report(@report)

    send_data csv_data,
      filename: "all_policy_report_#{@report.created_at.strftime('%Y%m%d_%H%M%S')}.csv",
      type: 'text/csv',
      disposition: 'attachment'
  end

  private

  def preview_params
    params.permit(:policy_type)
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
    policies = []

    # Start with base query depending on policy type filter
    if filters[:policy_type].present?
      case filters[:policy_type]
      when 'health'
        policies = HealthInsurance.includes(:customer).to_a
      when 'motor'
        policies = MotorInsurance.includes(:customer).to_a
      when 'life'
        policies = LifeInsurance.includes(:customer).to_a if defined?(LifeInsurance)
      end
    else
      # Combine all policy types
      policies = []
      policies += HealthInsurance.includes(:customer).to_a
      policies += MotorInsurance.includes(:customer).to_a
      policies += LifeInsurance.includes(:customer).to_a if defined?(LifeInsurance)
    end

    policies
  end

  def build_policy_preview_data(policy)
    policy_type = policy.class.name.underscore.gsub('_insurance', '')

    {
      policy_number: policy.policy_number,
      policy_type: policy_type,
      customer_name: policy.customer&.display_name || 'N/A',
      insurance_company: policy.insurance_company_name || 'N/A',
      policy_holder: policy.policy_holder,
      start_date: policy.policy_start_date,
      end_date: policy.policy_end_date,
      premium_amount: policy.total_premium || 0,
      sum_insured: policy.sum_insured || 0,
      payment_mode: policy.payment_mode,
      policy_booking_date: policy.policy_booking_date,
      status: calculate_policy_status(policy),
      agent_name: get_agent_name(policy),
      sub_agent_name: get_sub_agent_name(policy),
      lead_id: policy.lead_id
    }
  end

  def calculate_policy_status(policy)
    if policy.policy_end_date.present?
      if policy.policy_end_date < Date.current
        'Expired'
      elsif policy.policy_end_date <= 30.days.from_now
        'Expiring Soon'
      else
        'Active'
      end
    else
      'Active'
    end
  end

  def get_agent_name(policy)
    if policy.respond_to?(:agent) && policy.agent
      policy.agent.full_name
    elsif policy.respond_to?(:user) && policy.user
      policy.user.full_name
    else
      'N/A'
    end
  end

  def get_sub_agent_name(policy)
    if policy.respond_to?(:sub_agent) && policy.sub_agent
      policy.sub_agent.full_name
    else
      'N/A'
    end
  end

  def generate_detailed_policy_report(filters)
    preview_data = generate_preview_data(filters)

    {
      'statistics' => {
        'total_policies' => preview_data.size,
        'total_premium' => preview_data.sum { |p| p[:premium_amount] || 0 },
        'total_sum_insured' => preview_data.sum { |p| p[:sum_insured] || 0 },
        'active_policies' => preview_data.count { |p| p[:status] == 'Active' },
        'expired_policies' => preview_data.count { |p| p[:status] == 'Expired' },
        'expiring_soon' => preview_data.count { |p| p[:status] == 'Expiring Soon' }
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
    report_name = report.name || 'All Policy Report'

    # Extract filters from report metadata if available
    filters = {
      policy_type: report.policy_type || 'All'
    }

    generate_csv_from_data(report_data, report_name, filters)
  end

  def calculate_total_policies_from_reports
    reports = AllPolicyReport.all
    total = 0
    reports.each do |report|
      count = report.report_data&.dig('statistics', 'total_policies')
      total += count.to_i if count
    end
    total
  end

  def generate_csv_from_data(report_data, report_name, filters)
    require 'csv'

    policies = report_data['policies'] || []
    statistics = report_data['statistics'] || {}

    CSV.generate(headers: true) do |csv|
      # Add report header
      csv << ["All Policy Report: #{report_name}"]
      csv << ["Generated on: #{Date.current.strftime('%d %b %Y')}"]
      csv << []

      # Add filters information
      csv << ["Report Filters:"]
      csv << ["Policy Type:", filters[:policy_type] || "All Types"]
      csv << []

      # Add summary statistics
      csv << ["Summary Statistics:"]
      csv << ["Total Policies:", statistics['total_policies']]
      csv << ["Active Policies:", statistics['active_policies']]
      csv << ["Expired Policies:", statistics['expired_policies']]
      csv << ["Expiring Soon:", statistics['expiring_soon']]
      csv << ["Total Premium:", "Rs.#{statistics['total_premium']}"]
      csv << ["Total Sum Insured:", "Rs.#{statistics['total_sum_insured']}"]
      csv << []

      # Add policy details header
      csv << ["Policy Details:"]
      csv << [
        'Policy Number', 'Policy Type', 'Customer Name', 'Insurance Company',
        'Policy Holder', 'Start Date', 'End Date', 'Premium Amount',
        'Sum Insured', 'Payment Mode', 'Booking Date', 'Status',
        'Agent Name', 'Affiliate Name', 'Lead ID'
      ]

      policies.each do |policy|
        csv << [
          policy['policy_number'],
          policy['policy_type']&.capitalize,
          policy['customer_name'],
          policy['insurance_company'],
          policy['policy_holder'],
          policy['start_date'],
          policy['end_date'],
          policy['premium_amount'],
          policy['sum_insured'],
          policy['payment_mode'],
          policy['policy_booking_date'],
          policy['status'],
          policy['agent_name'],
          policy['sub_agent_name'],
          policy['lead_id']
        ]
      end
    end
  end
end