class SendLeadSubmittedEmailJob < ApplicationJob
  queue_as :default

  # Notifies both sides when an affiliate submits a lead from the mobile app:
  # the affiliate gets a confirmation, the lead gets a "we'll contact you" note.
  def perform(lead_id:)
    lead = Lead.find_by(id: lead_id)
    return unless lead

    if lead.affiliate&.email.present?
      deliver_safely(lead, :lead_submitted_to_affiliate)
    end

    if lead.email.present?
      deliver_safely(lead, :lead_submitted_to_customer)
    end
  end

  private

  # Each email is isolated so one bad address doesn't block the other.
  def deliver_safely(lead, mailer_method)
    LeadMailer.public_send(mailer_method, lead).deliver_now
  rescue => e
    Rails.logger.error "Lead email #{mailer_method} failed for Lead #{lead.id}: #{e.message}"
  end
end
