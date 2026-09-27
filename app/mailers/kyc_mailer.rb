# Recipient is an affiliate (SubAgent, mobile app) or a self-registered
# ambassador (Distributor, web platform); templates switch wording on @ambassador.
class KycMailer < ApplicationMailer
  def kyc_submitted(sub_agent)
    set_recipient(sub_agent)
    mail(to: @sub_agent.email, subject: "We've received your KYC documents")
  end

  def kyc_approved(sub_agent)
    set_recipient(sub_agent)
    mail(to: @sub_agent.email, subject: "Your KYC has been approved - you can now log in")
  end

  def kyc_rejected(sub_agent)
    set_recipient(sub_agent)
    mail(to: @sub_agent.email, subject: "Action needed on your KYC submission")
  end

  private

  def set_recipient(recipient)
    @sub_agent = recipient
    @ambassador = recipient.is_a?(Distributor)
    @login_url = new_user_session_url if @ambassador
  end
end
