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
end
