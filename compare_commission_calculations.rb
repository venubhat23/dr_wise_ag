puts '🔍 Comparing Mobile API vs Commission Payouts Calculation...'
puts '=' * 65

sub_agent = SubAgent.find(38)
puts "Sub Agent: #{sub_agent.display_name}"
puts

# Get policies for this sub-agent
life_policies = LifeInsurance.where(sub_agent_id: 38)
motor_policies = MotorInsurance.where(sub_agent_id: 38)
health_policies = HealthInsurance.where(sub_agent_id: 38)

puts '📊 MOBILE API CALCULATION (from policy tables):'
puts

# Life Insurance
life_commission = life_policies.sum(:sub_agent_after_tds_value).to_f
puts "Life Insurance Commission (sub_agent_after_tds_value): ₹#{life_commission}"
life_policies.each do |policy|
  puts "  Policy #{policy.policy_number}: ₹#{policy.sub_agent_after_tds_value || 0}"
end

# Motor Insurance
motor_commission = motor_policies.sum(:sub_agent_after_tds_value).to_f
puts "Motor Insurance Commission (sub_agent_after_tds_value): ₹#{motor_commission}"
motor_policies.each do |policy|
  puts "  Policy #{policy.policy_number}: ₹#{policy.sub_agent_after_tds_value || 0}"
end

# Health Insurance
health_commission = health_policies.sum(:sub_agent_after_tds_value).to_f
puts "Health Insurance Commission (sub_agent_after_tds_value): ₹#{health_commission}"

mobile_api_total = life_commission + motor_commission + health_commission
puts "🎯 MOBILE API TOTAL: ₹#{mobile_api_total}"

puts
puts '📊 COMMISSION PAYOUTS TABLE:'

# Get commission payouts for these policies
life_policy_ids = life_policies.pluck(:id)
motor_policy_ids = motor_policies.pluck(:id)

life_payouts = CommissionPayout.where(policy_type: 'life', policy_id: life_policy_ids, payout_to: 'affiliate')
motor_payouts = CommissionPayout.where(policy_type: 'motor', policy_id: motor_policy_ids, payout_to: 'affiliate')

life_payout_total = life_payouts.sum(:payout_amount).to_f
motor_payout_total = motor_payouts.sum(:payout_amount).to_f

puts "Life Insurance Payouts: ₹#{life_payout_total}"
life_payouts.each do |payout|
  policy = LifeInsurance.find(payout.policy_id)
  puts "  Policy #{policy.policy_number}: ₹#{payout.payout_amount}"
end

puts "Motor Insurance Payouts: ₹#{motor_payout_total}"
motor_payouts.each do |payout|
  policy = MotorInsurance.find(payout.policy_id)
  puts "  Policy #{policy.policy_number}: ₹#{payout.payout_amount}"
end

commission_payouts_total = life_payout_total + motor_payout_total
puts "🎯 COMMISSION PAYOUTS TOTAL: ₹#{commission_payouts_total}"

puts
puts '🔍 COMPARISON:'
puts "Mobile API Total: ₹#{mobile_api_total}"
puts "Commission Payouts Total: ₹#{commission_payouts_total}"
puts "Admin UI Total: ₹33,648 (matches commission payouts)"
puts "Difference: ₹#{(mobile_api_total - commission_payouts_total).round(2)}"

if mobile_api_total != commission_payouts_total
  puts
  puts '❌ DISCREPANCY FOUND!'
  puts 'The mobile API uses policy.sub_agent_after_tds_value'
  puts 'The admin UI uses commission_payouts.payout_amount'
  puts 'These values do not match!'

  puts
  puts '🔍 DETAILED COMPARISON BY POLICY:'
  puts

  # Compare life policies
  puts 'LIFE INSURANCE POLICIES:'
  life_policies.each do |policy|
    payout = life_payouts.find { |p| p.policy_id == policy.id }
    policy_commission = policy.sub_agent_after_tds_value || 0
    payout_commission = payout ? payout.payout_amount : 0

    puts "  #{policy.policy_number}:"
    puts "    Policy Table: ₹#{policy_commission}"
    puts "    Payout Table: ₹#{payout_commission}"
    if policy_commission != payout_commission
      puts "    ❌ MISMATCH: ₹#{(policy_commission - payout_commission).round(2)}"
    else
      puts "    ✅ MATCH"
    end
    puts
  end

  # Compare motor policies
  puts 'MOTOR INSURANCE POLICIES:'
  motor_policies.each do |policy|
    payout = motor_payouts.find { |p| p.policy_id == policy.id }
    policy_commission = policy.sub_agent_after_tds_value || 0
    payout_commission = payout ? payout.payout_amount : 0

    puts "  #{policy.policy_number}:"
    puts "    Policy Table: ₹#{policy_commission}"
    puts "    Payout Table: ₹#{payout_commission}"
    if policy_commission != payout_commission
      puts "    ❌ MISMATCH: ₹#{(policy_commission - payout_commission).round(2)}"
    else
      puts "    ✅ MATCH"
    end
    puts
  end
end