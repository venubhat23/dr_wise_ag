class VendorPayout < ApplicationRecord
  belongs_to :vendor
  belongs_to :lead

  after_commit :bump_vendor_cache_gen

  enum :status, { pending: 0, paid: 1 }

  validates :lead_id, uniqueness: true
  validates :lead_value, :commission_percentage, :commission_amount,
            numericality: { greater_than_or_equal_to: 0 }

  scope :recent, -> { order(created_at: :desc) }

  def mark_paid!(paid_by:, notes: nil)
    update!(status: :paid, paid_at: Time.current, paid_by: paid_by, notes: notes.presence || self.notes)
  end

  def mark_pending!
    update!(status: :pending, paid_at: nil, paid_by: nil)
  end

  private

  def bump_vendor_cache_gen
    Rails.cache.write("vendor_cache_gen", SecureRandom.hex(4))
  rescue => e
    Rails.logger.warn "Failed to bump vendor_cache_gen: #{e.message}"
  end
end
