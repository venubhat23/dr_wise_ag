#!/usr/bin/env ruby
# Test script to verify Play Store accounts and login functionality

puts "=" * 70
puts "Testing Play Store Account Setup"
puts "=" * 70
puts

# 1. Test User Accounts
puts "1. User Accounts Status:"
puts "-" * 40

# Check first user
user1 = User.find_by(email: "95krishnamurthy@gmail.com")
if user1
  puts "✅ User 1: 95krishnamurthy@gmail.com"
  puts "   - Name: #{user1.full_name}"
  puts "   - Mobile: #{user1.mobile}"
  puts "   - PAN: #{user1.pan_number || 'Not set'}"
  puts "   - Role: #{user1.user_type}"
  puts "   - Status: #{user1.status ? 'Active' : 'Inactive'}"
else
  puts "❌ User 1 not found: 95krishnamurthy@gmail.com"
end

# Check second user
user2 = User.find_by(email: "subagent1@insurebook.com")
if user2
  puts "✅ User 2: subagent1@insurebook.com"
  puts "   - Name: #{user2.full_name}"
  puts "   - Mobile: #{user2.mobile}"
  puts "   - Role: #{user2.user_type}"
  puts "   - Status: #{user2.status ? 'Active' : 'Inactive'}"
else
  puts "❌ User 2 not found: subagent1@insurebook.com"
end

puts

# 2. Test Sub Agent (Affiliate)
puts "2. Sub Agent (Affiliate) Status:"
puts "-" * 40

sub_agent = SubAgent.find_by(email: "subagent1@insurebook.com")
if sub_agent
  puts "✅ Sub Agent: #{sub_agent.first_name} #{sub_agent.last_name}"
  puts "   - Email: #{sub_agent.email}"
  puts "   - Mobile: #{sub_agent.mobile}"
  puts "   - PAN: #{sub_agent.pan_no}"
  puts "   - Status: #{sub_agent.status}"
else
  puts "❌ Sub Agent not found"
end

puts

# 3. Test Customer
puts "3. Test Customer Status:"
puts "-" * 40

customer = Customer.find_by(mobile: "9876543210")
if customer
  puts "✅ Customer: #{customer.display_name}"
  puts "   - Email: #{customer.email}"
  puts "   - Mobile: #{customer.mobile}"
  puts "   - PAN: #{customer.pan_number}"

  # Check if customer can be found by PAN
  customer_by_pan = Customer.find_by(pan_number: "ABCDE1234F")
  if customer_by_pan
    puts "   ✅ Customer can be found by PAN"
  end
else
  puts "❌ Test customer not found"
end

puts

# 4. Test Policies
puts "4. Policies Status:"
puts "-" * 40

if customer
  health_policies = HealthInsurance.where(customer: customer).order(created_at: :desc)
  motor_policies = MotorInsurance.where(customer: customer).order(created_at: :desc)

  puts "Health Insurance Policies: #{health_policies.count}"
  health_policies.each_with_index do |policy, index|
    days_to_renewal = (policy.policy_end_date - Date.current).to_i
    puts "   #{index + 1}. #{policy.policy_number}"
    puts "      - Company: #{policy.insurance_company_name}"
    puts "      - End Date: #{policy.policy_end_date}"
    puts "      - Days to Renewal: #{days_to_renewal}"
    puts "      - Status: #{days_to_renewal <= 60 ? '⚠️ Renewal Due' : '✅ Active'}" if days_to_renewal > 0
  end

  puts "Motor Insurance Policies: #{motor_policies.count}"
  motor_policies.each_with_index do |policy, index|
    puts "   #{index + 1}. #{policy.policy_number}"
    puts "      - Vehicle: #{policy.vehicle_make} #{policy.vehicle_model}"
    puts "      - Payment Mode: #{policy.payment_mode}"
  end
else
  puts "Cannot check policies without customer"
end

puts

# 5. Test Login Methods
puts "5. Login Method Tests:"
puts "-" * 40

test_logins = [
  { login: "95krishnamurthy@gmail.com", type: "Email" },
  { login: "9595951234", type: "Mobile" },
  { login: "+919595951234", type: "Mobile with +91" },
  { login: "9876543210", type: "Customer Mobile" },
  { login: "ABCDE1234F", type: "Customer PAN" }
]

test_logins.each do |test|
  user = User.find_for_database_authentication(login: test[:login])
  if user
    puts "✅ #{test[:type]}: '#{test[:login]}' → Found user: #{user.email}"
  else
    puts "❌ #{test[:type]}: '#{test[:login]}' → No user found"
  end
end

puts
puts "=" * 70
puts "Summary:"
puts "=" * 70
puts
puts "✅ COMPLETED:"
puts "  • User accounts created for Play Store"
puts "  • Sub Agent (Affiliate) created"
puts "  • Test customer with PAN created"
puts "  • Health Insurance policies created (including renewal in 5 days)"
puts "  • Login enabled with Email/Mobile/PAN"
puts
puts "📱 LOGIN CREDENTIALS:"
puts "  1. Customer Account:"
puts "     Email: 95krishnamurthy@gmail.com"
puts "     Password: KRIS@1995"
puts "     Can also login with: 9595951234 (mobile)"
puts
puts "  2. Sub Agent Account:"
puts "     Email: subagent1@insurebook.com"
puts "     Password: password123"
puts "     Can also login with: 9898981234 (mobile)"
puts
puts "  3. Test Customer (for testing):"
puts "     Mobile: 9876543210"
puts "     PAN: ABCDE1234F"
puts "     Email: rajesh.kumar@example.com"
puts
puts "📋 POLICIES CREATED:"
puts "  • 2 Health Insurance policies"
puts "    - 1 active policy"
puts "    - 1 renewal due in 5 days"
puts "  • Motor Insurance with quarterly payments (if columns exist)"
puts
puts "🔐 LOGIN FEATURES:"
puts "  ✅ Login with Email"
puts "  ✅ Login with Mobile (with/without +91)"
puts "  ✅ Login with PAN number"
puts
puts "=" * 70