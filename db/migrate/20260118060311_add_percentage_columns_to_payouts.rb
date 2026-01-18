class AddPercentageColumnsToPayouts < ActiveRecord::Migration[8.0]
  def change
    add_column :payouts, :main_agent_percentage, :decimal
    add_column :payouts, :affiliate_percentage, :decimal
    add_column :payouts, :ambassador_percentage, :decimal
    add_column :payouts, :investor_percentage, :decimal
    add_column :payouts, :company_expense_percentage, :decimal
  end
end
