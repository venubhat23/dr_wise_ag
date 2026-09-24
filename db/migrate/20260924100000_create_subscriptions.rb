class CreateSubscriptions < ActiveRecord::Migration[8.0]
  # Yearly membership for self-registered ambassadors (Distributor) and
  # affiliates (SubAgent). The registration fee they already pay via Razorpay
  # now buys 1 year; after that they must renew (same fee) before they can use
  # the dashboard / app again.
  #
  # subscriptions = one row per successful payment (history).
  # <owner>.subscription_expires_at = denormalised current expiry, so login /
  # dashboard gating is a single column check.
  def up
    create_table :subscriptions do |t|
      t.references :subscriber, polymorphic: true, null: false
      t.string   :kind, null: false, default: "registration" # registration | renewal
      t.decimal  :amount, precision: 10, scale: 2, null: false, default: 0
      t.datetime :starts_at, null: false
      t.datetime :expires_at, null: false
      t.datetime :paid_at
      t.string   :razorpay_order_id
      t.string   :razorpay_payment_id
      t.timestamps
    end
    add_index :subscriptions, :expires_at
    add_index :subscriptions, :razorpay_payment_id, unique: true, where: "razorpay_payment_id IS NOT NULL"

    add_column :distributors, :subscription_expires_at, :datetime
    add_column :sub_agents, :subscription_expires_at, :datetime
    add_index :distributors, :subscription_expires_at
    add_index :sub_agents, :subscription_expires_at

    # Backfill: everyone who already paid the one-time fee gets 1 year from
    # the date they paid.
    { "distributors" => "Distributor", "sub_agents" => "SubAgent" }.each do |table, type|
      execute <<~SQL
        INSERT INTO subscriptions (subscriber_type, subscriber_id, kind, amount, starts_at, expires_at,
                                   paid_at, razorpay_order_id, razorpay_payment_id, created_at, updated_at)
        SELECT '#{type}', id, 'registration', COALESCE(payment_amount, 0), payment_paid_at,
               payment_paid_at + INTERVAL '1 year', payment_paid_at, razorpay_order_id, razorpay_payment_id,
               NOW(), NOW()
        FROM #{table}
        WHERE payment_paid = TRUE AND payment_paid_at IS NOT NULL
      SQL

      execute <<~SQL
        UPDATE #{table}
        SET subscription_expires_at = payment_paid_at + INTERVAL '1 year'
        WHERE payment_paid = TRUE AND payment_paid_at IS NOT NULL
      SQL
    end
  end

  def down
    remove_column :sub_agents, :subscription_expires_at
    remove_column :distributors, :subscription_expires_at
    drop_table :subscriptions
  end
end
