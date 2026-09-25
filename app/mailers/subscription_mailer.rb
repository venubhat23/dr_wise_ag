class SubscriptionMailer < ApplicationMailer
  def renewal_reminder(subscriber, days_remaining)
    @subscriber = subscriber
    @days_remaining = days_remaining
    @ambassador = subscriber.is_a?(Distributor)
    @role = @ambassador ? "Ambassador" : "Affiliate"
    @expires_on = subscriber.subscription_expires_at.to_date
    @renewal_fee = subscriber.payment_amount_due
    @login_url = new_user_session_url if @ambassador

    day_word = days_remaining == 1 ? "Day" : "Days"
    mail(
      to: subscriber.email,
      subject: "Renewal Reminder: Your Drwise #{@role} Subscription Expires in #{days_remaining} #{day_word}"
    )
  end
end
