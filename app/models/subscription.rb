# One row per paid year of membership (registration or renewal) for an
# ambassador (Distributor) or affiliate (SubAgent). See Subscribable.
class Subscription < ApplicationRecord
  KINDS = %w[registration renewal].freeze

  belongs_to :subscriber, polymorphic: true

  validates :kind, inclusion: { in: KINDS }
  validates :starts_at, :expires_at, presence: true

  scope :recent_first, -> { order(starts_at: :desc, id: :desc) }

  def active?(at = Time.current)
    starts_at <= at && expires_at > at
  end

  def as_api_json
    {
      id: id,
      kind: kind,
      amount: amount.to_f,
      starts_at: starts_at,
      expires_at: expires_at,
      paid_at: paid_at,
      razorpay_payment_id: razorpay_payment_id,
      active: active?
    }
  end
end
