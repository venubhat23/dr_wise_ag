class Wallet < ApplicationRecord
  belongs_to :owner, polymorphic: true
  has_many :wallet_transactions, dependent: :destroy

  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  # Adds money to the wallet and records a "credit" ledger entry.
  def credit!(amount, description:, performed_by: nil)
    apply_transaction!('credit', amount, description, performed_by)
  end

  # Removes money from the wallet and records a "debit" ledger entry.
  def debit!(amount, description:, performed_by: nil)
    amt = normalize_amount(amount)
    raise ArgumentError, 'Insufficient wallet balance' if amt > balance

    apply_transaction!('debit', amt, description, performed_by)
  end

  def total_credited
    wallet_transactions.where(txn_type: 'credit').sum(:amount)
  end

  def total_debited
    wallet_transactions.where(txn_type: 'debit').sum(:amount)
  end

  private

  def apply_transaction!(txn_type, amount, description, performed_by)
    amt = normalize_amount(amount)

    with_lock do
      new_balance = txn_type == 'credit' ? balance + amt : balance - amt
      update!(balance: new_balance)
      wallet_transactions.create!(
        txn_type: txn_type,
        amount: amt,
        balance_after: new_balance,
        description: description.presence || (txn_type == 'credit' ? 'Amount added' : 'Amount removed'),
        performed_by: performed_by
      )
    end
  end

  def normalize_amount(amount)
    amt = amount.to_d.abs
    raise ArgumentError, 'Amount must be greater than zero' if amt <= 0

    amt
  end
end
