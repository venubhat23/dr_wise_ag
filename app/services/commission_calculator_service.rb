class CommissionCalculatorService
  # Default commission distribution percentages
  DEFAULT_DISTRIBUTION_PERCENTAGES = {
    'sub_agent' => 40.0,
    'distributor' => 35.0,
    'investor' => 25.0
  }.freeze

  def self.create_payouts_for_policy(policy)
    new(policy).create_payouts
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
end