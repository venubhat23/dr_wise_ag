class PolicyExpiredFollowupJob < ApplicationJob
  queue_as :default

  # Real policy records live on these per-type tables, not on the unused Policy model.
  POLICY_MODELS = [LifeInsurance, HealthInsurance, MotorInsurance, OtherInsurance].freeze

  def perform
    # Post-expiry nudges: configurable via Admin > Settings > System (defaults to 2/7/30/60 days after policy_end_date).
    followup_days = SystemSetting.renewal_alert_days_after_expiry

    policy_count = 0
    skipped_renewed = 0
    customer_emails_queued = 0
    agent_emails_queued = 0

    POLICY_MODELS.each do |model|
      followup_days.each do |days|
        model.expired_days_ago(days).includes(:customer, :sub_agent).find_each do |policy|
          if policy.has_been_renewed?
            skipped_renewed += 1
            next
          end

          policy_count += 1

          if policy.customer&.email.present?
            PolicyRenewalMailer.expired_followup_to_customer(policy, days).deliver_later
            customer_emails_queued += 1
          end

          if policy.sub_agent&.email.present?
            PolicyRenewalMailer.expired_followup_to_agent(policy, days).deliver_later
            agent_emails_queued += 1
          end
        end
      end
    end

    Rails.logger.info(
      "[PolicyExpiredFollowupJob] followup_days=#{followup_days.join(',')} " \
      "policies_matched=#{policy_count} skipped_already_renewed=#{skipped_renewed} " \
      "customer_emails_queued=#{customer_emails_queued} agent_emails_queued=#{agent_emails_queued}"
    )
  end
end
