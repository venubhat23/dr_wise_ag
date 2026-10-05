class Wallet < ApplicationRecord
  belongs_to :owner, polymorphic: true
  has_many :wallet_transactions, dependent: :destroy
  has_many :wallet_holds, dependent: :destroy

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

  # `balance` is the ACTIVE wallet - the only money that can be withdrawn.
  def active_balance
    balance
  end

  # Active + inactive - everything the owner has earned, withdrawable or not.
  def total_balance
    balance + inactive_balance
  end

  # Money that is still locked (the INACTIVE wallet), waiting for its unlock rule.
  def inactive_balance
    # Use preloaded holds when a list page did `includes(wallet: :wallet_holds)`.
    return wallet_holds.select(&:locked?).sum(BigDecimal(0), &:amount) if wallet_holds.loaded?

    wallet_holds.locked.sum(:amount)
  end

  # Parks money in the inactive wallet. Returns the WalletHold; if the unlock
  # rule is already satisfied it is released straight away.
  def lock_credit!(amount, description:, kind:, trigger_sub_agent: nil)
    hold = wallet_holds.create!(
      amount: normalize_amount(amount),
      kind: kind,
      description: description,
      trigger_sub_agent: trigger_sub_agent
    )
    WalletUnlockService.release_if_qualified!(hold)
    hold
  end

  # Moves a locked hold into the active balance (with a ledger credit).
  # Safe to call repeatedly - a hold is only ever released once.
  def release_hold!(hold, performed_by: 'system')
    with_lock do
      hold.reload
      return nil unless hold.locked?

      txn = credit!(hold.amount, description: "Unlocked: #{hold.description}", performed_by: performed_by)
      hold.update!(status: 'released', released_at: Time.current, wallet_transaction: txn)
      txn
    end
  end

  # --- Admin corrections -------------------------------------------------
  # Each one rewrites the ledger and then recalculates every balance_after
  # (oldest first) and the wallet balance, rolling back if the balance would
  # go below zero at any point.

  # Sets the active balance to `target` by recording the difference as a
  # credit / debit, so the history still adds up.
  def set_balance!(target, description: nil, performed_by: nil)
    target = target.to_d
    raise ArgumentError, 'Balance cannot be negative' if target.negative?

    diff = target - balance
    raise ArgumentError, "Balance is already #{balance.to_f}" if diff.zero?

    note = description.presence || "Balance adjusted from #{balance.to_f} to #{target.to_f}"
    diff.positive? ? credit!(diff, description: note, performed_by: performed_by) : debit!(-diff, description: note, performed_by: performed_by)
  end

  def edit_transaction!(txn, amount: nil, description: nil, performed_by: nil)
    with_lock(requires_new: true) do
      if amount.present? && amount.to_d != txn.amount
        raise ArgumentError, "#{txn.link_reason} - only the note can be changed" if txn.linked?

        txn.amount = normalize_amount(amount)
      end
      txn.description = description unless description.nil?
      return txn unless txn.changed?

      opening = opening_balance
      txn.edited_at = Time.current
      txn.edited_by = performed_by
      txn.save!
      recalculate_balances!(opening)
      txn
    end
  end

  def delete_transaction!(txn)
    with_lock(requires_new: true) do
      raise ArgumentError, "#{txn.link_reason} - it cannot be deleted" if txn.linked?

      opening = opening_balance
      txn.destroy!
      recalculate_balances!(opening)
    end
  end

  # Locked (inactive) amounts: change amount / note while still locked.
  def edit_hold!(hold, amount: nil, description: nil)
    raise ArgumentError, 'Only locked amounts can be edited' unless hold.locked?

    hold.amount = normalize_amount(amount) if amount.present?
    hold.description = description unless description.nil?
    hold.save!
    hold
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

  # Whatever part of the balance the ledger doesn't explain (0 for a clean
  # ledger) - kept as the starting point so a recalculation never moves it.
  def opening_balance
    balance - (total_credited - total_debited)
  end

  def recalculate_balances!(opening)
    running = opening
    wallet_transactions.reload.sort_by { |t| [t.created_at, t.id] }.each do |t|
      running += t.credit? ? t.amount : -t.amount
      if running.negative?
        raise ArgumentError, "This change would make the balance negative on #{t.created_at.strftime('%d %b %Y')} (#{t.description})"
      end
      t.update_columns(balance_after: running) if t.balance_after != running
    end
    update!(balance: running)
  end

  def normalize_amount(amount)
    amt = amount.to_d.abs
    raise ArgumentError, 'Amount must be greater than zero' if amt <= 0

    amt
  end
end
