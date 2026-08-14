class AddVendorCommissionToClientServices < ActiveRecord::Migration[8.0]
  def change
    add_column :client_services, :vendor_commission_percentage, :decimal, precision: 8, scale: 2, default: "0.0"
    add_column :client_services, :vendor_commission_amount, :decimal, precision: 15, scale: 2, default: "0.0"
  end
end
