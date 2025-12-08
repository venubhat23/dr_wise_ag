class Admin::ApplicationController < ApplicationController
  before_action :ensure_admin

  private

  def ensure_admin
    unless current_user&.admin? || current_user&.user_type == 'admin'
      redirect_to root_path, alert: 'Access denied. Admin privileges required.'
    end
  end
end