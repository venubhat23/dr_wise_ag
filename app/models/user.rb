class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include PgSearch::Model

  # Associations
  belongs_to :role, optional: true
  has_many :policies, dependent: :destroy
  has_many_attached :profile_images
  has_many_attached :documents

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :mobile, presence: true, uniqueness: true
  validates :user_type, presence: true, inclusion: { in: ['admin', 'agent', 'sub_agent', 'customer'] }
  # Note: role validation can be added later when roles are set up

  # Enums
  enum :user_type, { admin: 'admin', agent: 'agent', sub_agent: 'sub_agent', customer: 'customer' }

  # Callbacks
  after_update :role_changed_callback

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

  # Role-based permission methods
  def role_name
    role&.name
  end

  def role_display_name
    role&.display_name || 'No Role Assigned'
  end

  def has_role?(role_name)
    return false unless role
    role.name == role_name.to_s
  end

  def has_permission?(module_name, action_type)
    return false unless role

    # Cache user abilities for performance
    Rails.cache.fetch("user_#{id}_abilities", expires_in: 1.hour) do
      role.permissions.pluck(:module_name, :action_type)
    end.include?([module_name.to_s, action_type.to_s])
  end

  def can_access_module?(module_name)
    return false unless role
    role.permissions.exists?(module_name: module_name.to_s)
  end

  def accessible_modules
    return [] unless role
    role.permissions.distinct.pluck(:module_name)
  end

  def module_permissions(module_name)
    return [] unless role
    role.permissions.where(module_name: module_name.to_s).pluck(:action_type)
  end

  # Legacy support for existing code that checks user_type
  def admin?
    user_type == 'admin'
  end

  def agent?
    user_type == 'agent'
  end

  def customer?
    user_type == 'customer'
  end

  def super_admin?
    has_role?('super_admin')
  end

  # Clear abilities cache when role changes
  def clear_abilities_cache
    Rails.cache.delete("user_#{id}_abilities")
  end

  private

  # Clear cache when role changes
  def role_changed_callback
    clear_abilities_cache if role_id_changed?
  end
end
