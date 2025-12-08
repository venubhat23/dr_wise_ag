class LifeInsurance < ApplicationRecord
  include PgSearch::Model
  include InsuranceCompanyConstants

  # Associations
  belongs_to :customer
  belongs_to :sub_agent, class_name: 'SubAgent', optional: true
  belongs_to :agency_code, optional: true
  belongs_to :broker, optional: true
  has_many_attached :documents
  has_many_attached :policy_documents

  # Validations
  validates :policy_holder, presence: true
  validates :insurance_company_name, presence: true
  validates :policy_type, presence: true, inclusion: { in: ['New', 'Renewal', 'Porting'] }
  validates :policy_number, presence: true, uniqueness: true
  validates :policy_booking_date, presence: true
  validates :policy_start_date, presence: true
  validates :policy_end_date, presence: true
  validates :payment_mode, presence: true
  validates :sum_insured, presence: true, numericality: { greater_than: 0 }
  validates :net_premium, presence: true, numericality: { greater_than: 0 }
  validates :first_year_gst_percentage, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_premium, presence: true, numericality: { greater_than: 0 }
  validates :policy_term, presence: true, numericality: { greater_than: 0 }
  validates :premium_payment_term, presence: true, numericality: { greater_than: 0 }

  # Custom validation
  validate :company_name_must_be_valid
  validate :end_date_after_start_date

  # Enums for dropdowns
  POLICY_TYPES = ['New', 'Renewal', 'Porting'].freeze
  PAYMENT_MODES = ['Yearly', 'Half-Yearly', 'Quarterly', 'Monthly', 'Single'].freeze
  RELATIONSHIPS = ['Self', 'Spouse', 'Father', 'Mother', 'Son', 'Daughter', 'Brother', 'Sister', 'Other'].freeze
  ACCOUNT_TYPES = ['Savings', 'Current', 'Salary', 'Business'].freeze
  DOCUMENT_TYPES = ['PAN', 'Aadhaar', 'KYC', 'Payment Receipt', 'Medical Report', 'Other'].freeze

  # Scopes
  scope :active, -> { where('policy_end_date >= ?', Date.current) }
  scope :expired, -> { where('policy_end_date < ?', Date.current) }
  scope :expiring_soon, -> { where(policy_end_date: Date.current..30.days.from_now) }
  scope :new_policies, -> { where(policy_type: 'New') }
  scope :renewals, -> { where(policy_type: 'Renewal') }

  # Search
  pg_search_scope :search_life_policies,
    against: [:policy_number, :plan_name, :insurance_company_name, :insured_name],
    associated_against: {
      customer: [:first_name, :last_name, :company_name]
    },
    using: {
      tsearch: { prefix: true, any_word: true }
    }

  # Callbacks
  before_save :calculate_totals
  before_validation :set_policy_term_from_dates

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

  def affiliate_name
    sub_agent ? sub_agent.display_name : 'Self'
  end

  def total_rider_amount
    [
      term_rider_amount,
      critical_illness_rider_amount,
      accident_rider_amount,
      pwb_rider_amount,
      other_rider_amount
    ].compact.sum
  end

  def status
    return 'expired' if expired?
    return 'expiring_soon' if expiring_soon?
    'active'
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

  private

  def calculate_totals
    if net_premium.present?
      # Calculate GST amounts
      first_year_gst = net_premium * (first_year_gst_percentage.to_f / 100.0)
      second_year_gst = net_premium * (second_year_gst_percentage.to_f / 100.0)
      third_year_gst = net_premium * (third_year_gst_percentage.to_f / 100.0)

      # Total premium calculation (for first year)
      self.total_premium = net_premium + first_year_gst

      # Commission calculations
      if main_agent_commission_percentage.present?
        self.commission_amount = net_premium * (main_agent_commission_percentage.to_f / 100.0)
      end

      if commission_amount.present? && tds_percentage.present?
        self.tds_amount = commission_amount * (tds_percentage.to_f / 100.0)
        self.after_tds_value = commission_amount - tds_amount
      end
    end
  end

  def set_policy_term_from_dates
    if policy_start_date.present? && policy_end_date.present? && policy_term.blank?
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

  def end_date_after_start_date
    return unless policy_start_date && policy_end_date

    if policy_end_date <= policy_start_date
      errors.add(:policy_end_date, "must be after policy start date")
    end
  end
end
