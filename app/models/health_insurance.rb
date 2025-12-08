class HealthInsurance < ApplicationRecord
  include PgSearch::Model
  include InsuranceCompanyConstants

  # Associations
  belongs_to :customer
  belongs_to :sub_agent, class_name: 'SubAgent', optional: true
  belongs_to :agency_code, optional: true
  belongs_to :broker, optional: true
  has_many :health_insurance_members, dependent: :destroy
  has_many_attached :documents
  has_many_attached :policy_documents

  # Nested attributes
  accepts_nested_attributes_for :health_insurance_members, allow_destroy: true, reject_if: :all_blank

  # Validations
  validates :policy_holder, presence: true
  validates :insurance_company_name, presence: true
  validates :policy_type, presence: true, inclusion: { in: ['New', 'Renewal', 'Porting', 'Migration'] }
  validates :insurance_type, presence: true, inclusion: { in: ['Individual', 'Family Floater', 'Group'] }
  validates :policy_number, presence: true, uniqueness: true
  validates :policy_booking_date, presence: true
  validates :policy_start_date, presence: true
  validates :policy_end_date, presence: true
  validates :payment_mode, presence: true
  validates :sum_insured, presence: true, numericality: { greater_than: 0 }
  validates :net_premium, presence: true, numericality: { greater_than: 0 }
  validates :gst_percentage, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_premium, presence: true, numericality: { greater_than: 0 }

  # Custom validation
  validate :company_name_must_be_valid

  # Enums for dropdowns
  POLICY_TYPES = ['New', 'Renewal', 'Porting', 'Migration'].freeze
  INSURANCE_TYPES = ['Individual', 'Family Floater', 'Group'].freeze
  PAYMENT_MODES = ['Yearly', 'Half Yearly', 'Quarterly', 'Monthly', 'Single'].freeze

  # Scopes
  scope :active, -> { where('policy_end_date >= ?', Date.current) }
  scope :expired, -> { where('policy_end_date < ?', Date.current) }
  scope :expiring_soon, -> { where(policy_end_date: Date.current..30.days.from_now) }

  # Search
  pg_search_scope :search_health_policies,
    against: [:policy_number, :plan_name, :insurance_company_name],
    associated_against: {
      customer: [:first_name, :last_name, :company_name]
    },
    using: {
      tsearch: { prefix: true, any_word: true }
    }

  # Callbacks
  before_save :calculate_totals
  before_validation :set_policy_term

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

  def client_name
    customer.display_name
  end

  def policy_holder_options
    options = [['Self', 'Self']]
    if customer&.family_members&.any?
      customer.family_members.each do |member|
        options << [member.full_name, member.id.to_s]
      end
    end
    options
  end

  def affiliate_name
    sub_agent ? sub_agent.display_name : 'Self'
  end

  private

  def calculate_totals
    if net_premium.present? && gst_percentage.present?
      gst_amount = net_premium * (gst_percentage / 100.0)
      self.total_premium = net_premium + gst_amount
    end

    if net_premium.present? && main_agent_commission_percentage.present?
      self.commission_amount = net_premium * (main_agent_commission_percentage / 100.0)
    end

    if commission_amount.present? && tds_percentage.present?
      self.tds_amount = commission_amount * (tds_percentage / 100.0)
      self.after_tds_value = commission_amount - tds_amount
    end
  end

  def set_policy_term
    if policy_start_date.present? && policy_end_date.present?
      years = (policy_end_date - policy_start_date) / 365.25
      self.policy_term = years.round
    end
  end

  def company_name_must_be_valid
    return if insurance_company_name.blank?

    unless self.class.insurance_company_names.include?(insurance_company_name)
      errors.add(:insurance_company_name, "must be a valid insurance company")
    end
  end
end
