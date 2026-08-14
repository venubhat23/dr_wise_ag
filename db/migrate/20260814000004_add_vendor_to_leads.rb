class AddVendorToLeads < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_reference :leads, :vendor, null: true, foreign_key: true, index: { algorithm: :concurrently }
  end
end
