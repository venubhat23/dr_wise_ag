class OtpMailer < ApplicationMailer
  def otp_code(email, otp, purpose = "login")
    @otp = otp
    @expiry_minutes = OtpVerification::EXPIRY.to_i / 60
    @label = purpose == "password_reset" ? "password reset" : "login"
    mail(to: email, subject: "Your Dr WISE CRM #{@label} OTP")
  end
end
