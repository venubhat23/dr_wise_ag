class AddTrackingColumnsToLifeInsurances < ActiveRecord::Migration[8.0]
  def change
    add_column :life_insurances, :is_customer_added, :boolean, default: false
    add_column :life_insurances, :is_agent_added, :boolean, default: false
    add_column :life_insurances, :is_admin_added, :boolean, default: false
    add_column :life_insurances, :policy_added_by_admin, :boolean, default: false
  end
end
