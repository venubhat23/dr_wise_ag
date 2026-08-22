class PolicyRenewalMailer < ApplicationMailer
  def renewal_reminder_to_customer(policy, days_remaining)
    @policy = policy
    @customer = policy.customer
    @agent = policy.sub_agent
    @days_remaining = days_remaining
    @policy_category = policy_category_for(policy)
    mail(to: @customer.email, subject: customer_subject_for(policy, days_remaining))
  end

  def renewal_reminder_to_agent(policy, days_remaining)
    @policy = policy
    @customer = policy.customer
    @agent = policy.sub_agent
    @days_remaining = days_remaining
    @policy_category = policy_category_for(policy)
    mail(to: @agent.email, subject: agent_subject_for(policy, days_remaining))
  end

  private

  # LifeInsurance/HealthInsurance/MotorInsurance/OtherInsurance -> "Life Insurance"/"Health Insurance"/...
  def policy_category_for(policy)
    policy.class.name.gsub(/([a-z\d])([A-Z])/, '\1 \2')
  end

  def customer_subject_for(policy, days_remaining)
    category = policy_category_for(policy)
    if days_remaining.zero?
      "Action Required: Your #{category} Policy Has Expired — Renew Today"
    else
      day_word = days_remaining == 1 ? "Day" : "Days"
      "Renewal Reminder: Your #{category} Policy Expires in #{days_remaining} #{day_word}"
    end
  end

  def agent_subject_for(policy, days_remaining)
    category = policy_category_for(policy)
    customer_name = policy.customer.display_name
    if days_remaining.zero?
      "Renewal Alert: #{customer_name}'s #{category} Policy Has Expired"
    else
      day_word = days_remaining == 1 ? "Day" : "Days"
      "Renewal Alert: #{customer_name}'s #{category} Policy Expires in #{days_remaining} #{day_word}"
    end
  end
end
