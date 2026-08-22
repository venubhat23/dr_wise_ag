class PolicyRenewalReminderJob < ApplicationJob
  queue_as :default

  # Real policy records live on these per-type tables, not on the unused Policy model.
  POLICY_MODELS = [LifeInsurance, HealthInsurance, MotorInsurance, OtherInsurance].freeze

  def perform
    # Countdown to renewal: configurable via Admin > Settings > System (defaults to 30/15/7/1 days before policy_end_date, then the expiry day itself).
    milestone_days = SystemSetting.renewal_alert_days

    policy_count = 0
    customer_emails_queued = 0
    agent_emails_queued = 0

    POLICY_MODELS.each do |model|
      milestone_days.each do |days|
        model.expiring_in(days).includes(:customer, :sub_agent).find_each do |policy|
          policy_count += 1

          if policy.customer&.email.present?
            PolicyRenewalMailer.renewal_reminder_to_customer(policy, days).deliver_later
            customer_emails_queued += 1
          end

          if policy.sub_agent&.email.present?
            PolicyRenewalMailer.renewal_reminder_to_agent(policy, days).deliver_later
            agent_emails_queued += 1
          end
        end
      end
    end

    Rails.logger.info(
      "[PolicyRenewalReminderJob] milestone_days=#{milestone_days.join(',')} " \
      "policies_matched=#{policy_count} customer_emails_queued=#{customer_emails_queued} " \
      "agent_emails_queued=#{agent_emails_queued}"
    )
  end
end
