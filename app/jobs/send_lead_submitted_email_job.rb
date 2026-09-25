class SendLeadSubmittedEmailJob < ApplicationJob
  queue_as :default

  # Notifies both sides when a lead is submitted for an affiliate (mobile app or admin):
  # the affiliate gets an in-app message + confirmation email, the lead gets a
  # "we'll contact you" email.
  def perform(lead_id:)
    lead = Lead.find_by(id: lead_id)
    return unless lead

    begin
      Notification.create_lead_submitted_notification(lead)
    rescue => e
      Rails.logger.error "Lead in-app notification failed for Lead #{lead.id}: #{e.message}"
    end

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
