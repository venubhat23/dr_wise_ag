class SendAmbassadorKycEmailJob < ApplicationJob
  queue_as :default

  EVENT_MAILER_METHODS = {
    'submitted' => :kyc_submitted,
    'approved' => :kyc_approved,
    'rejected' => :kyc_rejected
  }.freeze

  # distributor_id: the self-registered ambassador's Distributor row.
  # The KycMailer templates only use #display_name / #kyc_rejection_reason,
  # which Distributor responds to just like SubAgent, so they are reused as-is.
  def perform(distributor_id:, event:)
    distributor = Distributor.find_by(id: distributor_id)
    return unless distributor

    mailer_method = EVENT_MAILER_METHODS[event.to_s]
    return unless mailer_method

    KycMailer.public_send(mailer_method, distributor).deliver_now
  rescue => e
    Rails.logger.error "Ambassador KYC email failed for Distributor #{distributor_id} (#{event}): #{e.message}"
  end
end
