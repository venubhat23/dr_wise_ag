class CommissionCalculatorService
  # Commission percentage structure based on user requirements
  COMMISSION_RATES = {
    main_agent: 10.0,      # 10% of premium
    affiliate: 2.0,        # 2% of premium
    ambassador: 2.0,       # 2% of premium
    investor: 1.0,         # 1% of premium
    company_expense: 3.0   # 3% of premium (from main agent's share)
  }.freeze

  # Default commission distribution percentages (keeping existing for compatibility)
  DEFAULT_DISTRIBUTION_PERCENTAGES = {
    'sub_agent' => 40.0,
    'distributor' => 35.0,
    'investor' => 25.0
  }.freeze

  def self.create_payouts_for_policy(policy)
    new(policy).create_payouts
  end

  def self.calculate_commission_breakdown(policy)
    return {} unless policy.respond_to?(:total_premium) && policy.total_premium.present?

    premium = policy.total_premium.to_f

    # Get commission percentages from the policy (if stored) or use defaults
    main_agent_rate = policy.try(:main_agent_commission_percentage) || COMMISSION_RATES[:main_agent]
    affiliate_rate = policy.try(:affiliate_commission_percentage) || COMMISSION_RATES[:affiliate]
    ambassador_rate = policy.try(:ambassador_commission_percentage) || COMMISSION_RATES[:ambassador]
    investor_rate = policy.try(:investor_commission_percentage) || COMMISSION_RATES[:investor]
    company_expense_rate = policy.try(:company_expense_percentage) || COMMISSION_RATES[:company_expense]

    # Calculate base commission amounts
    main_agent_total = premium * (main_agent_rate / 100.0)
    affiliate_commission = premium * (affiliate_rate / 100.0)
    ambassador_commission = premium * (ambassador_rate / 100.0)
    investor_commission = premium * (investor_rate / 100.0)

    # Calculate deductions from main agent commission
    total_deductions = affiliate_commission + ambassador_commission + investor_commission
    company_expense = main_agent_total * (company_expense_rate / 100.0)

    # Main agent's final profit
    main_agent_profit = main_agent_total - total_deductions - company_expense

    {
      premium_amount: premium,
      main_agent: {
        total_commission: main_agent_total,
        deductions: {
          affiliate: affiliate_commission,
          ambassador: ambassador_commission,
          investor: investor_commission,
          company_expense: company_expense,
          total: total_deductions + company_expense
        },
        final_profit: main_agent_profit
      },
      payouts: {
        affiliate: affiliate_commission,
        ambassador: ambassador_commission,
        investor: investor_commission,
        company_expense: company_expense
      },
      summary: {
        total_commission_generated: main_agent_total,
        total_distributed: total_deductions,
        company_expense: company_expense,
        agent_profit: main_agent_profit
      }
    }
  end

  def self.get_policy_commission_summary(policy)
    breakdown = calculate_commission_breakdown(policy)
    return nil if breakdown.empty?

    # Get existing payout records
    policy_type = policy.class.name.underscore.gsub('_insurance', '')
    existing_payouts = CommissionPayout.where(
      policy_type: policy_type,
      policy_id: policy.id
    )

    {
      policy: {
        type: policy_type.titleize,
        number: policy.policy_number,
        customer: policy.customer.display_name,
        premium: breakdown[:premium_amount]
      },
      commission_breakdown: breakdown,
      payout_status: {
        affiliate: get_payout_status(existing_payouts, 'affiliate'),
        ambassador: get_payout_status(existing_payouts, 'ambassador'),
        investor: get_payout_status(existing_payouts, 'investor'),
        company_expense: get_payout_status(existing_payouts, 'company_expense')
      }
    }
  end

  def initialize(policy)
    @policy = policy
    @policy_type = determine_policy_type
    @commission_amount = extract_commission_amount
  end

  def create_payouts
    return false unless valid_policy?

    ActiveRecord::Base.transaction do
      # Create commission receipt first
      commission_receipt = create_commission_receipt

      # Create individual payouts for each distribution type
      DEFAULT_DISTRIBUTION_PERCENTAGES.each do |recipient_type, percentage|
        create_payout_for_recipient(recipient_type, percentage, commission_receipt)
      end

      # Create audit log
      create_audit_log(commission_receipt)
    end

    true
  rescue StandardError => e
    Rails.logger.error "Failed to create payouts for policy #{@policy.id}: #{e.message}"
    false
  end

  private

  def valid_policy?
    @policy.present? && @commission_amount > 0
  end

  def determine_policy_type
    case @policy.class.name
    when 'HealthInsurance'
      'health'
    when 'LifeInsurance'
      'life'
    when 'MotorInsurance'
      'motor'
    else
      'other'
    end
  end

  def extract_commission_amount
    # Try different commission amount fields based on policy type
    @policy.try(:commission_amount) ||
    @policy.try(:main_agent_commission_percentage) ||
    calculate_commission_from_premium ||
    0.0
  end

  def calculate_commission_from_premium
    premium = @policy.try(:total_premium) || @policy.try(:premium_amount) || 0
    commission_percentage = @policy.try(:main_agent_commission_percentage) || 0

    return 0.0 if premium == 0 || commission_percentage == 0

    (premium * commission_percentage) / 100.0
  end

  def create_commission_receipt
    CommissionReceipt.create!(
      policy_type: @policy_type,
      policy_id: @policy.id,
      total_commission_received: @commission_amount,
      received_date: Date.current,
      status: 'received',
      insurance_company_name: extract_insurance_company_name,
      policy_number: @policy.try(:policy_number) || "POL-#{@policy.id}",
      customer_name: extract_customer_name,
      notes: "Auto-created for policy #{@policy.id}"
    )
  end

  def create_payout_for_recipient(recipient_type, percentage, commission_receipt)
    payout_amount = (@commission_amount * percentage) / 100.0

    # Create the main payout entry
    payout = CommissionPayout.create!(
      policy_type: @policy_type,
      policy_id: @policy.id,
      payout_to: recipient_type,
      payout_amount: payout_amount,
      payout_date: calculate_payout_date,
      status: 'pending',
      commission_amount_received: @commission_amount,
      distribution_percentage: percentage,
      processed_by: 'system_auto',
      notes: "Auto-created #{percentage}% distribution for #{recipient_type}"
    )

    # Create the detailed payout distribution entry
    PayoutDistribution.create!(
      commission_receipt: commission_receipt,
      recipient_type: recipient_type,
      recipient_id: find_recipient_id(recipient_type),
      distribution_percentage: percentage,
      calculated_amount: payout_amount,
      paid_amount: 0.0,
      pending_amount: payout_amount,
      status: 'pending',
      notes: "Auto-calculated distribution for #{@policy_type} policy ##{@policy.id}"
    )

    payout
  end

  def calculate_payout_date
    # Schedule payouts for 30 days from policy creation
    Date.current + 30.days
  end

  def find_recipient_id(recipient_type)
    case recipient_type
    when 'sub_agent'
      @policy.try(:sub_agent_id)
    when 'distributor'
      # For now, return nil - could be enhanced to find related distributor
      nil
    when 'investor'
      # For now, return nil - could be enhanced to find related investor
      nil
    else
      nil
    end
  end

  def extract_insurance_company_name
    @policy.try(:insurance_company_name) ||
    @policy.try(:insurance_company) ||
    'Unknown Company'
  end

  def extract_customer_name
    if @policy.respond_to?(:customer) && @policy.customer
      @policy.customer.display_name
    else
      'Unknown Customer'
    end
  end

  def create_audit_log(commission_receipt)
    PayoutAuditLog.create_log(
      commission_receipt,
      'auto_created',
      'system',
      {},
      "Automatically created commission distribution for #{@policy_type} policy ##{@policy.id}",
      'system'
    )
  rescue StandardError => e
    # Don't fail the transaction if audit logging fails
    Rails.logger.warn "Failed to create audit log: #{e.message}"
  end

  def self.get_payout_status(existing_payouts, payout_type)
    payout = existing_payouts.find { |p| p.payout_to == payout_type }
    return { status: 'not_applicable', amount: 0 } unless payout

    {
      status: payout.status,
      amount: payout.payout_amount,
      payout_date: payout.payout_date,
      transaction_id: payout.transaction_id,
      id: payout.id
    }
  end
end