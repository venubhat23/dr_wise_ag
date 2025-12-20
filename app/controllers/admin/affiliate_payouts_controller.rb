class Admin::AffiliatePayoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin_access

  skip_authorization_check
  skip_load_and_authorize_resource

  def index
    @affiliate_payouts = fetch_affiliate_payout_summary
    @total_affiliates = @affiliate_payouts.count
    @total_pending_amount = @affiliate_payouts.sum { |a| a[:pending_amount] }
    @total_paid_amount = @affiliate_payouts.sum { |a| a[:paid_amount] }
    @total_commission_earned = @affiliate_payouts.sum { |a| a[:total_commission] }
  end

  def show
    @affiliate_id = params[:id]
    @affiliate = find_affiliate_by_id(@affiliate_id)

    unless @affiliate
      redirect_to admin_affiliate_payouts_path, alert: 'Affiliate not found'
      return
    end

    @affiliate_details = fetch_affiliate_detailed_payouts(@affiliate_id)
    @lead_wise_commissions = @affiliate_details[:lead_wise_commissions]
    @summary = @affiliate_details[:summary]
  end

  private

  def fetch_affiliate_payout_summary
    affiliates_data = []

    # Get all affiliate commission payouts
    affiliate_payouts = CommissionPayout.where(payout_to: 'affiliate')
                                       .group_by { |payout| extract_affiliate_info(payout) }

    affiliate_payouts.each do |affiliate_info, payouts|
      next if affiliate_info.nil?

      # Group payouts by lead/policy for this affiliate
      lead_commissions = payouts.map do |payout|
        policy = get_policy_from_payout(payout)
        next unless policy

        {
          lead_id: policy.id,
          policy_number: policy.policy_number,
          customer_name: policy.customer&.display_name || 'Unknown',
          commission_amount: payout.payout_amount.to_f,
          status: payout.status,
          policy_type: payout.policy_type
        }
      end.compact

      total_commission = lead_commissions.sum { |lead| lead[:commission_amount] }
      paid_amount = lead_commissions.select { |lead| lead[:status] == 'paid' }
                                   .sum { |lead| lead[:commission_amount] }
      pending_amount = total_commission - paid_amount

      affiliates_data << {
        affiliate_id: affiliate_info[:id],
        affiliate_name: affiliate_info[:name],
        affiliate_email: affiliate_info[:email],
        lead_count: lead_commissions.count,
        lead_commissions: lead_commissions,
        total_commission: total_commission,
        paid_amount: paid_amount,
        pending_amount: pending_amount,
        commission_status: pending_amount > 0 ? 'pending' : 'completed'
      }
    end

    # Sort by total commission descending
    affiliates_data.sort_by { |a| -a[:total_commission] }
  end

  def fetch_affiliate_detailed_payouts(affiliate_id)
    affiliate_payouts = CommissionPayout.where(payout_to: 'affiliate')
                                       .select do |payout|
      affiliate_info = extract_affiliate_info(payout)
      affiliate_info&.dig(:id) == affiliate_id.to_i
    end

    lead_wise_commissions = affiliate_payouts.map do |payout|
      policy = get_policy_from_payout(payout)
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

  def extract_affiliate_info(payout)
    # For now, we'll create mock affiliate info based on payout data
    # In a real system, you'd have an Affiliate model or reference
    policy = get_policy_from_payout(payout)
    return nil unless policy

    # Generate consistent affiliate info based on customer or other criteria
    # This is a simplified approach - you might want to add actual affiliate tracking
    customer = policy.customer
    return nil unless customer

    # For demo purposes, we'll group by customer email domain or create mock affiliates
    affiliate_id = (customer.email.hash % 10).abs + 1

    {
      id: affiliate_id,
      name: "Affiliate #{affiliate_id}",
      email: "affiliate#{affiliate_id}@insurebook.com"
    }
  end

  def find_affiliate_by_id(affiliate_id)
    # Mock affiliate data - replace with actual affiliate model when available
    {
      id: affiliate_id.to_i,
      name: "Affiliate #{affiliate_id}",
      email: "affiliate#{affiliate_id}@insurebook.com"
    }
  end

  def get_policy_from_payout(payout)
    case payout.policy_type
    when 'health'
      HealthInsurance.find_by(id: payout.policy_id)
    when 'life'
      LifeInsurance.find_by(id: payout.policy_id)
    when 'motor'
      MotorInsurance.find_by(id: payout.policy_id)
    when 'other'
      OtherInsurance.find_by(id: payout.policy_id)
    end
  end

  def authorize_admin_access
    redirect_to root_path unless current_user&.user_type == 'admin'
  end
end