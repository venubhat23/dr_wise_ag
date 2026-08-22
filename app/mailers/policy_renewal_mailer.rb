class PolicyRenewalMailer < ApplicationMailer
  def renewal_reminder_to_customer(policy, days_remaining)
    @policy = policy
    @customer = policy.customer
    @days_remaining = days_remaining
    mail(to: @customer.email, subject: subject_for(policy, days_remaining))
  end

  def renewal_reminder_to_agent(policy, days_remaining)
    @policy = policy
    @customer = policy.customer
    @agent = policy.user
    @days_remaining = days_remaining
    mail(to: @agent.email, subject: "[Renewal] #{subject_for(policy, days_remaining)}")
  end

  private

  def subject_for(policy, days_remaining)
    if days_remaining.zero?
      "Your #{policy.plan_name} policy has expired"
    else
      day_word = days_remaining == 1 ? "day" : "days"
      "Your #{policy.plan_name} policy expires in #{days_remaining} #{day_word}"
    end
  end
end
