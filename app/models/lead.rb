class Lead < ApplicationRecord
  include PgSearch::Model

  validates :name, presence: true
  validates :contact_number, presence: true, uniqueness: { message: "Contact number already exists" }, format: { with: /\A[\+]?[0-9\s\-\(\)]+\z/, message: "Invalid phone number format" }
  validates :email, uniqueness: { message: "Email already exists" }, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :current_stage, presence: true, inclusion: { in: ['consultation', 'one_on_one', 'converted', 'policy_created', 'referral_settled'] }
  validates :lead_source, presence: true, inclusion: { in: ['online', 'offline', 'agent_referral', 'walk_in', 'tele_calling', 'campaign'] }
  validates :product_category, presence: true, inclusion: { in: ['insurance', 'investments', 'loans', 'taxation'] }
  validates :product_subcategory, presence: true
  validates :customer_type, presence: true, inclusion: { in: ['individual', 'corporate'] }
  validates :affiliate_id, presence: true, if: -> { !is_direct }
  validates :is_direct, inclusion: { in: [true, false] }

  # Individual Customer Required Fields
  validates :first_name, presence: true, format: { with: /\A[a-zA-Z\s]+\z/, message: "First name can only contain letters and spaces" }, if: :individual?
  validates :last_name, presence: true, format: { with: /\A[a-zA-Z\s]+\z/, message: "Last name can only contain letters and spaces" }, if: :individual?
  validates :middle_name, format: { with: /\A[a-zA-Z\s]*\z/, message: "Middle name can only contain letters and spaces" }, allow_blank: true, if: :individual?

  # Corporate Customer Required Fields
  validates :company_name, presence: true, if: :corporate?

  # Optional validations
  validates :gender, inclusion: { in: ['male', 'female', 'other'] }, allow_blank: true
  validates :marital_status, inclusion: { in: ['single', 'married', 'divorced', 'widowed'] }, allow_blank: true
  validates :pan_no, uniqueness: { message: "PAN number already exists" }, format: { with: /\A[A-Z]{5}\d{4}[A-Z]\z/ }, allow_blank: true
  validates :gst_no, format: { with: /\A\d{2}[A-Z]{5}\d{4}[A-Z]\d[Z\d][A-Z\d]\z/ }, allow_blank: true

  belongs_to :converted_customer, class_name: 'Customer', optional: true
  belongs_to :created_policy, class_name: 'Policy', optional: true
  belongs_to :affiliate, class_name: 'SubAgent', optional: true
  has_many :uploaded_documents, as: :documentable, class_name: 'Document', dependent: :destroy

  before_create :generate_lead_id
  before_update :update_stage_timestamp, if: :current_stage_changed?
  before_validation :set_name_from_customer_details

  enum :current_stage, {
    consultation: 'consultation',
    one_on_one: 'one_on_one',
    converted: 'converted',
    policy_created: 'policy_created',
    referral_settled: 'referral_settled'
  }

  enum :lead_source, {
    online: 'online',
    offline: 'offline',
    agent_referral: 'agent_referral',
    walk_in: 'walk_in',
    tele_calling: 'tele_calling',
    campaign: 'campaign'
  }

  enum :product_category, {
    insurance: 'insurance',
    investments: 'investments',
    loans: 'loans',
    taxation: 'taxation'
  }

  enum :customer_type, {
    individual: 'individual',
    corporate: 'corporate'
  }

  # Define valid subcategories for each category
  PRODUCT_SUBCATEGORIES = {
    'insurance' => ['life', 'health', 'motor', 'general', 'travel', 'other'],
    'investments' => ['mutual_fund', 'gold', 'nps', 'bonds', 'other'],
    'loans' => ['personal', 'home', 'business', 'other'],
    'taxation' => ['itr', 'other']
  }.freeze

  scope :by_stage, ->(stage) { where(current_stage: stage) }
  scope :by_source, ->(source) { where(lead_source: source) }
  scope :by_product_category, ->(category) { where(product_category: category) }
  scope :by_product_subcategory, ->(subcategory) { where(product_subcategory: subcategory) }
  scope :recent, -> { order(created_date: :desc) }
  scope :pending_conversion, -> { where(current_stage: ['consultation', 'one_on_one']) }
  scope :converted_leads, -> { where(current_stage: ['converted', 'policy_created', 'referral_settled']) }
  scope :direct_leads, -> { where(is_direct: true) }
  scope :referred_leads, -> { where(is_direct: false) }
  scope :by_affiliate, ->(affiliate_id) { where(affiliate_id: affiliate_id) }

  pg_search_scope :search_leads,
    against: [:name, :contact_number, :email, :referred_by, :product_category, :product_subcategory, :lead_id,
              :first_name, :middle_name, :last_name, :company_name],
    using: {
      tsearch: { prefix: true, any_word: true }
    }

  def converted?
    ['converted', 'policy_created', 'referral_settled'].include?(current_stage)
  end

  def can_convert_to_customer?
    current_stage == 'one_on_one' && converted_customer_id.nil?
  end

  def can_create_policy?
    current_stage == 'converted' && converted_customer_id.present?
  end

  def can_settle_referral?
    current_stage == 'policy_created' && !transferred_amount && referral_amount > 0
  end

  def full_address
    [address, city, state].compact.join(', ')
  end

  def stage_badge_class
    case current_stage
    when 'consultation' then 'bg-info'
    when 'one_on_one' then 'bg-warning'
    when 'converted' then 'bg-success'
    when 'policy_created' then 'bg-primary'
    when 'referral_settled' then 'bg-dark'
    else 'bg-secondary'
    end
  end

  def source_badge_class
    case lead_source
    when 'online', 'campaign' then 'bg-info'
    when 'agent_referral' then 'bg-success'
    when 'walk_in' then 'bg-secondary'
    when 'tele_calling' then 'bg-purple'
    when 'offline' then 'bg-warning'
    else 'bg-light'
    end
  end

  def product_badge_class
    case product_category
    when 'insurance' then 'bg-primary'
    when 'investments' then 'bg-success'
    when 'loans' then 'bg-warning'
    when 'taxation' then 'bg-info'
    else 'bg-secondary'
    end
  end

  def next_stage
    case current_stage
    when 'consultation' then 'one_on_one'
    when 'one_on_one' then 'converted'
    when 'converted' then 'policy_created'
    when 'policy_created' then 'referral_settled'
    else nil
    end
  end

  def previous_stage
    case current_stage
    when 'one_on_one' then 'consultation'
    when 'converted' then 'one_on_one'
    when 'policy_created' then 'converted'
    when 'referral_settled' then 'policy_created'
    else nil
    end
  end

  def can_advance?
    next_stage.present?
  end

  def can_go_back?
    previous_stage.present? && !locked_stage?
  end

  def locked_stage?
    # Once policy is created, don't allow going back to prevent data inconsistency
    ['policy_created', 'referral_settled'].include?(current_stage)
  end

  def stage_progress_percentage
    stages = ['consultation', 'one_on_one', 'converted', 'policy_created', 'referral_settled']
    current_index = stages.index(current_stage) || 0
    ((current_index + 1).to_f / stages.length * 100).round
  end

  def available_stages_for_transition
    all_stages = ['consultation', 'one_on_one', 'converted', 'policy_created', 'referral_settled']

    # If stage is locked, only allow forward movement or stay in current stage
    if locked_stage?
      current_index = all_stages.index(current_stage) || 0
      return all_stages[current_index..-1]
    end

    all_stages
  end

  def stage_description
    case current_stage
    when 'consultation' then 'Initial consultation and needs assessment'
    when 'one_on_one' then 'Detailed discussion on premium and policy benefits'
    when 'converted' then 'Lead converted to customer'
    when 'policy_created' then 'Policy created and linked to customer'
    when 'referral_settled' then 'Referral payment processed'
    else 'Unknown stage'
    end
  end

  def display_name
    if individual?
      "#{first_name} #{middle_name} #{last_name}".strip.squeeze(' ')
    elsif corporate?
      company_name
    else
      name
    end
  end

  def individual?
    customer_type == 'individual'
  end

  def corporate?
    customer_type == 'corporate'
  end

  def full_name
    if individual?
      "#{first_name} #{middle_name} #{last_name}".strip.squeeze(' ')
    else
      company_name || name
    end
  end

  def product_display_name
    "#{product_category&.humanize} - #{product_subcategory&.humanize}"
  end

  def insurance_interest
    product_subcategory&.humanize
  end

  def referral_type
    is_direct ? 'Direct' : 'Referred'
  end

  def affiliate_name
    affiliate&.display_name || 'N/A'
  end

  def created_date=(value)
    if value.is_a?(String) && value.match(/^\d{2}\/\d{2}\/\d{4}$/)
      parts = value.split('/')
      day, month, year = parts[0].to_i, parts[1].to_i, parts[2].to_i
      super(Date.new(year, month, day))
    else
      super(value)
    end
  end

  def formatted_created_date
    created_date&.strftime('%d/%m/%Y')
  end

  private

  def generate_lead_id
    loop do
      self.lead_id = "LEAD-#{Date.current.strftime('%Y%m%d')}-#{rand(1000..9999)}"
      break unless Lead.exists?(lead_id: self.lead_id)
    end
  end

  def update_stage_timestamp
    self.stage_updated_at = Time.current
  end

  def set_name_from_customer_details
    if name.blank?
      if individual? && first_name.present? && last_name.present?
        self.name = "#{first_name} #{middle_name} #{last_name}".strip.squeeze(' ')
      elsif corporate? && company_name.present?
        self.name = company_name
      else
        # Fallback for cases where customer type isn't set yet
        self.name = 'Lead' if name.blank?
      end
    end
  end
end
