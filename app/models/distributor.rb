class Distributor < ApplicationRecord
  include PgSearch::Model

  # Add password authentication
  has_secure_password validations: false

  # Associations

  has_many :distributor_documents, dependent: :destroy
  has_many :uploaded_documents, as: :documentable, class_name: 'Document', dependent: :destroy
  has_many :distributor_assignments, dependent: :destroy
  has_many :assigned_sub_agents, through: :distributor_assignments, source: :sub_agent
  has_many :sub_agents, dependent: :nullify
  has_one_attached :upload_main_document

  # Nested attributes for documents
  accepts_nested_attributes_for :distributor_documents, allow_destroy: true,
    reject_if: proc { |attributes|
      # Only reject if both document_type is blank AND there's no file
      # Also check for _destroy flag to allow deletions
      attributes['_destroy'] == '1' ? false : (attributes['document_type'].blank? && attributes['document_file'].blank?)
    }
  accepts_nested_attributes_for :uploaded_documents, allow_destroy: true, reject_if: :all_blank

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :mobile, presence: true,
            uniqueness: {
              message: "number is already registered with another ambassador",
              case_sensitive: false
            }
  validates :email, presence: true,
            uniqueness: {
              message: "address is already registered with another ambassador",
              case_sensitive: false
            },
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              message: "format is invalid"
            }
  validates :role_id, presence: true
  validates :gender, inclusion: { in: ['Male', 'Female', 'Other'] }, allow_blank: true
  validates :account_type, inclusion: { in: ['Savings', 'Current', 'Salary'] }, allow_blank: true

  # Custom validations
  validate :ensure_unique_across_affiliates

  # Default values
  before_validation :set_default_role_id, on: :create
  before_validation :normalize_mobile_number
  before_save :add_country_code_to_mobile
  before_create :generate_login_credentials

  # Enums
  enum :status, { active: 0, inactive: 1 }

  # Scopes
  scope :not_deactivated, -> { where(deactivated: false) }
  scope :deactivated, -> { where(deactivated: true) }
  scope :truly_active, -> { active.not_deactivated }

  # Search configuration
  pg_search_scope :search_by_name_mobile_email,
                  against: [:first_name, :last_name, :mobile, :email],
                  using: {
                    tsearch: { prefix: true }
                  }

  # Instance methods
  def full_name
    "#{first_name} #{middle_name} #{last_name}".strip
  end

  def display_name
    "#{first_name} #{last_name}"
  end

  def formatted_mobile
    mobile.presence || "N/A"
  end

  def formatted_email
    email.presence || "N/A"
  end

  def deactivated?
    deactivated == true
  end

  def deactivate!
    update(deactivated: true)
  end

  def activate!
    update(deactivated: false)
  end

  def truly_active?
    active? && !deactivated?
  end

  # Generate readable username and password
  def generate_readable_password
    words = ['Blue', 'Green', 'Red', 'Happy', 'Smart', 'Quick', 'Bright', 'Swift']
    numbers = (100..999).to_a
    "#{words.sample}#{words.sample}#{numbers.sample}"
  end

  private

  def set_default_role_id
    self.role_id ||= 'distributor'
  end

  def normalize_mobile_number
    return unless mobile.present?

    # Remove any non-digit characters
    clean_number = mobile.gsub(/\D/, '')

    # Remove country code if present (handles +91, 91, 0091 etc.)
    clean_number = clean_number.sub(/^(91|0091)/, '')

    # Remove leading zero if present
    clean_number = clean_number.sub(/^0/, '')

    # Keep only last 10 digits if longer
    if clean_number.length > 10
      clean_number = clean_number[-10..]
    end

    self.mobile = clean_number
  end

  def add_country_code_to_mobile
    return unless mobile.present?

    # Only add +91 if it's a 10-digit number
    if mobile.length == 10 && mobile.match?(/^\d{10}$/)
      self.mobile = "+91 #{mobile}"
    end
  end

  def generate_login_credentials
    # Generate username based on name and ID or timestamp
    if username.blank?
      base_username = "#{first_name.downcase}#{last_name.downcase}".gsub(/[^a-z0-9]/, '')
      timestamp = Time.current.to_i.to_s.last(4)
      self.username = "#{base_username}#{timestamp}"
    end

    # Generate password if not set
    if password_digest.blank?
      generated_password = generate_readable_password
      self.original_password = generated_password
      self.password = generated_password
    end
  end

  def ensure_unique_across_affiliates
    # Check if email exists in SubAgent table
    if email.present?
      existing_sub_agent = SubAgent.where(email: email)
      existing_sub_agent = existing_sub_agent.where.not(id: self.id) if persisted?
      if existing_sub_agent.exists?
        errors.add(:email, "address is already registered with an affiliate")
      end
    end

    # Check if mobile exists in SubAgent table
    if mobile.present?
      existing_sub_agent = SubAgent.where(mobile: mobile)
      existing_sub_agent = existing_sub_agent.where.not(id: self.id) if persisted?
      if existing_sub_agent.exists?
        errors.add(:mobile, "number is already registered with an affiliate")
      end
    end
  end
end
