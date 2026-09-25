# Daily nudge for ambassadors (Distributor) and affiliates (SubAgent) whose
# yearly subscription (see Subscribable) is about to run out: one email at
# 30, 15 and 1 day(s) before `subscription_expires_at`.
class SubscriptionRenewalReminderJob < ApplicationJob
  queue_as :default

  REMINDER_DAYS = [30, 15, 1].freeze
  SUBSCRIBER_MODELS = [Distributor, SubAgent].freeze

  def perform
    emails_queued = 0

    SUBSCRIBER_MODELS.each do |model|
      REMINDER_DAYS.each do |days|
        target_day = (Date.current + days).all_day

        model.active.where(subscription_expires_at: target_day).where.not(email: [nil, ""]).find_each do |subscriber|
          # Fee 0 -> nothing to renew and never locked out (Subscribable#renewal_required?).
          next unless subscriber.payment_amount_due > 0

          SubscriptionMailer.renewal_reminder(subscriber, days).deliver_later
          emails_queued += 1
        end
      end
    end

    Rails.logger.info(
      "[SubscriptionRenewalReminderJob] reminder_days=#{REMINDER_DAYS.join(',')} emails_queued=#{emails_queued}"
    )
  end
end
