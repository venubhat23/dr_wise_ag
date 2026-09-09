class CreateWallets < ActiveRecord::Migration[8.0]
  def change
    create_table :wallets do |t|
      t.string :owner_type, null: false
      t.bigint :owner_id, null: false
      t.decimal :balance, precision: 12, scale: 2, default: 0, null: false

      t.timestamps
    end

    add_index :wallets, [:owner_type, :owner_id], unique: true

    create_table :wallet_transactions do |t|
      t.bigint :wallet_id, null: false
      t.string :txn_type, null: false # credit | debit
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.decimal :balance_after, precision: 12, scale: 2, null: false
      t.text :description
      t.string :performed_by

      t.timestamps
    end

    add_index :wallet_transactions, :wallet_id
    add_index :wallet_transactions, :created_at
    add_foreign_key :wallet_transactions, :wallets
  end
end
