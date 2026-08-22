class CreateOtpVerifications < ActiveRecord::Migration[8.0]
  def change
    create_table :otp_verifications do |t|
      t.string :identifier, null: false
      t.string :identifier_type, null: false
      t.string :purpose, null: false, default: 'login'
      t.string :otp_digest, null: false
      t.integer :attempts, null: false, default: 0
      t.datetime :expires_at, null: false
      t.datetime :verified_at

      t.timestamps
    end

    add_index :otp_verifications, [:identifier, :purpose]
  end
end
