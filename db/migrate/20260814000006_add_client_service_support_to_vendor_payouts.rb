class AddClientServiceSupportToVendorPayouts < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    change_column_null :vendor_payouts, :lead_id, true

    add_reference :vendor_payouts, :client_service, foreign_key: true, index: false

    remove_index :vendor_payouts, :lead_id, algorithm: :concurrently
    add_index :vendor_payouts, :lead_id, unique: true, where: "lead_id IS NOT NULL",
              algorithm: :concurrently, name: "index_vendor_payouts_on_lead_id"
    add_index :vendor_payouts, :client_service_id, unique: true, where: "client_service_id IS NOT NULL",
              algorithm: :concurrently

    add_column :client_services, :status_updated_at, :datetime
  end
end
