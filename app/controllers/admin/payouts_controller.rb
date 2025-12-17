class Admin::PayoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payout, only: [:show, :edit, :update, :destroy, :mark_as_paid, :mark_as_processing, :cancel_payout, :audit_trail]

  def index
    @q = CommissionPayout.ransack(params[:q])

    # Apply default ordering
    @q.sorts = 'created_at desc' if @q.sorts.empty?

    @payouts = @q.result(distinct: true)
                 .includes(:payout_audit_logs)
                 .page(params[:page])
                 .per(20)

    # Summary statistics
    @summary = {
      total_payouts: CommissionPayout.count,
      total_amount: CommissionPayout.sum(:payout_amount),
      pending_amount: CommissionPayout.pending.sum(:payout_amount),
      paid_amount: CommissionPayout.paid.sum(:payout_amount),
      pending_count: CommissionPayout.pending.count,
      paid_count: CommissionPayout.paid.count,
      this_month: CommissionPayout.this_month.sum(:payout_amount),
      last_month: CommissionPayout.last_month.sum(:payout_amount)
    }

    # Chart data for dashboard
    @chart_data = prepare_chart_data

    respond_to do |format|
      format.html
      format.json { render json: { payouts: @payouts, summary: @summary } }
    end
  end

  def show
    @audit_logs = @payout.payout_audit_logs.recent.limit(10)
    @policy = @payout.policy
    @customer = @payout.customer
  end

  def new
    @payout = CommissionPayout.new
    @policies = available_policies_for_payout
  end

  def create
    @payout = CommissionPayout.new(payout_params)
    @payout.processed_by = current_user.email

    if @payout.save
      create_audit_log(@payout, 'created', "Payout created manually by #{current_user.email}")
      redirect_to admin_payout_path(@payout), notice: 'Payout was successfully created.'
    else
      @policies = available_policies_for_payout
      render :new
    end
  end

  def edit
  end

  def update
    if @payout.update(payout_params)
      create_audit_log(@payout, 'updated', "Payout updated by #{current_user.email}")
      redirect_to admin_payout_path(@payout), notice: 'Payout was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @payout.destroy
    create_audit_log(@payout, 'deleted', "Payout deleted by #{current_user.email}")
    redirect_to admin_payouts_path, notice: 'Payout was successfully deleted.'
  end

  def mark_as_paid
    payment_details = {
      payout_date: params[:payout_date] || Date.current,
      payment_mode: params[:payment_mode],
      transaction_id: params[:transaction_id],
      reference_number: params[:reference_number],
      notes: params[:notes],
      processed_by: current_user.email
    }

    if @payout.mark_as_paid!(payment_details)
      redirect_to admin_payout_path(@payout), notice: 'Payout marked as paid successfully.'
    else
      redirect_to admin_payout_path(@payout), alert: 'Failed to mark payout as paid.'
    end
  end

  def mark_as_processing
    if @payout.mark_as_processing!
      redirect_to admin_payout_path(@payout), notice: 'Payout marked as processing.'
    else
      redirect_to admin_payout_path(@payout), alert: 'Failed to mark payout as processing.'
    end
  end

  def cancel_payout
    reason = params[:cancellation_reason] || 'Cancelled by admin'

    if @payout.cancel_payout!(reason)
      redirect_to admin_payout_path(@payout), notice: 'Payout cancelled successfully.'
    else
      redirect_to admin_payout_path(@payout), alert: 'Failed to cancel payout.'
    end
  end

  def audit_trail
    @audit_logs = @payout.payout_audit_logs.recent.includes(:auditable)
    render json: @audit_logs.map { |log| format_audit_log(log) }
  end

  def commission_receipts
    @q = CommissionReceipt.ransack(params[:q])
    @q.sorts = 'received_date desc' if @q.sorts.empty?

    @receipts = @q.result(distinct: true)
                  .includes(:payout_distributions)
                  .page(params[:page])
                  .per(20)

    @receipt_summary = {
      total_received: CommissionReceipt.sum(:total_commission_received),
      total_distributed: PayoutDistribution.sum(:calculated_amount),
      pending_distribution: CommissionReceipt.pending_distribution.count,
      auto_distributed: CommissionReceipt.distributed.count
    }
  end

  def auto_distribute
    receipt_id = params[:receipt_id]
    @receipt = CommissionReceipt.find(receipt_id)

    if @receipt.auto_distribute_commission!
      redirect_to admin_payouts_commission_receipts_path,
                  notice: 'Commission distributed automatically.'
    else
      redirect_to admin_payouts_commission_receipts_path,
                  alert: 'Failed to distribute commission automatically.'
    end
  end

  def reports
    @date_range = params[:date_range] || 'this_month'
    @policy_type = params[:policy_type] || 'all'
    @recipient_type = params[:recipient_type] || 'all'

    @report_data = generate_payout_report(@date_range, @policy_type, @recipient_type)

    respond_to do |format|
      format.html
      format.json { render json: @report_data }
      format.csv { send_csv_report(@report_data) }
    end
  end

  def summary
    @summary_data = {
      overview: payout_overview,
      by_recipient: payout_by_recipient,
      by_policy_type: payout_by_policy_type,
      monthly_trend: monthly_payout_trend,
      recent_activities: recent_payout_activities
    }

    respond_to do |format|
      format.html
      format.json { render json: @summary_data }
    end
  end

  def policies_by_type
    policy_type = params[:policy_type]
    policies = []

    case policy_type
    when 'health_insurance', 'health'
      policies = HealthInsurance.includes(:customer)
                                .select(:id, :policy_number, :customer_id, :total_premium)
                                .limit(100)
                                .map do |policy|
        customer_name = policy.customer&.display_name || 'Unknown Customer'
        {
          id: policy.id,
          policy_number: policy.policy_number || "Policy ##{policy.id}",
          customer_name: customer_name,
          premium: policy.total_premium || 0
        }
      end
    when 'life_insurance', 'life'
      policies = LifeInsurance.includes(:customer)
                              .select(:id, :policy_number, :customer_id, :premium_amount)
                              .limit(100)
                              .map do |policy|
        customer_name = policy.customer&.display_name || 'Unknown Customer'
        {
          id: policy.id,
          policy_number: policy.policy_number || "Policy ##{policy.id}",
          customer_name: customer_name,
          premium: policy.premium_amount || 0
        }
      end
    when 'motor_insurance', 'motor'
      if defined?(MotorInsurance)
        policies = MotorInsurance.includes(:customer)
                                 .select(:id, :policy_number, :customer_id, :premium_amount)
                                 .limit(100)
                                 .map do |policy|
          customer_name = policy.customer&.display_name || 'Unknown Customer'
          {
            id: policy.id,
            policy_number: policy.policy_number || "Policy ##{policy.id}",
            customer_name: customer_name,
            premium: policy.premium_amount || 0
          }
        end
      end
    when 'general_insurance', 'general'
      if defined?(GeneralInsurance)
        policies = GeneralInsurance.includes(:customer)
                                   .select(:id, :policy_number, :customer_id, :premium_amount)
                                   .limit(100)
                                   .map do |policy|
          customer_name = policy.customer&.display_name || 'Unknown Customer'
          {
            id: policy.id,
            policy_number: policy.policy_number || "Policy ##{policy.id}",
            customer_name: customer_name,
            premium: policy.premium_amount || 0
          }
        end
      end
    end

    render json: policies
  rescue => e
    Rails.logger.error "Error fetching policies by type: #{e.message}"
    render json: { error: 'Failed to fetch policies' }, status: :internal_server_error
  end

  private

  def set_payout
    @payout = CommissionPayout.find(params[:id])
  end

  def payout_params
    params.require(:commission_payout).permit(
      :policy_type, :policy_id, :payout_to, :payout_amount, :payout_date,
      :payment_mode, :transaction_id, :reference_number, :notes, :status,
      :commission_amount_received, :distribution_percentage
    )
  end

  def available_policies_for_payout
    # Get policies that don't have complete payouts yet
    health_policies = HealthInsurance.includes(:customer).limit(100)
    life_policies = LifeInsurance.includes(:customer).limit(100)
    motor_policies = MotorInsurance.includes(:customer).limit(100) rescue []

    policies = []

    health_policies.each do |policy|
      policies << {
        id: policy.id,
        type: 'health',
        number: policy.policy_number,
        customer: policy.customer.display_name,
        value: "Health - #{policy.policy_number} - #{policy.customer.display_name}"
      }
    end

    life_policies.each do |policy|
      policies << {
        id: policy.id,
        type: 'life',
        number: policy.policy_number,
        customer: policy.customer.display_name,
        value: "Life - #{policy.policy_number} - #{policy.customer.display_name}"
      }
    end

    policies
  end

  def prepare_chart_data
    {
      monthly_payouts: monthly_payout_data,
      status_distribution: status_distribution_data,
      recipient_breakdown: recipient_breakdown_data
    }
  end

  def monthly_payout_data
    12.times.map do |i|
      month = i.months.ago.beginning_of_month
      {
        month: month.strftime('%b %Y'),
        amount: CommissionPayout.where(
          payout_date: month..month.end_of_month
        ).sum(:payout_amount)
      }
    end.reverse
  end

  def status_distribution_data
    CommissionPayout.group(:status).sum(:payout_amount)
  end

  def recipient_breakdown_data
    CommissionPayout.group(:payout_to).sum(:payout_amount)
  end

  def generate_payout_report(date_range, policy_type, recipient_type)
    payouts = CommissionPayout.all

    # Apply date filter
    case date_range
    when 'this_month'
      payouts = payouts.this_month
    when 'last_month'
      payouts = payouts.last_month
    when 'this_year'
      payouts = payouts.where(payout_date: Date.current.beginning_of_year..Date.current.end_of_year)
    when 'last_year'
      payouts = payouts.where(payout_date: 1.year.ago.beginning_of_year..1.year.ago.end_of_year)
    end

    # Apply policy type filter
    payouts = payouts.for_policy_type(policy_type) if policy_type != 'all'

    # Apply recipient type filter
    payouts = payouts.for_payout_to(recipient_type) if recipient_type != 'all'

    {
      summary: {
        total_payouts: payouts.count,
        total_amount: payouts.sum(:payout_amount),
        paid_amount: payouts.paid.sum(:payout_amount),
        pending_amount: payouts.pending.sum(:payout_amount)
      },
      details: payouts.includes(:payout_audit_logs).order(payout_date: :desc),
      breakdowns: {
        by_status: payouts.group(:status).sum(:payout_amount),
        by_recipient: payouts.group(:payout_to).sum(:payout_amount),
        by_policy_type: payouts.group(:policy_type).sum(:payout_amount)
      }
    }
  end

  def payout_overview
    {
      total_payouts: CommissionPayout.count,
      total_amount: CommissionPayout.sum(:payout_amount),
      pending_amount: CommissionPayout.pending.sum(:payout_amount),
      paid_amount: CommissionPayout.paid.sum(:payout_amount),
      processing_amount: CommissionPayout.processing.sum(:payout_amount)
    }
  end

  def payout_by_recipient
    CommissionPayout.group(:payout_to)
                   .group(:status)
                   .sum(:payout_amount)
  end

  def payout_by_policy_type
    CommissionPayout.group(:policy_type)
                   .group(:status)
                   .sum(:payout_amount)
  end

  def monthly_payout_trend
    6.times.map do |i|
      month = i.months.ago
      {
        month: month.strftime('%b %Y'),
        paid: CommissionPayout.paid.where(
          payout_date: month.beginning_of_month..month.end_of_month
        ).sum(:payout_amount),
        pending: CommissionPayout.pending.where(
          created_at: month.beginning_of_month..month.end_of_month
        ).sum(:payout_amount)
      }
    end.reverse
  end

  def recent_payout_activities
    PayoutAuditLog.recent
                  .includes(:auditable)
                  .limit(10)
                  .map { |log| format_audit_log(log) }
  end

  def format_audit_log(log)
    {
      id: log.id,
      action: log.action.humanize,
      performed_by: log.performed_by,
      performed_at: log.created_at.strftime('%Y-%m-%d %H:%M:%S'),
      notes: log.notes,
      changes: log.formatted_changes
    }
  end

  def create_audit_log(payout, action, notes)
    PayoutAuditLog.create_log(
      payout,
      action,
      current_user.email,
      payout.saved_changes,
      notes,
      request.remote_ip
    )
  end

  def send_csv_report(report_data)
    csv_data = generate_csv(report_data)
    send_data csv_data,
              filename: "payout_report_#{Date.current}.csv",
              type: 'text/csv'
  end

  def generate_csv(report_data)
    require 'csv'

    CSV.generate(headers: true) do |csv|
      csv << ['Policy Type', 'Policy ID', 'Customer', 'Recipient', 'Amount', 'Status', 'Date', 'Reference']

      report_data[:details].each do |payout|
        csv << [
          payout.policy_type.capitalize,
          payout.policy_number,
          payout.customer_name,
          payout.payout_to.humanize,
          payout.payout_amount,
          payout.status.capitalize,
          payout.payout_date&.strftime('%Y-%m-%d'),
          payout.reference_number
        ]
      end
    end
  end
end