class AddPolicyIdToOtherInsurances < ActiveRecord::Migration[8.0]
  def change
    add_column :other_insurances, :policy_id, :integer
    add_index :other_insurances, :policy_id
    add_foreign_key :other_insurances, :policies
  end
end
