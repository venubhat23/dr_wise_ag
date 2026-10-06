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

  # Entries other records point at. Their amount can be edited (the linked
  # record is updated to match) but they can't be deleted.
  def linked?
    link_reason.present?
  end

  def link_reason
    return @link_reason if defined?(@link_reason)

    @link_reason =
      if linked_withdrawals.exists? then 'This entry is an approved withdrawal'
      elsif linked_holds.exists? then 'This entry is an unlocked amount'
      elsif linked_commission_payouts.exists? then 'This entry is a policy commission payout'
      end
  end

  # Copies an edited amount to the records this entry came from, so the
  # withdrawal request, released hold and policy commission payout (admin
  # pages and mobile APIs) all show the same figure.
  def sync_linked_amounts!
    now = Time.current
    linked_withdrawals.update_all(amount: amount, updated_at: now)
    linked_holds.update_all(amount: amount, updated_at: now)
    linked_commission_payouts.update_all(payout_amount: amount, updated_at: now)
  end

  def linked_withdrawals
    WithdrawalRequest.where(wallet_transaction_id: id)
  end

  def linked_holds
    WalletHold.where(wallet_transaction_id: id)
  end

  # CommissionWalletCredit stamps the payout with "WALLET-TXN-<id>".
  def linked_commission_payouts
    CommissionPayout.where(transaction_id: "WALLET-TXN-#{id}")
  end

  def edited?
    edited_at.present?
  end
end
