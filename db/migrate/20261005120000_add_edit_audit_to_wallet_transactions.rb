class AddEditAuditToWalletTransactions < ActiveRecord::Migration[8.0]
  # Admin can correct a wallet ledger entry (amount / note); record who and when.
  def change
    add_column :wallet_transactions, :edited_at, :datetime
    add_column :wallet_transactions, :edited_by, :string
  end
end
