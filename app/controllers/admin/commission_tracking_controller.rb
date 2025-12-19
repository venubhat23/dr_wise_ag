class Admin::CommissionTrackingController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin_access
  before_action :find_policy, only: [:show, :policy_breakdown, :transfer_to_affiliate,
                                      :transfer_to_ambassador, :transfer_to_investor,
                                      :transfer_company_expense]

  skip_authorization_check
  skip_load_and_authorize_resource

  def index
    @page = params[:page] || 1
    @per_page = 10
    @policies_with_commission = fetch_policies_with_commission_optimized(@page, @per_page)
    @total_commission_generated = calculate_total_commission
    @total_transferred = calculate_total_transferred
    @pending_transfers = calculate_pending_transfers
  end

  def dashboard
    @commission_summary = {
      total_generated: calculate_total_commission,
      total_transferred: calculate_total_transferred,
      pending_transfers: calculate_pending_transfers,
      company_expenses: calculate_company_expenses
    }

    @recent_policies = fetch_recent_policies_with_commission
    @transfer_summary = fetch_transfer_summary
  end

  def show
    @commission_breakdown = CommissionCalculatorService.get_policy_commission_summary(@policy)
    @transfer_history = fetch_transfer_history(@policy)
  end

  def policy_breakdown
    @commission_breakdown = CommissionCalculatorService.get_policy_commission_summary(@policy)

    respond_to do |format|
      format.json { render json: @commission_breakdown }
      format.html
    end
  end

  def transfer_to_affiliate
    result = process_manual_transfer(
      policy: @policy,
      transfer_type: 'affiliate',
      amount: params[:amount],
      transaction_id: params[:transaction_id],
      notes: params[:notes]
    )

    respond_with_transfer_result(result)
  end

  def transfer_to_ambassador
    result = process_manual_transfer(
      policy: @policy,
      transfer_type: 'ambassador',
      amount: params[:amount],
      transaction_id: params[:transaction_id],
      notes: params[:notes]
    )

    respond_with_transfer_result(result)
  end

  def transfer_to_investor
    result = process_manual_transfer(
      policy: @policy,
      transfer_type: 'investor',
      amount: params[:amount],
      transaction_id: params[:transaction_id],
      notes: params[:notes]
    )

    respond_with_transfer_result(result)
  end

  def transfer_company_expense
    result = process_manual_transfer(
      policy: @policy,
      transfer_type: 'company_expense',
      amount: params[:amount],
      transaction_id: params[:transaction_id],
      notes: params[:notes]
    )

    respond_with_transfer_result(result)
  end

  def manual_transfer
    policy = find_policy_by_params

    unless policy
      return render json: { success: false, message: 'Policy not found' }, status: :not_found
    end

    result = process_manual_transfer(
      policy: policy,
      transfer_type: params[:transfer_type],
      amount: params[:amount],
      transaction_id: params[:transaction_id],
      notes: params[:notes]
    )

    render json: result
  end

  def policy_search
    search_term = params[:search]
    policies = []

    if search_term.present?
      # Search across all insurance types
      policies = search_policies_across_types(search_term)
    end

    respond_to do |format|
      format.json { render json: policies }
      format.html { @policies = policies }
    end
  end

  def summary
    @summary_data = {
      monthly_breakdown: monthly_commission_breakdown,
      policy_type_breakdown: policy_type_commission_breakdown,
      transfer_status_breakdown: transfer_status_breakdown
    }

    respond_to do |format|
      format.json { render json: @summary_data }
      format.html
    end
  end

  private

  def find_policy
    policy_type = params[:policy_type] || params[:type]
    policy_id = params[:id] || params[:policy_id]

    @policy = case policy_type&.downcase
              when 'health'
                HealthInsurance.find(policy_id)
              when 'life'
                LifeInsurance.find(policy_id)
              when 'motor'
                MotorInsurance.find(policy_id)
              when 'other'
                OtherInsurance.find(policy_id)
              else
                # Try to find in all tables if policy_type is not specified
                find_policy_across_types(policy_id)
              end
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_commission_tracking_index_path, alert: 'Policy not found'
  end

  def find_policy_by_params
    policy_type = params[:policy_type]
    policy_id = params[:policy_id]

    case policy_type&.downcase
    when 'health'
      HealthInsurance.find_by(id: policy_id)
    when 'life'
      LifeInsurance.find_by(id: policy_id)
    when 'motor'
      MotorInsurance.find_by(id: policy_id)
    when 'other'
      OtherInsurance.find_by(id: policy_id)
    end
  end

  def find_policy_across_types(policy_id)
    [HealthInsurance, LifeInsurance, MotorInsurance, OtherInsurance].each do |model|
      policy = model.find_by(id: policy_id)
      return policy if policy
    end
    nil
  end

  def search_policies_across_types(search_term)
    policies = []

    # Search Health Insurance
    HealthInsurance.joins(:customer)
                   .where("health_insurances.policy_number ILIKE ? OR customers.first_name ILIKE ? OR customers.last_name ILIKE ?",
                          "%#{search_term}%", "%#{search_term}%", "%#{search_term}%")
                   .limit(10).each do |policy|
      policies << format_policy_for_search(policy, 'health')
    end

    # Search Life Insurance
    LifeInsurance.joins(:customer)
                 .where("life_insurances.policy_number ILIKE ? OR customers.first_name ILIKE ? OR customers.last_name ILIKE ?",
                        "%#{search_term}%", "%#{search_term}%", "%#{search_term}%")
                 .limit(10).each do |policy|
      policies << format_policy_for_search(policy, 'life')
    end

    # Search Motor Insurance
    MotorInsurance.joins(:customer)
                  .where("motor_insurances.policy_number ILIKE ? OR customers.first_name ILIKE ? OR customers.last_name ILIKE ?",
                         "%#{search_term}%", "%#{search_term}%", "%#{search_term}%")
                  .limit(10).each do |policy|
      policies << format_policy_for_search(policy, 'motor')
    end

    policies
  end

  def format_policy_for_search(policy, type)
    {
      id: policy.id,
      type: type,
      policy_number: policy.policy_number,
      customer_name: policy.customer.display_name,
      premium: policy.total_premium,
      commission_status: get_commission_status(policy, type)
    }
  end

  def get_commission_status(policy, type)
    breakdown = CommissionCalculatorService.calculate_commission_breakdown(policy)
    return 'no_commission' if breakdown.empty?

    existing_payouts = CommissionPayout.where(
      policy_type: type,
      policy_id: policy.id
    )

    if existing_payouts.any?
      paid_count = existing_payouts.where(status: 'paid').count
      total_count = existing_payouts.count

      if paid_count == total_count
        'fully_transferred'
      elsif paid_count > 0
        'partially_transferred'
      else
        'pending_transfer'
      end
    else
      'no_transfers_created'
    end
  end

  def fetch_policies_with_commission_optimized(page = 1, per_page = 10)
    policies = []
    collected_count = 0
    per_model_limit = (per_page.to_f / 4).ceil

    # Pre-load commission payouts for better performance
    policy_ids_by_type = {}

    # First, collect policy IDs from each model type
    [
      { model: HealthInsurance, type: 'health' },
      { model: LifeInsurance, type: 'life' },
      { model: MotorInsurance, type: 'motor' },
      { model: OtherInsurance, type: 'other' }
    ].each do |insurance_info|
      policy_ids_by_type[insurance_info[:type]] = insurance_info[:model]
                                                   .order(created_at: :desc)
                                                   .limit(per_model_limit)
                                                   .pluck(:id)
    end

    # Pre-load all relevant commission payouts in one query
    all_payouts = {}
    policy_ids_by_type.each do |policy_type, ids|
      next if ids.empty?

      payouts = CommissionPayout.where(policy_type: policy_type, policy_id: ids)
                               .select(:policy_type, :policy_id, :status, :payout_amount)

      payouts.each do |payout|
        key = "#{payout.policy_type}_#{payout.policy_id}"
        all_payouts[key] ||= []
        all_payouts[key] << payout
      end
    end

    # Now fetch the actual policies with their customer data
    [
      { model: HealthInsurance, type: 'health' },
      { model: LifeInsurance, type: 'life' },
      { model: MotorInsurance, type: 'motor' },
      { model: OtherInsurance, type: 'other' }
    ].each do |insurance_info|
      next if collected_count >= per_page

      policy_ids = policy_ids_by_type[insurance_info[:type]]
      next if policy_ids.empty?

      insurance_info[:model]
        .includes(:customer)
        .where(id: policy_ids)
        .order(created_at: :desc)
        .each do |policy|
          break if collected_count >= per_page

          commission_data = CommissionCalculatorService.calculate_commission_breakdown(policy)
          next if commission_data.empty?

          policies << {
            policy: policy,
            type: insurance_info[:type],
            commission_data: commission_data,
            transfer_status: get_transfer_status_optimized(policy, insurance_info[:type], all_payouts)
          }
          collected_count += 1
        end
    end

    # Sort by creation date and limit to requested page size
    policies.sort_by { |p| p[:policy].created_at }.reverse.take(per_page)
  end

  def fetch_policies_with_commission
    fetch_policies_with_commission_optimized(1, 50)
  end

  def get_transfer_status_optimized(policy, type, all_payouts)
    policy_key = "#{type}_#{policy.id}"
    existing_payouts = all_payouts[policy_key] || []

    paid_payouts = existing_payouts.select { |p| p.status == 'paid' }
    pending_payouts = existing_payouts.select { |p| p.status == 'pending' }

    {
      total_payouts: existing_payouts.count,
      paid_payouts: paid_payouts.count,
      pending_payouts: pending_payouts.count,
      total_amount: existing_payouts.sum(&:payout_amount),
      paid_amount: paid_payouts.sum(&:payout_amount)
    }
  end

  def get_transfer_status(policy, type)
    existing_payouts = CommissionPayout.where(
      policy_type: type,
      policy_id: policy.id
    )

    {
      total_payouts: existing_payouts.count,
      paid_payouts: existing_payouts.where(status: 'paid').count,
      pending_payouts: existing_payouts.where(status: 'pending').count,
      total_amount: existing_payouts.sum(:payout_amount),
      paid_amount: existing_payouts.where(status: 'paid').sum(:payout_amount)
    }
  end

  def calculate_total_commission
    total = 0

    [HealthInsurance, LifeInsurance, MotorInsurance, OtherInsurance].each do |model|
      model.all.each do |policy|
        breakdown = CommissionCalculatorService.calculate_commission_breakdown(policy)
        total += breakdown.dig(:summary, :total_commission_generated) || 0
      end
    end

    total
  end

  def calculate_total_transferred
    CommissionPayout.where(status: 'paid').sum(:payout_amount)
  end

  def calculate_pending_transfers
    CommissionPayout.where(status: 'pending').sum(:payout_amount)
  end

  def calculate_company_expenses
    CommissionPayout.where(payout_to: 'company_expense', status: 'paid').sum(:payout_amount)
  end

  def fetch_recent_policies_with_commission
    policies = []

    [HealthInsurance, LifeInsurance, MotorInsurance, OtherInsurance].each do |model|
      model.includes(:customer).order(created_at: :desc).limit(5).each do |policy|
        commission_data = CommissionCalculatorService.calculate_commission_breakdown(policy)
        next if commission_data.empty?

        policies << {
          policy: policy,
          type: model.name.underscore.gsub('_insurance', ''),
          commission_data: commission_data
        }
      end
    end

    policies.sort_by { |p| p[:policy].created_at }.reverse.take(20)
  end

  def fetch_transfer_summary
    {
      affiliate: CommissionPayout.where(payout_to: 'affiliate').group(:status).sum(:payout_amount),
      ambassador: CommissionPayout.where(payout_to: 'ambassador').group(:status).sum(:payout_amount),
      investor: CommissionPayout.where(payout_to: 'investor').group(:status).sum(:payout_amount),
      company_expense: CommissionPayout.where(payout_to: 'company_expense').group(:status).sum(:payout_amount)
    }
  end

  def fetch_transfer_history(policy)
    policy_type = policy.class.name.underscore.gsub('_insurance', '')

    CommissionPayout.where(
      policy_type: policy_type,
      policy_id: policy.id
    ).order(created_at: :desc)
  end

  def process_manual_transfer(policy:, transfer_type:, amount:, transaction_id:, notes:)
    return { success: false, message: 'Invalid amount' } if amount.to_f <= 0

    policy_type = policy.class.name.underscore.gsub('_insurance', '')

    # Find existing payout or create new one
    payout = CommissionPayout.find_or_initialize_by(
      policy_type: policy_type,
      policy_id: policy.id,
      payout_to: transfer_type
    )

    if payout.new_record?
      # Calculate the amount based on commission breakdown
      breakdown = CommissionCalculatorService.calculate_commission_breakdown(policy)
      expected_amount = breakdown.dig(:payouts, transfer_type.to_sym) || 0

      payout.payout_amount = expected_amount
      payout.status = 'pending'
      payout.processed_by = current_user.email
    end

    # Mark as paid with transfer details
    payout.assign_attributes(
      status: 'paid',
      payout_date: Date.current,
      transaction_id: transaction_id,
      notes: notes,
      processed_by: current_user.email,
      processed_at: Time.current
    )

    if payout.save
      { success: true, message: "Transfer completed successfully", payout: payout }
    else
      { success: false, message: payout.errors.full_messages.join(', ') }
    end
  rescue StandardError => e
    Rails.logger.error "Manual transfer failed: #{e.message}"
    { success: false, message: 'Transfer failed. Please try again.' }
  end

  def respond_with_transfer_result(result)
    respond_to do |format|
      format.json { render json: result }
      format.html do
        if result[:success]
          redirect_to admin_commission_tracking_path(@policy, policy_type: @policy.class.name.underscore.gsub('_insurance', '')),
                      notice: result[:message]
        else
          redirect_to admin_commission_tracking_path(@policy, policy_type: @policy.class.name.underscore.gsub('_insurance', '')),
                      alert: result[:message]
        end
      end
    end
  end

  def monthly_commission_breakdown
    # Implementation for monthly breakdown
    {}
  end

  def policy_type_commission_breakdown
    # Implementation for policy type breakdown
    {}
  end

  def transfer_status_breakdown
    # Implementation for transfer status breakdown
    {}
  end

  def authorize_admin_access
    redirect_to root_path unless current_user&.user_type == 'admin'
  end
end