class AddNotificationDatesToMotorInsurances < ActiveRecord::Migration[8.0]
  def change
    add_column :motor_insurances, :notification_dates, :text
  end
end
