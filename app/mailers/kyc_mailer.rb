class KycMailer < ApplicationMailer
  def kyc_submitted(sub_agent)
    @sub_agent = sub_agent
    mail(to: @sub_agent.email, subject: "We've received your KYC documents")
  end

  def kyc_approved(sub_agent)
    @sub_agent = sub_agent
    mail(to: @sub_agent.email, subject: "Your KYC has been approved - you can now log in")
  end

  def kyc_rejected(sub_agent)
    @sub_agent = sub_agent
    mail(to: @sub_agent.email, subject: "Action needed on your KYC submission")
  end
end
