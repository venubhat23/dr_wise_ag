# A locked (inactive) amount sitting in a wallet. It is NOT part of
# Wallet#balance and cannot be withdrawn; Wallet#release_hold! moves it into
# the active balance once its unlock rule is met (see WalletUnlockService).
class WalletHold < ApplicationRecord
  belongs_to :wallet
  belongs_to :trigger_sub_agent, class_name: 'SubAgent', optional: true
  belongs_to :wallet_transaction, optional: true

  KINDS = %w[joining_credit signup_bonus referral_reward legacy_balance].freeze
  STATUSES = %w[locked released].freeze

  validates :kind, inclusion: { in: KINDS }
  validates :status, inclusion: { in: STATUSES }
  validates :amount, numericality: { greater_than: 0 }

  scope :locked, -> { where(status: 'locked') }
  scope :released, -> { where(status: 'released') }
  scope :recent_first, -> { order(created_at: :desc, id: :desc) }

  def locked?
    status == 'locked'
  end

  # Human-readable unlock condition, shown next to the amount.
  def unlock_condition
    if trigger_sub_agent_id.nil?
      'When any of your affiliates creates their first policy'
    elsif wallet.owner_type == 'SubAgent' && wallet.owner_id == trigger_sub_agent_id
      'When you create your first policy'
    else
      "When #{trigger_sub_agent&.display_name || 'the referred affiliate'} creates their first policy"
    end
  end
end
