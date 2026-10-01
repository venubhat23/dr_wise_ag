# Creates in-app notifications (customer + sourcing affiliate) once a policy is saved.
module NotifiesOnPolicyCreate
  extend ActiveSupport::Concern

  included do
    after_create_commit :send_policy_created_notifications
  end

  private

  def send_policy_created_notifications
    Notification.create_policy_notifications(self)
  rescue StandardError => e
    Rails.logger.error "Policy notification failed for #{self.class.name} #{id}: #{e.message}"
  end
end
