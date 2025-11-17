class Customer < ApplicationRecord
  include PgSearch::Model

  # Associations
  has_many :family_members, dependent: :destroy
  has_many :policies, dependent: :destroy
  has_many_attached :profile_images
  has_many_attached :documents

  # Validations
  validates :customer_type, presence: true, inclusion: { in: ['individual', 'corporate'] }
  validates :first_name, presence: true, if: :individual?
  validates :last_name, presence: true, if: :individual?
  validates :company_name, presence: true, if: :corporate?
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :mobile, presence: true, uniqueness: true
  validates :address, presence: true
  validates :state, presence: true
  validates :city, presence: true
  validates :status, inclusion: { in: [true, false] }

  # Enums
  enum :customer_type, { individual: 'individual', corporate: 'corporate' }

  # Scopes
  scope :active, -> { where(status: true) }
  scope :inactive, -> { where(status: false) }
  scope :individuals, -> { where(customer_type: 'individual') }
  scope :corporates, -> { where(customer_type: 'corporate') }

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
end
