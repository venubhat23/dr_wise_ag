class AddLeadIdToOtherInsurances < ActiveRecord::Migration[8.0]
  def change
    add_column :other_insurances, :lead_id, :string
    add_index :other_insurances, :lead_id
  end
end
