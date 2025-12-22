class Lead < ApplicationRecord
  include PgSearch::Model

  validates :name, presence: true
  validates :contact_number, presence: true, format: { with: /\A[\+]?[0-9]+\z/, message: "Invalid phone number format" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :current_stage, presence: true, inclusion: { in: ['consultation', 'one_on_one', 'converted', 'policy_created', 'referral_settled'] }
  validates :lead_source, presence: true, inclusion: { in: ['online', 'offline', 'agent_referral', 'walk_in', 'tele_calling', 'campaign'] }
  validates :product_interest, presence: true, inclusion: { in: ['health', 'life', 'motor', 'other'] }

  belongs_to :converted_customer, class_name: 'Customer', optional: true
  belongs_to :created_policy, class_name: 'Policy', optional: true

  before_create :generate_lead_id
  before_update :update_stage_timestamp, if: :current_stage_changed?

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

  enum :product_interest, {
    health: 'health',
    life: 'life',
    motor: 'motor',
    other: 'other'
  }

  scope :by_stage, ->(stage) { where(current_stage: stage) }
  scope :by_source, ->(source) { where(lead_source: source) }
  scope :by_product, ->(product) { where(product_interest: product) }
  scope :recent, -> { order(created_date: :desc) }
  scope :pending_conversion, -> { where(current_stage: ['consultation', 'one_on_one']) }
  scope :converted_leads, -> { where(current_stage: ['converted', 'policy_created', 'referral_settled']) }

  pg_search_scope :search_leads,
    against: [:name, :contact_number, :email, :referred_by, :product_interest, :lead_id],
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
    case product_interest
    when 'health' then 'bg-info'
    when 'life' then 'bg-danger'
    when 'motor' then 'bg-warning'
    when 'other' then 'bg-success'
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
    name
  end

  def insurance_interest
    product_interest&.humanize
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
end
