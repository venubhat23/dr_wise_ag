class Affiliate < ApplicationRecord
  include PgSearch::Model

  # Map to the sub_agents table
  self.table_name = 'sub_agents'

  # Password authentication
  has_secure_password

  # Store plain password for display purposes
  attr_accessor :store_plain_password
  before_save :store_password_if_changed

  # Associations
  belongs_to :role
  has_many :affiliate_documents, class_name: 'SubAgentDocument', foreign_key: 'sub_agent_id', dependent: :destroy
  has_many :uploaded_documents, as: :documentable, class_name: 'Document', dependent: :destroy
  has_one :ambassador_assignment, class_name: 'DistributorAssignment', foreign_key: 'sub_agent_id', dependent: :destroy
  has_one :assigned_ambassador, through: :ambassador_assignment, source: :distributor, class_name: 'Ambassador'
  belongs_to :ambassador, class_name: 'Ambassador', foreign_key: 'distributor_id', optional: true
  has_one_attached :upload_main_document
  has_many :customers, foreign_key: 'sub_agent_id'

  # Nested attributes for documents
  accepts_nested_attributes_for :affiliate_documents, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :uploaded_documents, allow_destroy: true, reject_if: :all_blank

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :mobile, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role_id, presence: true
  validates :gender, inclusion: { in: ['Male', 'Female', 'Other'] }, allow_blank: true
  validates :account_type, inclusion: { in: ['Savings', 'Current', 'Salary'] }, allow_blank: true

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

  def age
    if birth_date.present?
      age = Date.current.year - birth_date.year
      age -= 1 if Date.current < birth_date + age.years
      age
    else
      nil
    end
  end

  private

  def store_password_if_changed
    if password.present? && (password_digest_changed? || new_record?)
      self.plain_password = password
      self.original_password = password if new_record?
    end
  end
end