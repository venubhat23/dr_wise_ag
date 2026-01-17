class AddMainAgentCommissionToLifeInsurances < ActiveRecord::Migration[8.0]
  def change
    add_column :life_insurances, :main_agent_commission_percentage, :decimal
    add_column :life_insurances, :commission_amount, :decimal
    add_column :life_insurances, :tds_percentage, :decimal
  end
end
