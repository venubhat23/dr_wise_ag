class Investor < ApplicationRecord
  include PgSearch::Model

  # Password authentication
  has_secure_password validations: false

  # Associations
  has_many :investor_documents, dependent: :destroy
  has_one_attached :upload_main_document

  # Nested attributes for documents
  accepts_nested_attributes_for :investor_documents, allow_destroy: true, reject_if: :all_blank

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :mobile, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role_id, presence: true
  validates :username, presence: true, uniqueness: true
  validates :gender, inclusion: { in: ['Male', 'Female', 'Other'] }, allow_blank: true
  validates :account_type, inclusion: { in: ['Savings', 'Current', 'Salary'] }, allow_blank: true

  # Default values
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
