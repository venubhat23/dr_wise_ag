class SendLeadSubmittedEmailJob < ApplicationJob
  queue_as :default

  # Notifies both sides when a lead is submitted (mobile app or admin): the
  # affiliate (if any) gets an in-app message + confirmation email, and the lead
  # gets a "we'll contact you" email. Each email is only sent to a valid address.
  def perform(lead_id:)
    lead = Lead.find_by(id: lead_id)
    return unless lead

    begin
      Notification.create_lead_submitted_notification(lead)
    rescue => e
      Rails.logger.error "Lead in-app notification failed for Lead #{lead.id}: #{e.message}"
    end

    deliver_safely(lead, :lead_submitted_to_affiliate) if ApplicationMailer.valid_email?(lead.affiliate&.email)
    deliver_safely(lead, :lead_submitted_to_customer) if ApplicationMailer.valid_email?(lead.email)
  end

  private

  # Each email is isolated so one bad address doesn't block the other.
  def deliver_safely(lead, mailer_method)
    LeadMailer.public_send(mailer_method, lead).deliver_now
  rescue => e
    Rails.logger.error "Lead email #{mailer_method} failed for Lead #{lead.id}: #{e.message}"
  end
end
