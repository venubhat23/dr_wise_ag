class SubAgent < ApplicationRecord
  include PgSearch::Model

  # Password authentication
  has_secure_password

  # Create alias for backward compatibility - use Affiliate instead
  def self.inherited(subclass)
    super
    if subclass.name == 'Affiliate'
      # Don't create circular inheritance
      return
    end
  end

  # Store plain password for display purposes
  attr_accessor :store_plain_password, :plain_password
  # Note: state and city are now real database columns, not virtual attributes
  before_validation :set_default_password, on: :create
  before_validation :normalize_mobile_number
  before_save :store_password_if_changed
  before_save :set_location_ids_from_names
  before_save :add_country_code_to_mobile

  # Associations
  belongs_to :role
  has_many :sub_agent_documents, dependent: :destroy
  has_many :uploaded_documents, as: :documentable, class_name: 'Document', dependent: :destroy
  has_one :distributor_assignment, dependent: :destroy
  has_one :assigned_distributor, through: :distributor_assignment, source: :distributor
  belongs_to :distributor, optional: true
  has_one_attached :upload_main_document
  has_one_attached :profile_image
  has_many :customers, foreign_key: 'sub_agent_id'

  # Nested attributes for documents
  accepts_nested_attributes_for :sub_agent_documents, allow_destroy: true,
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
              message: "number is already registered with another affiliate",
              case_sensitive: false
            }
  validates :email, presence: true,
            uniqueness: {
              message: "address is already registered with another affiliate",
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
  validate :ensure_unique_across_distributors

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

  def age
    if birth_date.present?
      age = Date.current.year - birth_date.year
      age -= 1 if Date.current < birth_date + age.years
      age
    else
      nil
    end
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

  # Note: state and city are now real database columns, so getters/setters are not needed

  private

  def set_default_password
    if self.password.blank?
      self.password = 'admin123'
      self.password_confirmation = 'admin123'
      self.original_password = 'admin123'
    end
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

  def set_location_ids_from_names
    # Set state_id and city_id from names if they are present but IDs are blank
    if state.present? && state_id.blank?
      # Find matching state in LocationData using the state name
      state_key = LocationData::STATES_AND_CITIES.find do |key, state_data|
        state_data[:name].downcase == state.downcase
      end&.first

      if state_key
        # Use a consistent hash of the state key as state_id
        self.state_id = state_key.hash.abs % 1000
        Rails.logger.info "Set state_id #{self.state_id} for state '#{state}' (key: #{state_key})"
      end
    end

    # Set city_id from city name if city is present but city_id is blank
    if city.present? && city_id.blank?
      # Use a consistent hash of the city name as city_id
      self.city_id = city.hash.abs % 100000
      Rails.logger.info "Set city_id #{self.city_id} for city '#{city}'"
    end
  rescue => e
    Rails.logger.error "Error setting location IDs: #{e.message}"
    # Continue saving even if location ID setting fails
  end

  def store_password_if_changed
    if password.present? && (password_digest_changed? || new_record?)
      self.plain_password = password
      # Always update original_password when password changes
      self.original_password = password
    end
  end

  def find_state_name_by_id(state_id)
    return nil unless state_id.present?
    # Since we generate state_id as hash % 1000, we need to reverse lookup
    LocationData::STATES_AND_CITIES.each do |key, state_data|
      if (key.hash.abs % 1000) == state_id
        return state_data[:name]
      end
    end
    nil
  end

  def find_city_name_by_id(city_id)
    return nil unless city_id.present?
    # Search through all states and cities to find the one with matching city_id
    LocationData::STATES_AND_CITIES.each do |state_key, state_data|
      if state_data[:cities].is_a?(Array)
        state_data[:cities].each do |city_name|
          if (city_name.hash.abs % 100000) == city_id
            return city_name
          end
        end
      end
    end
    nil
  end

  def ensure_unique_across_distributors
    # Check if email exists in Distributor table
    if email.present?
      existing_distributor = Distributor.where(email: email)
      existing_distributor = existing_distributor.where.not(id: self.id) if persisted?
      if existing_distributor.exists?
        errors.add(:email, "address is already registered with an ambassador")
      end
    end

    # Check if mobile exists in Distributor table
    if mobile.present?
      existing_distributor = Distributor.where(mobile: mobile)
      existing_distributor = existing_distributor.where.not(id: self.id) if persisted?
      if existing_distributor.exists?
        errors.add(:mobile, "number is already registered with an ambassador")
      end
    end
  end
end