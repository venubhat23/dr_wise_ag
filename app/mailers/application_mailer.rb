class ApplicationMailer < ActionMailer::Base
  default from: "drwisedev@gmail.com"
  layout "mailer"

  # Jobs call this before delivering so a blank or malformed address is
  # skipped instead of raising at SMTP time.
  def self.valid_email?(email)
    email.to_s.strip.match?(URI::MailTo::EMAIL_REGEXP)
  end
end
