class CreateWithdrawalRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :withdrawal_requests do |t|
      t.string :owner_type, null: false
      t.bigint :owner_id, null: false
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.text :reason, null: false
      t.integer :status, null: false, default: 0 # pending | approved | rejected
      t.text :rejection_reason
      t.datetime :reviewed_at
      t.string :reviewed_by
      t.bigint :wallet_transaction_id

      t.timestamps
    end

    add_index :withdrawal_requests, [:owner_type, :owner_id]
    add_index :withdrawal_requests, :status
    add_foreign_key :withdrawal_requests, :wallet_transactions
  end
end
