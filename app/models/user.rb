class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include PgSearch::Model

  # Associations
  has_many :policies, dependent: :destroy
  has_many_attached :profile_images
  has_many_attached :documents

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :mobile, presence: true, uniqueness: true
  validates :user_type, presence: true, inclusion: { in: ['admin', 'agent', 'sub_agent', 'customer'] }
  validates :role, presence: true

  # Enums
  enum :user_type, { admin: 'admin', agent: 'agent', sub_agent: 'sub_agent', customer: 'customer' }
  enum :role, { super_admin: 'super_admin', admin_role: 'admin', manager: 'manager', agent_role: 'agent' }

  # Scopes
  scope :active, -> { where(status: true) }
  scope :inactive, -> { where(status: false) }
  scope :by_type, ->(type) { where(user_type: type) }

  # Search
  pg_search_scope :search_users,
    against: [:first_name, :last_name, :email, :mobile, :pan_number],
    using: {
      tsearch: { prefix: true, any_word: true }
    }

  # Instance methods
  def full_name
    "#{first_name} #{last_name}".strip
  end

  def active?
    status
  end
end
