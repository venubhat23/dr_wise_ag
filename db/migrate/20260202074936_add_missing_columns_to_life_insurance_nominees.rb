class AddMissingColumnsToLifeInsuranceNominees < ActiveRecord::Migration[8.0]
  def change
    add_column :life_insurance_nominees, :life_insurance_id, :integer, null: false
    add_index :life_insurance_nominees, :life_insurance_id
    add_column :life_insurance_nominees, :nominee_name, :string, null: false
    add_column :life_insurance_nominees, :relationship, :string, null: false
    add_column :life_insurance_nominees, :age, :integer
    add_column :life_insurance_nominees, :share_percentage, :decimal, precision: 5, scale: 2

    # Add foreign key constraint
    add_foreign_key :life_insurance_nominees, :life_insurances, column: :life_insurance_id
  end
end
