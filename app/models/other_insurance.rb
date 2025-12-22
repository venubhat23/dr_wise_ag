class OtherInsurance < ApplicationRecord
  belongs_to :policy
  has_many_attached :documents
  has_many_attached :policy_documents

  # Callbacks
  after_create :create_commission_payouts
  after_create :create_lead_record

  # Validations
  validates :policy_start_date, presence: true
  validates :policy_end_date, presence: true
  validates :policy_number, presence: true, uniqueness: true

  # Scopes
  scope :active, -> { where('policy_end_date >= ?', Date.current) }
  scope :expired, -> { where('policy_end_date < ?', Date.current) }
  scope :expiring_soon, -> { where(policy_end_date: Date.current..30.days.from_now) }

  # Instance methods
  def active?
    policy_end_date >= Date.current
  end

  def expired?
    policy_end_date < Date.current
  end

  def expiring_soon?
    policy_end_date.between?(Date.current, 30.days.from_now)
  end

  def days_until_expiry
    (policy_end_date - Date.current).to_i
  end

  def customer
    policy&.customer
  end

  def policy_number
    read_attribute(:policy_number) || "OTHER-#{id}"
  end

  def net_premium
    read_attribute(:net_premium) || total_premium
  end

  private

  def create_commission_payouts
    # Only create payouts if commission amount is available and policy is not customer-added
    return unless commission_amount.present? && commission_amount > 0
    return if is_customer_added? # Skip auto-creation for customer-added policies

    # Use the enhanced commission calculator service to create payouts
    CommissionCalculatorService.create_enhanced_payouts_for_policy(self)
  rescue StandardError => e
    # Don't fail policy creation if payout creation fails
    Rails.logger.error "Failed to create payouts for other insurance #{id}: #{e.message}"
  end

  def create_lead_record
    return if lead_id.present? # Skip if lead already exists
    return unless policy&.customer # Skip if no customer

    LeadGeneratorService.create_lead_for_insurance(self)
  rescue StandardError => e
    Rails.logger.error "Failed to create lead for other insurance #{id}: #{e.message}"
  end
end
