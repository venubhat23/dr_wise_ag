class AddBankDetailsToLifeInsurances < ActiveRecord::Migration[8.0]
  def change
    add_column :life_insurances, :bank_name, :string
    add_column :life_insurances, :account_type, :string
    add_column :life_insurances, :account_number, :string
    add_column :life_insurances, :ifsc_code, :string
    add_column :life_insurances, :account_holder_name, :string
  end
end
