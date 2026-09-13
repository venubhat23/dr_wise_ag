class WithdrawalRequest < ApplicationRecord
  belongs_to :owner, polymorphic: true
  belongs_to :wallet_transaction, optional: true

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  MIN_AMOUNT = 100

  validates :amount, numericality: { greater_than_or_equal_to: MIN_AMOUNT },
                      allow_nil: true
  validates :reason, presence: true, length: { maximum: 500 }
  validate :owner_kyc_approved, on: :create
  validate :amount_within_available_balance, on: :create
  validate :no_other_pending_request, on: :create

  scope :recent_first, -> { order(created_at: :desc, id: :desc) }

  def owner_label
    owner.display_name.presence || owner.email
  end

  def owner_kind
    owner_type == 'Distributor' ? 'Ambassador' : 'Affiliate'
  end

  # Debits the owner's wallet and marks the request approved, atomically.
  def approve!(reviewed_by:)
    raise ArgumentError, 'Only pending requests can be approved' unless pending?

    transaction do
      txn = owner.wallet!.debit!(
        amount,
        description: "Withdrawal approved: #{reason}",
        performed_by: reviewed_by
      )
      update!(status: :approved, reviewed_at: Time.current, reviewed_by: reviewed_by, wallet_transaction: txn)
    end
  end

  def reject!(reviewed_by:, reason: nil)
    raise ArgumentError, 'Only pending requests can be rejected' unless pending?

    update!(
      status: :rejected,
      reviewed_at: Time.current,
      reviewed_by: reviewed_by,
      rejection_reason: reason.presence || 'Rejected by admin'
    )
  end

  private

  def owner_kyc_approved
    return if owner.blank? || !owner.respond_to?(:kyc_approved?)

    errors.add(:base, 'Your KYC must be approved before you can request a withdrawal') unless owner.kyc_approved?
  end

  def amount_within_available_balance
    return if owner.blank? || amount.blank?

    available = owner.wallet&.balance || 0
    errors.add(:amount, 'cannot exceed your available wallet balance') if amount > available
  end

  def no_other_pending_request
    return if owner.blank?

    if WithdrawalRequest.where(owner: owner, status: :pending).where.not(id: id).exists?
      errors.add(:base, 'You already have a withdrawal request awaiting review')
    end
  end
end
