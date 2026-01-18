class AddMainAgentCommissionTrackingToMotorInsurances < ActiveRecord::Migration[8.0]
  def change
    add_column :motor_insurances, :main_agent_commission_received, :boolean
    add_column :motor_insurances, :main_agent_commission_transaction_id, :string
    add_column :motor_insurances, :main_agent_commission_paid_date, :date
    add_column :motor_insurances, :main_agent_commission_notes, :text
  end
end
