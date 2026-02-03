class AddProductThroughDrToLifeInsurances < ActiveRecord::Migration[8.0]
  def change
    add_column :life_insurances, :product_through_dr, :boolean
  end
end
