class AddMissingCommissionFieldsToLifeInsurances < ActiveRecord::Migration[8.0]
  def change
    add_column :life_insurances, :tds_amount, :decimal
    add_column :life_insurances, :after_tds_value, :decimal
    add_column :life_insurances, :sub_agent_commission_percentage, :decimal
    add_column :life_insurances, :sub_agent_commission_amount, :decimal
    add_column :life_insurances, :sub_agent_tds_percentage, :decimal
    add_column :life_insurances, :sub_agent_tds_amount, :decimal
    add_column :life_insurances, :sub_agent_after_tds_value, :decimal
    add_column :life_insurances, :investor_commission_percentage, :decimal
    add_column :life_insurances, :investor_commission_amount, :decimal
    add_column :life_insurances, :investor_tds_percentage, :decimal
    add_column :life_insurances, :investor_tds_amount, :decimal
    add_column :life_insurances, :investor_after_tds_value, :decimal
  end
end
