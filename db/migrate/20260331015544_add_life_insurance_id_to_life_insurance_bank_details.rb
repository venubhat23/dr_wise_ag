class AddLifeInsuranceIdToLifeInsuranceBankDetails < ActiveRecord::Migration[8.0]
  def change
    add_column :life_insurance_bank_details, :life_insurance_id, :integer
    add_index :life_insurance_bank_details, :life_insurance_id
  end
end
