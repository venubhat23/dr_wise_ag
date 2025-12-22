class Admin::DistributorPayoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin_access

  def index
    @distributor_payouts = calculate_distributor_payouts
    @total_distributors = @distributor_payouts.count
    @total_pending_amount = @distributor_payouts.sum { |d| d[:pending_amount] }
    @total_paid_amount = @distributor_payouts.sum { |d| d[:paid_amount] }
    @total_commission_earned = @distributor_payouts.sum { |d| d[:total_amount] }
  end

  def mark_as_paid
    begin
      distributor_id = params[:distributor_id]
      lead_ids = params[:lead_ids] || []
      payout_type = params[:payout_type] || 'multiple_leads'

      Rails.logger.info "=== DISTRIBUTOR PAYOUT DEBUG ==="
      Rails.logger.info "distributor_id: #{distributor_id}"
      Rails.logger.info "lead_ids: #{lead_ids.inspect}"
      Rails.logger.info "payout_type: #{payout_type}"

      success_count = 0
      errors = []

      case payout_type
      when 'distributor_all'
        # Mark all pending payouts for this distributor as paid
        transaction_id = params[:transaction_id]
        payment_date = params[:payment_date]
        notes = params[:notes]

        if lead_ids.any?
          # Use the specific lead_ids from the form with transaction details
          lead_ids.each do |lead_id|
            if transaction_id.present?
              result = mark_single_lead_payout_with_details(lead_id, transaction_id, payment_date, notes)
            else
              result = mark_single_lead_payout(lead_id)
            end
            success_count += 1 if result[:success]
            errors << result[:error] if result[:error]
          end
        else
          # Fallback: find all unpaid leads for this distributor
          mark_all_distributor_payouts(distributor_id)
          success_count = 1
        end
      when 'lead_single'
        # Mark single lead as paid
        single_lead_id = params[:single_lead_id]
        result = mark_single_lead_payout(single_lead_id)
        success_count = result[:success] ? 1 : 0
        errors << result[:error] if result[:error]
      when 'lead_multiple'
        # Mark multiple leads as paid
        lead_ids.each do |lead_id|
          result = mark_single_lead_payout(lead_id)
          success_count += 1 if result[:success]
          errors << result[:error] if result[:error]
        end
      when 'bulk_selection'
        # Handle bulk selection from modal
        distributor_ids = params[:distributor_ids] || []

        # Process selected distributors (all their pending leads)
        distributor_ids.each do |dist_id|
          mark_all_distributor_payouts(dist_id)
          success_count += 1
        end

        # Process selected individual leads
        lead_ids.each do |lead_id|
          result = mark_single_lead_payout(lead_id)
          success_count += 1 if result[:success]
          errors << result[:error] if result[:error]
        end
      when 'bulk_modal_selection'
        # Handle new modal bulk selection with transaction details
        transaction_id = params[:transaction_id]
        payment_date = params[:payment_date]
        notes = params[:notes]

        lead_ids.each do |lead_id|
          result = mark_single_lead_payout_with_details(lead_id, transaction_id, payment_date, notes)
          success_count += 1 if result[:success]
          errors << result[:error] if result[:error]
        end
      when 'quick_all_pending'
        # Handle quick payout for all pending distributor payouts
        transaction_id = params[:transaction_id]
        payment_date = params[:payment_date] || Date.current
        notes = params[:notes] || "Quick batch payout for all pending distributors"

        # Get all pending distributor payouts
        pending_payouts = calculate_distributor_payouts.select { |d| d[:pending_amount] > 0 }

        pending_payouts.each do |distributor_data|
          unpaid_leads = distributor_data[:leads].select { |l| !l[:paid] }
          unpaid_leads.each do |lead_data|
            result = mark_single_lead_payout_with_details(lead_data[:lead].lead_id, transaction_id, payment_date, notes)
            success_count += 1 if result[:success]
            errors << result[:error] if result[:error]
          end
        end
      else
        # Default: mark specific distributor's leads as paid
        lead_ids.each do |lead_id|
          result = mark_single_lead_payout(lead_id)
          success_count += 1 if result[:success]
          errors << result[:error] if result[:error]
        end
      end

      if errors.any?
        redirect_to admin_distributor_payouts_path, alert: "Some payouts failed: #{errors.join(', ')}"
      else
        redirect_to admin_distributor_payouts_path, notice: "#{success_count} distributor payout(s) marked as paid successfully!"
      end

    rescue StandardError => e
      redirect_to admin_distributor_payouts_path, alert: "Error processing payouts: #{e.message}"
    end
  end

  def show
    @distributor_id = params[:id]
    @distributor = find_distributor_by_id(@distributor_id)

    unless @distributor
      redirect_to admin_distributor_payouts_path, alert: 'Distributor not found'
      return
    end

    @distributor_details = fetch_distributor_detailed_payouts(@distributor_id)
    @lead_wise_commissions = @distributor_details[:lead_wise_commissions]
    @summary = @distributor_details[:summary]
  end

  def unpaid_data
    unpaid_distributors = calculate_distributor_payouts.select { |d| d[:pending_amount] > 0 }

    render json: {
      success: true,
      data: unpaid_distributors.map do |distributor_data|
        {
          distributor: {
            id: distributor_data[:distributor].id,
            name: distributor_data[:distributor].display_name,
            email: distributor_data[:distributor].email
          },
          leads: distributor_data[:leads].reject { |l| l[:paid] }.map do |lead_data|
            {
              id: lead_data[:lead].lead_id,
              policy_id: lead_data[:policy].id,
              commission: lead_data[:commission].round(2),
              policy_number: lead_data[:policy].policy_number,
              customer_name: lead_data[:policy].customer&.display_name || 'Unknown'
            }
          end,
          total_pending: distributor_data[:pending_amount].round(2)
        }
      end
    }
  rescue StandardError => e
    render json: { success: false, message: e.message }
  end

  private

  def calculate_distributor_payouts
    payouts = []

    # Get all policies where main agent commission is received
    paid_policies = get_all_paid_policies

    # Group by distributor
    distributor_groups = {}

    paid_policies.each do |policy|
      next unless policy.lead_id.present?

      lead = Lead.find_by(lead_id: policy.lead_id)
      next unless lead

      # Get distributor from the policy's distributor_id field
      distributor = Distributor.find_by(id: policy.distributor_id) if policy.respond_to?(:distributor_id) && policy.distributor_id.present?
      next unless distributor

      # Calculate distributor commission (3% of net premium)
      distributor_commission = policy.net_premium * 0.03

      # Check if already paid
      already_paid = DistributorPayout.exists?(
        policy_type: get_policy_type(policy),
        policy_id: policy.id,
        distributor_id: distributor.id,
        status: 'paid'
      )

      distributor_key = distributor.id

      distributor_groups[distributor_key] ||= {
        distributor: distributor,
        leads: [],
        total_amount: 0,
        paid_amount: 0,
        pending_amount: 0
      }

      lead_data = {
        lead: lead,
        policy: policy,
        commission: distributor_commission,
        paid: already_paid
      }

      distributor_groups[distributor_key][:leads] << lead_data
      distributor_groups[distributor_key][:total_amount] += distributor_commission

      if already_paid
        distributor_groups[distributor_key][:paid_amount] += distributor_commission
      else
        distributor_groups[distributor_key][:pending_amount] += distributor_commission
      end
    end

    # Convert to array and sort by distributor name
    distributor_groups.values.sort_by { |group| group[:distributor].display_name }
  end

  def get_all_paid_policies
    policies = []

    # Health Insurances
    policies += HealthInsurance.where(main_agent_commission_received: true)

    # Life Insurances
    policies += LifeInsurance.where(main_agent_commission_received: true)

    # Motor Insurances
    policies += MotorInsurance.where(main_agent_commission_received: true)

    # Other Insurances (if they have the field)
    if OtherInsurance.column_names.include?('main_agent_commission_received')
      policies += OtherInsurance.where(main_agent_commission_received: true)
    end

    policies
  end

  def find_policy_by_lead_id(lead_id)
    # Search across all insurance types
    policy = HealthInsurance.find_by(lead_id: lead_id)
    policy ||= LifeInsurance.find_by(lead_id: lead_id)
    policy ||= MotorInsurance.find_by(lead_id: lead_id)
    policy ||= OtherInsurance.find_by(lead_id: lead_id) if OtherInsurance.column_names.include?('lead_id')
    policy
  end

  def fetch_distributor_detailed_payouts(distributor_id)
    distributor_payouts = DistributorPayout.where(distributor_id: distributor_id)

    lead_wise_commissions = distributor_payouts.map do |payout|
      policy = payout.policy
      next unless policy

      {
        lead_id: policy.id,
        policy_number: policy.policy_number,
        customer_name: policy.customer&.display_name || 'Unknown',
        policy_type: payout.policy_type.titleize,
        commission_amount: payout.payout_amount.to_f,
        status: payout.status,
        payout_date: payout.payout_date,
        transaction_id: payout.transaction_id,
        created_at: payout.created_at,
        notes: payout.notes
      }
    end.compact

    total_commission = lead_wise_commissions.sum { |lead| lead[:commission_amount] }
    paid_amount = lead_wise_commissions.select { |lead| lead[:status] == 'paid' }
                                      .sum { |lead| lead[:commission_amount] }
    pending_amount = total_commission - paid_amount

    {
      lead_wise_commissions: lead_wise_commissions,
      summary: {
        total_leads: lead_wise_commissions.count,
        total_commission: total_commission,
        paid_amount: paid_amount,
        pending_amount: pending_amount,
        paid_count: lead_wise_commissions.count { |lead| lead[:status] == 'paid' },
        pending_count: lead_wise_commissions.count { |lead| lead[:status] == 'pending' }
      }
    }
  end

  def find_distributor_by_id(distributor_id)
    Distributor.find_by(id: distributor_id)
  end

  def mark_single_lead_payout(lead_id)
    mark_single_lead_payout_with_details(lead_id, "DIST_#{Time.current.to_i}", Date.current, "Distributor payout for Lead ID: #{lead_id}")
  end

  def mark_single_lead_payout_with_details(lead_id, transaction_id, payment_date, notes)
    Rails.logger.info "Processing lead payout: lead_id=#{lead_id}, transaction_id=#{transaction_id}"

    policy = find_policy_by_lead_id(lead_id)
    unless policy
      Rails.logger.error "Policy not found for lead #{lead_id}"
      return { success: false, error: "Policy not found for lead #{lead_id}" }
    end

    # Find distributor from policy
    distributor = Distributor.find_by(id: policy.distributor_id) if policy.respond_to?(:distributor_id) && policy.distributor_id.present?
    unless distributor
      Rails.logger.error "Distributor not found for policy #{policy.id}"
      return { success: false, error: "Distributor not found for policy #{policy.id}" }
    end

    # Calculate distributor commission (3% of net premium)
    distributor_commission = policy.net_premium * 0.03
    Rails.logger.info "Calculated commission: #{distributor_commission} for policy #{policy.id}"

    # Get correct policy type for validation
    policy_type = get_policy_type(policy)

    # Check if already paid
    existing_payout = DistributorPayout.find_by(
      policy_type: policy_type,
      policy_id: policy.id,
      distributor_id: distributor.id
    )

    begin
      if existing_payout
        Rails.logger.info "Updating existing payout #{existing_payout.id}"
        existing_payout.mark_as_paid!(
          transaction_id: transaction_id,
          payment_date: payment_date || Date.current,
          notes: notes,
          processed_by: current_user&.email || 'system'
        )
        Rails.logger.info "Successfully updated existing payout"
      else
        Rails.logger.info "Creating new payout record"
        payout = DistributorPayout.create!(
          distributor_id: distributor.id,
          policy_type: policy_type,
          policy_id: policy.id,
          payout_amount: distributor_commission,
          payout_date: payment_date || Date.current,
          status: 'paid',
          transaction_id: transaction_id,
          payment_mode: 'bank_transfer',
          reference_number: "REF_#{lead_id}_#{Time.current.to_i}",
          notes: notes || "Distributor payout for Lead ID: #{lead_id}",
          processed_by: current_user&.email || 'system',
          processed_at: Time.current
        )
        Rails.logger.info "Successfully created new payout: #{payout.id}"
      end
      { success: true }
    rescue => e
      Rails.logger.error "Failed to process lead #{lead_id}: #{e.message}"
      Rails.logger.error e.backtrace.first(10).join("\n")
      { success: false, error: "Failed to process lead #{lead_id}: #{e.message}" }
    end
  end

  def mark_all_distributor_payouts(distributor_id)
    distributor = Distributor.find_by(id: distributor_id)
    return unless distributor

    # Find all pending distributor payouts
    paid_policies = get_all_paid_policies
    paid_policies.each do |policy|
      next unless policy.lead_id.present?
      next unless policy.distributor_id == distributor_id.to_i

      # Check if not already paid
      policy_type = get_policy_type(policy)
      existing_payout = DistributorPayout.find_by(
        policy_type: policy_type,
        policy_id: policy.id,
        distributor_id: distributor_id,
        status: 'paid'
      )
      next if existing_payout

      mark_single_lead_payout(policy.lead_id)
    end
  end

  def get_policy_type(policy)
    case policy.class.name
    when 'HealthInsurance'
      'health'
    when 'LifeInsurance'
      'life'
    when 'MotorInsurance'
      'motor'
    when 'OtherInsurance'
      'other'
    else
      'health' # fallback
    end
  end

  def authorize_admin_access
    redirect_to root_path unless current_user&.user_type == 'admin'
  end
end
