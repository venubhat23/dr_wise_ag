class OtpMailer < ApplicationMailer
  def otp_code(email, otp)
    @otp = otp
    @expiry_minutes = OtpVerification::EXPIRY.to_i / 60
    mail(to: email, subject: "Your Dr WISE CRM login OTP")
  end
end
