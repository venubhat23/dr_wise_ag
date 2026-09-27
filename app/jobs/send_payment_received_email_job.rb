class SendPaymentReceivedEmailJob < ApplicationJob
  queue_as :default

  # Receipt for a verified Razorpay registration/renewal payment, sent to the
  # affiliate (SubAgent) or ambassador (Distributor) who paid.
  def perform(subscription_id:)
    subscription = Subscription.find_by(id: subscription_id)
    return unless subscription
    return unless ApplicationMailer.valid_email?(subscription.subscriber&.email)

    SubscriptionMailer.payment_received(subscription).deliver_now
  rescue => e
    Rails.logger.error "Payment received email failed for Subscription #{subscription_id}: #{e.message}"
  end
end
