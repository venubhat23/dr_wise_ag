class SendKycStatusEmailJob < ApplicationJob
  queue_as :default

  EVENT_MAILER_METHODS = {
    "submitted" => :kyc_submitted,
    "approved" => :kyc_approved,
    "rejected" => :kyc_rejected
  }.freeze

  def perform(sub_agent_id:, event:)
    sub_agent = SubAgent.find_by(id: sub_agent_id)
    return unless sub_agent

    mailer_method = EVENT_MAILER_METHODS[event.to_s]
    return unless mailer_method

    KycMailer.public_send(mailer_method, sub_agent).deliver_now
  rescue => e
    Rails.logger.error "KYC status email failed for SubAgent #{sub_agent_id} (#{event}): #{e.message}"
  end
end
