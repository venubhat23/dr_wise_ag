class AddVendorToClientServicesAndMutualFunds < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_reference :client_services, :vendor, null: true, foreign_key: true, index: { algorithm: :concurrently }
    add_reference :mutual_funds, :vendor, null: true, foreign_key: true, index: { algorithm: :concurrently }
  end
end
