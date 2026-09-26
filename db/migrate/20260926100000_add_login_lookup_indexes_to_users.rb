class AddLoginLookupIndexesToUsers < ActiveRecord::Migration[8.0]
  # users had no index on email or mobile, yet every web login
  # (User.find_for_database_authentication -> lower(email) / mobile), mobile
  # login and most ambassador/affiliate lookups (User.find_by(email:)) filter
  # on them. Non-unique on purpose: adding UNIQUE could fail on legacy
  # duplicates and change behaviour; this only speeds up reads.
  #
  # CONCURRENTLY so the live users table is never locked while building.
  disable_ddl_transaction!

  def change
    add_index :users, :email, algorithm: :concurrently, if_not_exists: true
    add_index :users, "lower((email)::text)", name: "index_users_on_lower_email",
              algorithm: :concurrently, if_not_exists: true
    add_index :users, :mobile, algorithm: :concurrently, if_not_exists: true
  end
end
