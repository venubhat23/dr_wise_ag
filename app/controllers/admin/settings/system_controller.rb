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

    # Get company expenses percentage from database
    @company_expenses_percentage = SystemSetting.company_expenses_percentage
  end

  def update
    if params[:company_expenses_percentage].present?
      percentage = params[:company_expenses_percentage].to_f

      # Validate percentage (should be between 0 and 100)
      if percentage >= 0 && percentage <= 100
        SystemSetting.set_company_expenses_percentage(percentage)
        redirect_to admin_settings_system_path, notice: 'Company expenses percentage updated successfully!'
      else
        redirect_to admin_settings_system_path, alert: 'Invalid percentage. Please enter a value between 0 and 100.'
      end
    else
      redirect_to admin_settings_system_path, alert: 'Please enter a valid percentage.'
    end
  end

  private

  def system_setting_params
    params.require(:system_setting).permit(:maintenance_mode, :email_notifications, :backup_frequency, :session_timeout, :max_file_upload_size, :company_expenses_percentage)
  end
end