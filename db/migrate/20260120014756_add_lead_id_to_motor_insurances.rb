class AddLeadIdToMotorInsurances < ActiveRecord::Migration[8.0]
  def change
    add_column :motor_insurances, :lead_id, :string
    add_index :motor_insurances, :lead_id, unique: true
  end
end
