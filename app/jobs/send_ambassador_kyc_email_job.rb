class SendAmbassadorKycEmailJob < ApplicationJob
  queue_as :default

  EVENT_MAILER_METHODS = {
    'submitted' => :kyc_submitted,
    'approved' => :kyc_approved,
    'rejected' => :kyc_rejected
  }.freeze

  # distributor_id: the self-registered ambassador's Distributor row.
  # KycMailer templates are shared with affiliates and switch their wording
  # for Distributor recipients.
  def perform(distributor_id:, event:)
    distributor = Distributor.find_by(id: distributor_id)
    return unless distributor

    mailer_method = EVENT_MAILER_METHODS[event.to_s]
    return unless mailer_method
    return unless ApplicationMailer.valid_email?(distributor.email)

    KycMailer.public_send(mailer_method, distributor).deliver_now
  rescue => e
    Rails.logger.error "Ambassador KYC email failed for Distributor #{distributor_id} (#{event}): #{e.message}"
  end
end
