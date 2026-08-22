class PolicyRenewalReminderJob < ApplicationJob
  queue_as :default

  # Countdown to renewal: 30/15/1 days before policy_end_date, then the expiry day itself.
  MILESTONE_DAYS = [30, 15, 1, 0].freeze

  def perform
    MILESTONE_DAYS.each do |days|
      Policy.expiring_in(days).includes(:customer, :user).find_each do |policy|
        if policy.customer&.email.present?
          PolicyRenewalMailer.renewal_reminder_to_customer(policy, days).deliver_later
        end

        if policy.user&.email.present?
          PolicyRenewalMailer.renewal_reminder_to_agent(policy, days).deliver_later
        end
      end
    end
  end
end
