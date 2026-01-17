class AddDistributorToLifeInsurances < ActiveRecord::Migration[8.0]
  def change
    add_reference :life_insurances, :distributor, null: true, foreign_key: true
  end
end
