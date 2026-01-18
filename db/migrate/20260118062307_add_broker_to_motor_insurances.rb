class AddBrokerToMotorInsurances < ActiveRecord::Migration[8.0]
  def change
    add_reference :motor_insurances, :broker, null: false, foreign_key: true
  end
end
