class Admin::Settings::SystemController < Admin::Settings::BaseController

  def index
    # Placeholder for system settings
    @system_settings = {
      app_name: 'InsureBook Admin',
      version: '1.0.0',
      maintenance_mode: false,
      email_notifications: true,
      backup_frequency: 'Daily',
      session_timeout: 30,
      max_file_upload_size: 10
    }
  end

  private

  def system_setting_params
    params.require(:system_setting).permit(:maintenance_mode, :email_notifications, :backup_frequency, :session_timeout, :max_file_upload_size)
  end
end