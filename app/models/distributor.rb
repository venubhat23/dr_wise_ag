class Distributor < ApplicationRecord
  include PgSearch::Model

  # Add password authentication
  has_secure_password validations: false

  # Associations
  belongs_to :investor, optional: true

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
  validates :mobile, format: {
    with: /\A[789]\d{9}\z/,
    message: "must be a valid 10-digit mobile number starting with 7, 8, or 9"
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

  # Callbacks
  before_validation :format_mobile_number
  before_validation :set_default_role_id, on: :create
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

  def format_mobile_number
    return if mobile.blank?

    # Remove all non-digit characters
    clean_mobile = mobile.to_s.gsub(/[^\d]/, '')

    # Handle different input formats - always extract 10-digit number
    if clean_mobile.start_with?('91') && clean_mobile.length == 12
      # 91XXXXXXXXXX format - extract 10-digit part
      digits_part = clean_mobile[2..-1]
      if digits_part.length == 10 && digits_part.match?(/\A[789]\d{9}\z/)
        self.mobile = digits_part
      else
        # Invalid format, let validation handle it
        self.mobile = clean_mobile
      end
    elsif clean_mobile.length == 10 && clean_mobile.match?(/\A[789]\d{9}\z/)
      # XXXXXXXXXX format - valid 10 digit number starting with 7, 8, or 9
      self.mobile = clean_mobile
    elsif clean_mobile.length == 11 && clean_mobile.start_with?('0')
      # 0XXXXXXXXXX format - remove leading zero
      digits_part = clean_mobile[1..-1]
      if digits_part.length == 10 && digits_part.match?(/\A[789]\d{9}\z/)
        self.mobile = digits_part
      else
        # Invalid format, let validation handle it
        self.mobile = clean_mobile
      end
    else
      # Any other format - let validation handle it
      self.mobile = clean_mobile
    end
  end

  def set_default_role_id
    self.role_id ||= 'distributor'
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
