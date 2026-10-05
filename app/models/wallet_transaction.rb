class WalletTransaction < ApplicationRecord
  belongs_to :wallet

  TYPES = %w[credit debit].freeze

  validates :txn_type, inclusion: { in: TYPES }
  validates :amount, numericality: { greater_than: 0 }

  scope :recent_first, -> { order(created_at: :desc, id: :desc) }

  def credit?
    txn_type == 'credit'
  end

  def debit?
    txn_type == 'debit'
  end

  # Entries other records point at: their amount must stay as is.
  def linked?
    link_reason.present?
  end

  def link_reason
    return @link_reason if defined?(@link_reason)

    @link_reason =
      if WithdrawalRequest.exists?(wallet_transaction_id: id)
        'This entry is an approved withdrawal'
      elsif WalletHold.exists?(wallet_transaction_id: id)
        'This entry is an unlocked amount'
      end
  end

  def edited?
    edited_at.present?
  end
end
