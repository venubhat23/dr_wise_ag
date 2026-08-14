class VendorPayout < ApplicationRecord
  belongs_to :vendor
  belongs_to :lead, optional: true
  belongs_to :client_service, optional: true

  after_commit :bump_vendor_cache_gen

  enum :status, { pending: 0, paid: 1 }

  validates :lead_id, uniqueness: true, allow_nil: true
  validates :client_service_id, uniqueness: true, allow_nil: true
  validates :lead_value, :commission_percentage, :commission_amount,
            numericality: { greater_than_or_equal_to: 0 }
  validate :exactly_one_source_present

  scope :recent, -> { order(created_at: :desc) }

  def mark_paid!(paid_by:, notes: nil)
    update!(status: :paid, paid_at: Time.current, paid_by: paid_by, notes: notes.presence || self.notes)
  end

  def mark_pending!
    update!(status: :pending, paid_at: nil, paid_by: nil)
  end

  # The underlying Lead or ClientService this payout was generated for.
  def source
    lead || client_service
  end

  def source_name
    lead&.name || client_service&.customer&.display_name
  end

  def source_ref
    lead&.lead_id || client_service&.reference_number
  end

  private

  def exactly_one_source_present
    return if lead_id.present? ^ client_service_id.present?

    errors.add(:base, "must belong to exactly one of a lead or a client service")
  end

  def bump_vendor_cache_gen
    VendorCacheGen.bump!
  end
end
