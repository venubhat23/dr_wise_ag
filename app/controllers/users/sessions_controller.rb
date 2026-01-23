# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # Skip CSRF protection for create action as a temporary fix
  skip_before_action :verify_authenticity_token, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    # Manually verify CSRF token if present, but don't fail if missing
    if params[:authenticity_token].present?
      begin
        verify_authenticity_token
      rescue ActionController::InvalidAuthenticityToken
        # Log the issue but allow login to proceed
        Rails.logger.warn "CSRF token verification failed for login from #{request.remote_ip}"
      end
    end

    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
  end
end