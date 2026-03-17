class FixMotorInsurancePercentagePrecision < ActiveRecord::Migration[8.0]
  def change
    # Fix percentage fields that have precision 5, scale 2 (max 999.99)
    # Change them to precision 8, scale 2 (max 999999.99) to support higher percentages
    change_column :motor_insurances, :main_agent_commission_percentage, :decimal, precision: 8, scale: 2
    change_column :motor_insurances, :main_agent_tds_percentage, :decimal, precision: 8, scale: 2
    change_column :motor_insurances, :tds_percentage, :decimal, precision: 8, scale: 2
  end
end
