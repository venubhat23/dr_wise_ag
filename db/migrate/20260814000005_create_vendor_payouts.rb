class CreateVendorPayouts < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    create_table :vendor_payouts do |t|
      t.references :vendor, null: false, foreign_key: true
      t.references :lead, null: false, foreign_key: true, index: false
      t.decimal :lead_value, precision: 12, scale: 2, default: "0.0", null: false
      t.decimal :commission_percentage, precision: 8, scale: 2, default: "0.0", null: false
      t.decimal :commission_amount, precision: 12, scale: 2, default: "0.0", null: false
      t.integer :status, default: 0, null: false
      t.datetime :paid_at
      t.string :paid_by
      t.text :notes

      t.timestamps
    end

    add_index :vendor_payouts, :lead_id, unique: true, algorithm: :concurrently
    add_index :vendor_payouts, :status, algorithm: :concurrently
    add_index :vendor_payouts, :created_at, algorithm: :concurrently
  end
end
