class PolicyExpiryMailer < ApplicationMailer
  def expired_to_customer(policy)
    @policy = policy
    @customer = policy.customer
    mail(to: @customer.email, subject: "Your #{@policy.plan_name} policy has expired")
  end

  def expired_to_agent(policy)
    @policy = policy
    @customer = policy.customer
    @agent = policy.user
    mail(to: @agent.email, subject: "Policy #{@policy.policy_number} has expired")
  end
end
