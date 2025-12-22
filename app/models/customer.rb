class Customer < ApplicationRecord
  include PgSearch::Model

  # Associations
  has_many :family_members, dependent: :destroy
  has_many :policies, dependent: :destroy
  has_many :corporate_members, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy
  has_one_attached :profile_image

  # Insurance associations
  has_many :health_insurances, dependent: :destroy
  has_many :life_insurances, dependent: :destroy
  has_many :motor_insurances, dependent: :destroy

  # New product associations
  has_many :investments, dependent: :destroy
  has_many :loans, dependent: :destroy
  has_many :tax_services, dependent: :destroy
  has_many :travel_packages, dependent: :destroy

  # Nested attributes
  accepts_nested_attributes_for :family_members, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :corporate_members, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :documents, allow_destroy: true, reject_if: :all_blank

  # Validations
  validates :customer_type, presence: true, inclusion: { in: ['individual', 'corporate'] }

  # Individual Customer Required Fields
  validates :first_name, presence: true, if: :individual?
  validates :last_name, presence: true, if: :individual?
  validates :mobile, presence: true, if: :individual?
  validates :mobile, uniqueness: true, allow_blank: true, if: :individual?

  # Corporate Customer Required Fields
  validates :company_name, presence: true, if: :corporate?
  validates :mobile, presence: true, if: :corporate?
  validates :mobile, uniqueness: true, allow_blank: true, if: :corporate?

  # Validations
  validates :status, inclusion: { in: [true, false] }

  # Set default values
  after_initialize :set_defaults

  def set_defaults
    self.status = true if status.nil?
    self.sub_agent = "Self" if sub_agent.blank?
  end

  # Email validations - different rules for individual vs corporate
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :corporate?
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true, if: :individual?

  # Optional validations
  validates :gender, inclusion: { in: ['male', 'female', 'other'] }, allow_blank: true
  validates :marital_status, inclusion: { in: ['single', 'married', 'divorced', 'widowed'] }, allow_blank: true
  validates :pan_no, format: { with: /\A[A-Z]{5}\d{4}[A-Z]\z/ }, allow_blank: true
  validates :gst_no, format: { with: /\A\d{2}[A-Z]{5}\d{4}[A-Z]\d[Z\d][A-Z\d]\z/ }, allow_blank: true

  # Enums
  enum :customer_type, { individual: 'individual', corporate: 'corporate' }

  # Scopes
  scope :active, -> { where(status: true) }
  scope :inactive, -> { where(status: false) }
  scope :individuals, -> { where(customer_type: 'individual') }
  scope :corporates, -> { where(customer_type: 'corporate') }

  # Callbacks
  before_validation :normalize_blank_values
  before_save :calculate_age

  # Search
  pg_search_scope :search_customers,
    against: [:first_name, :last_name, :company_name, :email, :mobile, :pan_number],
    using: {
      tsearch: { prefix: true, any_word: true }
    }

  # Instance methods
  def full_name
    if individual?
      "#{first_name} #{last_name}".strip
    else
      company_name
    end
  end

  def display_name
    individual? ? full_name : company_name
  end

  def active?
    status
  end

  def individual?
    customer_type == 'individual'
  end

  def corporate?
    customer_type == 'corporate'
  end

  # Cache busting callback
  after_update :bust_cache

  private

  def bust_cache
    Rails.cache.delete("customer_#{id}_full_name")
    Rails.cache.delete("customer_#{id}_display_name")
  end

  def normalize_blank_values
    # Convert empty strings to nil to prevent uniqueness validation issues
    self.mobile = nil if mobile.blank?
    self.email = nil if email.blank?
    self.pan_no = nil if pan_no.blank?
    self.gst_no = nil if gst_no.blank?
  end

  def calculate_age
    if birth_date.present?
      self.age = Date.current.year - birth_date.year
      self.age -= 1 if Date.current < birth_date + age.years
    end
  end
end
