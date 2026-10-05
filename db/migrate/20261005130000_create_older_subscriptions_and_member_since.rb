class CreateOlderSubscriptionsAndMemberSince < ActiveRecord::Migration[8.0]
  # Older subscriptions: membership years an ambassador / affiliate paid before
  # subscriptions were tracked in the app. History only - unlike `subscriptions`
  # they never change subscription_expires_at, so they can't block anyone.
  # member_since: date the person joined, set by admin (blank = derived).
  def change
    create_table :older_subscriptions do |t|
      t.references :subscriber, polymorphic: true, null: false
      t.date    :starts_on, null: false
      t.date    :ends_on, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false, default: 0
      t.date    :paid_on
      t.text    :notes
      t.string  :created_by
      t.timestamps
    end

    add_column :sub_agents, :member_since, :date
    add_column :distributors, :member_since, :date
  end
end
