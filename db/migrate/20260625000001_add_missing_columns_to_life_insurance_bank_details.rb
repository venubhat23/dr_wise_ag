class AddMissingColumnsToLifeInsuranceBankDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :life_insurance_bank_details, :life_insurance_id, :integer
    add_column :life_insurance_bank_details, :bank_name, :string
    add_column :life_insurance_bank_details, :account_type, :string
    add_column :life_insurance_bank_details, :account_number, :string
    add_column :life_insurance_bank_details, :ifsc_code, :string
    add_column :life_insurance_bank_details, :account_holder_name, :string
    add_index :life_insurance_bank_details, :life_insurance_id,
              name: 'index_life_insurance_bank_details_on_life_insurance_id'
  end
end
