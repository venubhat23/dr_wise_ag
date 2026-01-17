class AddGstFieldsToLifeInsurances < ActiveRecord::Migration[8.0]
  def change
    add_column :life_insurances, :first_year_gst_percentage, :decimal
    add_column :life_insurances, :second_year_gst_percentage, :decimal
    add_column :life_insurances, :third_year_gst_percentage, :decimal
  end
end
