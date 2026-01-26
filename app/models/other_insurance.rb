class OtherInsurance < ApplicationRecord
  belongs_to :policy, optional: true
  belongs_to :customer
  belongs_to :sub_agent, optional: true
  belongs_to :agency_code, optional: true
  has_many_attached :documents
  has_many_attached :policy_documents
  has_many_attached :additional_documents

  # Callbacks
  before_create :inherit_customer_lead_id
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

  # Customer association is now direct, not through policy

  def policy_number
    read_attribute(:policy_number) || "OTHER-#{id}"
  end

  def net_premium
    read_attribute(:net_premium) || total_premium
  end

  private

  def create_commission_payouts
    # Create commission payouts using StructuredPayoutService
    StructuredPayoutService.create_for_policy(self, 'other') if defined?(StructuredPayoutService)
    Rails.logger.info "Commission payouts handled by StructuredPayoutService for other insurance #{id}"
  rescue StandardError => e
    Rails.logger.error "Failed to create commission payouts for other insurance #{id}: #{e.message}"
  end

  def create_lead_record
    return if lead_id.present? # Skip if lead already exists
    return unless customer # Skip if no customer
    return if respond_to?(:is_customer_added?) && is_customer_added? # Skip auto-creation for customer-added policies

    LeadGeneratorService.create_lead_for_insurance(self) if defined?(LeadGeneratorService)
  rescue StandardError => e
    Rails.logger.error "Failed to create lead for other insurance #{id}: #{e.message}"
  end

  # Inherit lead_id from customer if not already set
  def inherit_customer_lead_id
    return if lead_id.present? || customer.nil?

    # Check if customer has a valid lead_id with an actual Lead record
    if customer.respond_to?(:lead_id) &&
       customer.lead_id.present? &&
       Lead.exists?(lead_id: customer.lead_id) &&
       !OtherInsurance.exists?(lead_id: customer.lead_id)

      self.lead_id = customer.lead_id
      Rails.logger.info "Inherited existing lead_id #{customer.lead_id} for other insurance"
    else
      # Generate a unique lead_id for this policy using the service
      if defined?(LeadIdGeneratorService)
        self.lead_id = LeadIdGeneratorService.generate_for_policy(customer, 'OtherInsurance')
        Rails.logger.info "Generated new lead_id #{self.lead_id} for other insurance"
      end
    end
  rescue StandardError => e
    Rails.logger.error "Failed to inherit lead_id for other insurance: #{e.message}"
  end
end
