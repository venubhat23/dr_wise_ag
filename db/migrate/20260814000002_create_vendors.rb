class CreateVendors < ActiveRecord::Migration[8.0]
  def change
    create_table :vendors do |t|
      t.string :name, null: false
      t.string :company_name
      t.string :email
      t.string :phone_number
      t.text :address
      t.string :gst_number
      t.text :notes
      t.integer :status, default: 0, null: false

      t.timestamps
    end
    add_index :vendors, :email
    add_index :vendors, :phone_number
    add_index :vendors, :status
    add_index :vendors, :gst_number
    add_index :vendors, :created_at

    create_table :vendor_products do |t|
      t.references :vendor, null: false, foreign_key: true
      t.string :product_category, null: false
      t.string :product_subcategory, null: false
      t.decimal :commission_percentage, precision: 8, scale: 2, default: "0.0"

      t.timestamps
    end
    add_index :vendor_products, [:vendor_id, :product_category, :product_subcategory],
              unique: true, name: 'idx_vendor_products_unique'
  end
end
