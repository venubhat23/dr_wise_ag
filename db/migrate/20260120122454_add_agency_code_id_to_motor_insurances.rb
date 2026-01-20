class AddAgencyCodeIdToMotorInsurances < ActiveRecord::Migration[8.0]
  def change
    add_column :motor_insurances, :agency_code_id, :integer
  end
end
