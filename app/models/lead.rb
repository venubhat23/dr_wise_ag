class Lead < ApplicationRecord
  include PgSearch::Model

  validates :name, presence: true
  validates :contact_number, presence: true
  validates :current_stage, presence: true, inclusion: { in: ['consultation', 'one_on_one', 'converted', 'policy_created', 'referral_settled'] }

  enum :current_stage, {
    consultation: 'consultation',
    one_on_one: 'one_on_one',
    converted: 'converted',
    policy_created: 'policy_created',
    referral_settled: 'referral_settled'
  }

  scope :by_stage, ->(stage) { where(current_stage: stage) }
  scope :recent, -> { order(created_date: :desc) }

  pg_search_scope :search_leads,
    against: [:name, :contact_number, :email, :referred_by, :product_interest],
    using: {
      tsearch: { prefix: true, any_word: true }
    }

  def converted?
    ['converted', 'policy_created', 'referral_settled'].include?(current_stage)
  end

  def can_convert_to_customer?
    current_stage == 'one_on_one'
  end
end
