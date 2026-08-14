class VendorSessionsController < ApplicationController
  layout 'vendor_login'
  skip_before_action :authenticate_user!

  # GET /vendor/login
  def new
    redirect_to vendor_dashboard_path if current_user&.vendor?
  end
end
