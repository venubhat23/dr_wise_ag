# Inactive (locked) wallet money. `wallets.balance` stays the ACTIVE,
# withdrawable balance; every locked amount lives here as its own row until the
# business rule that unlocks it is met, then moves into the active balance.
class CreateWalletHolds < ActiveRecord::Migration[8.0]
  def change
    create_table :wallet_holds do |t|
      t.references :wallet, null: false, foreign_key: true
      t.decimal :amount, precision: 12, scale: 2, null: false
      # joining_credit | signup_bonus | referral_reward | legacy_balance
      t.string :kind, null: false
      t.text :description
      # The affiliate whose first policy unlocks this hold. NULL on an
      # ambassador wallet = unlocks when ANY of their affiliates writes a policy.
      t.bigint :trigger_sub_agent_id
      t.string :status, null: false, default: 'locked'
      t.datetime :released_at
      t.bigint :wallet_transaction_id
      t.timestamps
    end

    add_index :wallet_holds, [:wallet_id, :status]
    add_index :wallet_holds, [:trigger_sub_agent_id, :status]
  end
end
