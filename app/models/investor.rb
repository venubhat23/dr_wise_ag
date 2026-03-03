class Investor < ApplicationRecord
  include PgSearch::Model

  # Password authentication
  has_secure_password validations: false

  # Associations
  has_many :investor_documents, dependent: :destroy
  has_many :health_insurances, dependent: :nullify
  has_many :motor_insurances, dependent: :nullify
  has_many :other_insurances, dependent: :nullify
  has_one_attached :upload_main_document

  # Nested attributes for documents
  accepts_nested_attributes_for :investor_documents, allow_destroy: true, reject_if: :all_blank

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :mobile, presence: true, uniqueness: true
  validates :mobile, format: {
    with: /\A(\+91[6-9]\d{9}|[6-9]\d{9})\z/,
    message: "must be a valid 10-digit Indian mobile number (6-9 as first digit). Format: 9XXXXXXXXX or +919XXXXXXXXX"
  }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role_id, presence: true
  validates :username, presence: true, uniqueness: true
  validates :gender, inclusion: { in: ['Male', 'Female', 'Other'] }, allow_blank: true
  validates :account_type, inclusion: { in: ['Savings', 'Current', 'Salary'] }, allow_blank: true

  # Callbacks
  before_validation :format_mobile_number
  before_validation :set_default_role_id, on: :create
  before_validation :generate_username, on: :create
  before_create :set_default_password

  # Enums
  enum :status, { active: 0, inactive: 1 }

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

  private

  def format_mobile_number
    return if mobile.blank?

    # Remove all non-digit characters except +
    clean_mobile = mobile.to_s.gsub(/[^\d+]/, '')

    # Handle different input formats
    if clean_mobile.start_with?('+91') && clean_mobile.length == 13
      # +91XXXXXXXXXX format - keep as is if valid
      digits_part = clean_mobile[3..-1]
      if digits_part.length == 10 && digits_part.match?(/\A[6-9]\d{9}\z/)
        self.mobile = clean_mobile
      else
        # Invalid format, let validation handle it
        self.mobile = clean_mobile
      end
    elsif clean_mobile.start_with?('91') && clean_mobile.length == 12
      # 91XXXXXXXXXX format - convert to +91XXXXXXXXXX
      digits_part = clean_mobile[2..-1]
      if digits_part.length == 10 && digits_part.match?(/\A[6-9]\d{9}\z/)
        self.mobile = "+91#{digits_part}"
      else
        # Invalid format, let validation handle it
        self.mobile = clean_mobile
      end
    elsif clean_mobile.length == 10 && clean_mobile.match?(/\A[6-9]\d{9}\z/)
      # XXXXXXXXXX format - valid 10 digit number
      self.mobile = clean_mobile
    elsif clean_mobile.length == 11 && clean_mobile.start_with?('0')
      # 0XXXXXXXXXX format - remove leading zero
      digits_part = clean_mobile[1..-1]
      if digits_part.length == 10 && digits_part.match?(/\A[6-9]\d{9}\z/)
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
    self.role_id ||= 'investor'
  end

  def generate_username
    return if username.present?

    base_username = "#{first_name&.downcase}#{last_name&.downcase}".gsub(/[^a-z]/, '')
    base_username = base_username[0..10] # Limit to 10 characters

    # Add numbers if username already exists
    counter = 1
    potential_username = base_username

    while Investor.exists?(username: potential_username)
      potential_username = "#{base_username}#{counter}"
      counter += 1
    end

    self.username = potential_username
  end

  def set_default_password
    # Only set default password if no password is provided and no password option is manual
    if password.blank? && original_password.blank?
      default_password = "Ganesha@123"
      self.password = default_password
      self.original_password = default_password
    elsif password.present? && original_password.blank?
      # If password is provided, store it in original_password too
      self.original_password = password
    end
  end
end
