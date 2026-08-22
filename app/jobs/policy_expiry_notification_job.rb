class PolicyExpiryNotificationJob < ApplicationJob
  queue_as :default

  def perform
    Policy.newly_expired.includes(:customer, :user).find_each do |policy|
      if policy.customer&.email.present?
        PolicyExpiryMailer.expired_to_customer(policy).deliver_later
      end

      if policy.user&.email.present?
        PolicyExpiryMailer.expired_to_agent(policy).deliver_later
      end
    end
  end
end
