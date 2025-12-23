class Admin::Payout2Controller < Admin::BaseController
  def index
    @payouts = fetch_payouts_with_details
    @total_payouts = @payouts.count
    @total_amount = @payouts.sum { |p| p[:total_commission] }
    @paid_amount = @payouts.select { |p| p[:paid_count] == p[:total_count] }.sum { |p| p[:total_commission] }
    @pending_amount = @total_amount - @paid_amount
  end

  def mark_as_paid
    @payout = find_payout_by_type_and_id
    commission_payouts = CommissionPayout.where(
      policy_type: params[:policy_type],
      policy_id: params[:policy_id]
    )

    commission_payouts.update_all(
      status: 'paid',
      processed_at: Time.current,
      processed_by: current_user.email
    )

    redirect_to admin_payout2_index_path, notice: 'All commissions marked as paid successfully!'
  end

  def commission_breakdown
    @payout = find_payout_by_type_and_id
    @commission_payouts = CommissionPayout.where(
      policy_type: params[:policy_type],
      policy_id: params[:policy_id]
    ).includes(:policy)

    respond_to do |format|
      format.html
      format.json do
        render json: {
          policy: {
            number: @payout.try(:policy_number),
            type: params[:policy_type],
            customer: @payout.try(:customer)&.display_name,
            company: @payout.try(:insurance_company_name)
          },
          commissions: @commission_payouts.map do |cp|
            {
              type: cp.payout_to.humanize,
              amount: cp.payout_amount,
              status: cp.status,
              date: cp.payout_date,
              reference: cp.reference_number
            }
          end
        }
      end
    end
  end

  private

  def fetch_payouts_with_details
    payouts = []

    # Get all insurance types and their policies
    %w[life health motor other].each do |policy_type|
      model_class = get_model_class(policy_type)
      next unless model_class

      model_class.includes(:customer, :sub_agent).find_each do |policy|
        commission_payouts = CommissionPayout.where(
          policy_type: policy_type,
          policy_id: policy.id
        )

        next if commission_payouts.empty?

        total_commission = commission_payouts.sum(:payout_amount)
        paid_count = commission_payouts.where(status: 'paid').count
        total_count = commission_payouts.count

        # Get commission breakdown
        breakdown = commission_payouts.group(:payout_to).sum(:payout_amount)

        payouts << {
          policy_id: policy.id,
          policy_type: policy_type,
          policy_number: policy.policy_number,
          customer_name: policy.customer&.display_name || 'Unknown',
          company_name: policy.insurance_company_name || 'Unknown',
          premium_amount: policy.respond_to?(:total_premium) ? policy.total_premium : 0,
          total_commission: total_commission,
          main_agent_commission: breakdown['main_agent'] || 0,
          main_agent_percentage: calculate_percentage(breakdown['main_agent'], policy),
          paid_count: paid_count,
          total_count: total_count,
          transfer_status: paid_count == total_count ? 'Completed' : "#{paid_count}/#{total_count}",
          breakdown: {
            affiliate: {
              amount: breakdown['affiliate'] || 0,
              percentage: calculate_commission_percentage(policy, 'sub_agent_commission_percentage')
            },
            ambassador: {
              amount: breakdown['ambassador'] || 0,
              percentage: calculate_commission_percentage(policy, 'ambassador_commission_percentage')
            },
            investor: {
              amount: breakdown['investor'] || 0,
              percentage: calculate_commission_percentage(policy, 'investor_commission_percentage')
            },
            company: {
              amount: breakdown['company_expense'] || 0,
              percentage: calculate_commission_percentage(policy, 'company_expenses_percentage')
            }
          },
          created_at: policy.created_at
        }
      end
    end

    payouts.sort_by { |p| p[:created_at] }.reverse
  end

  def get_model_class(policy_type)
    case policy_type
    when 'life'
      LifeInsurance
    when 'health'
      HealthInsurance
    when 'motor'
      MotorInsurance
    when 'other'
      OtherInsurance
    else
      nil
    end
  end

  def find_payout_by_type_and_id
    model_class = get_model_class(params[:policy_type])
    model_class&.find(params[:policy_id])
  end

  def calculate_percentage(amount, policy)
    return 0 if !amount || amount == 0 || !policy.respond_to?(:total_premium) || policy.total_premium == 0
    ((amount / policy.total_premium) * 100).round(2)
  end

  def calculate_commission_percentage(policy, field)
    return 0 unless policy.respond_to?(field)
    policy.try(field) || 0
  end
end