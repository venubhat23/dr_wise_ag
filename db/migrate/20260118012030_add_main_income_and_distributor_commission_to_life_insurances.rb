class AddMainIncomeAndDistributorCommissionToLifeInsurances < ActiveRecord::Migration[8.0]
  def change
    add_column :life_insurances, :main_income_percentage, :decimal
    add_column :life_insurances, :main_income_amount, :decimal
    add_column :life_insurances, :distributor_commission_percentage, :decimal
    add_column :life_insurances, :distributor_commission_amount, :decimal
    add_column :life_insurances, :distributor_tds_percentage, :decimal
    add_column :life_insurances, :distributor_tds_amount, :decimal
    add_column :life_insurances, :distributor_after_tds_value, :decimal
  end
end
