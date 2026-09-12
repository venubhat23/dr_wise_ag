# Public, self-service ambassador sign-up reached from the "Register as
# Ambassador" button on the login page. Creates the pair of records an
# ambassador needs - a Distributor (business data, KYC queue) and a Devise
# User with user_type: "ambassador" (portal login) - matched by email, the
# same way AmbassadorController links them.
#
# The account can log in immediately; the Distributor lands in the admin
# "Ambassador KYC Verification" queue under the "Registered" tab
# (kyc_status: pending) until they submit their KYC details.
class AmbassadorRegistrationsController < ApplicationController
  skip_before_action :authenticate_user!
  layout "devise"

  before_action :redirect_if_signed_in

  def new
    @distributor = Distributor.new
  end

  def create
    @distributor = Distributor.new
    email    = params.dig(:distributor, :email).to_s.strip.downcase
    mobile   = params.dig(:distributor, :mobile).to_s.strip
    password = params.dig(:distributor, :password).to_s
    confirm  = params.dig(:distributor, :password_confirmation).to_s

    if email.blank? || mobile.blank? || password.blank?
      return render_error("Email, mobile number and password are required.")
    end

    unless email.match?(URI::MailTo::EMAIL_REGEXP)
      return render_error("Please enter a valid email address.")
    end

    if password.length < 6
      return render_error("Password must be at least 6 characters long.")
    end

    if password != confirm
      return render_error("Password confirmation does not match.")
    end

    if User.exists?(["lower(email) = ?", email]) || Distributor.exists?(["lower(email) = ?", email])
      return render_error("An account with this email already exists. Please sign in instead.")
    end

    ActiveRecord::Base.transaction do
      @distributor = Distributor.new(
        email: email,
        mobile: mobile,
        password: password,
        password_confirmation: password,
        original_password: password,
        username: email.split("@").first,
        status: :inactive,
        self_registered: true,
        kyc_status: :pending
      )
      @distributor.role_id = "distributor"
      @distributor.save!

      ambassador_role = Role.find_by(name: "ambassador") || Role.find_by(name: "Ambassador") ||
                        Role.find_or_create_by!(name: "ambassador") { |r| r.description = "Ambassador portal access"; r.status = true }

      User.create!(
        first_name: email.split("@").first.presence || "Ambassador",
        last_name: "Ambassador",
        email: email,
        mobile: @distributor.mobile,
        password: password,
        password_confirmation: password,
        original_password: password,
        user_type: "ambassador",
        role: ambassador_role,
        user_role: UserRole.find_by(name: "Ambassador"),
        status: true
      )
    end

    redirect_to new_user_session_path,
                notice: "Registration successful! You can now sign in. Please complete your KYC so our team can verify your account."
  rescue ActiveRecord::RecordInvalid => e
    render_error(e.record.errors.full_messages.to_sentence.presence || "Registration could not be completed.")
  end

  private

  def redirect_if_signed_in
    redirect_to after_sign_in_path_for(current_user) if user_signed_in?
  end

  def render_error(message)
    flash.now[:alert] = message
    @distributor ||= Distributor.new
    render :new, status: :unprocessable_entity
  end
end
