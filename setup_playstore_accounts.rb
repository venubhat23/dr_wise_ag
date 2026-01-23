#!/usr/bin/env ruby
# Script to set up Play Store test accounts and test data

puts "=" * 70
puts "Setting up Play Store Test Accounts and Data"
puts "=" * 70
puts

# 1. Create/Ensure User Accounts
puts "1. Creating/Checking User Accounts:"
puts "-" * 40

# First account: 95krishnamurthy@gmail.com
user1_email = "95krishnamurthy@gmail.com"
user1_password = "KRIS@1995"

begin
  user1 = User.find_by(email: user1_email)
  if user1
    puts "   ✓ User #{user1_email} already exists"
    # Update password if needed
    user1.update!(
      password: user1_password,
      password_confirmation: user1_password,
      original_password: user1_password
    )
    puts "   ✓ Password updated for #{user1_email}"
  else
    # Find or create admin role for customer
    admin_role = Role.find_by(name: "admin") || Role.find(4)
    user1 = User.create!(
      email: user1_email,
      password: user1_password,
      password_confirmation: user1_password,
      original_password: user1_password,
      first_name: "Krishna",
      last_name: "Murthy",
      mobile: "9595951234",
      role_id: admin_role.id,
      role_name: admin_role.name,
      user_type: "customer",
      status: "active"
    )
    puts "   ✓ Created user: #{user1_email}"
  end
rescue => e
  puts "   ✗ Error with #{user1_email}: #{e.message}"
end

# Second account: subagent1@insurebook.com
user2_email = "subagent1@insurebook.com"
user2_password = "password123"

begin
  user2 = User.find_by(email: user2_email)
  if user2
    puts "   ✓ User #{user2_email} already exists"
    # Update password if needed
    user2.update!(
      password: user2_password,
      password_confirmation: user2_password,
      original_password: user2_password
    )
    puts "   ✓ Password updated for #{user2_email}"
  else
    # Find sub_agent role
    sub_agent_role = Role.find_by(name: "sub_agent") || Role.find(1)
    user2 = User.create!(
      email: user2_email,
      password: user2_password,
      password_confirmation: user2_password,
      original_password: user2_password,
      first_name: "Sub",
      last_name: "Agent",
      mobile: "9898981234",
      role_id: sub_agent_role.id,
      role_name: sub_agent_role.name,
      user_type: "sub_agent",
      status: "active"
    )
    puts "   ✓ Created user: #{user2_email}"
  end
rescue => e
  puts "   ✗ Error with #{user2_email}: #{e.message}"
end

puts

# 2. Create Sub Agent (Affiliate)
puts "2. Creating Sub Agent (Affiliate):"
puts "-" * 40

begin
  sub_agent = SubAgent.find_by(email: user2_email)
  if sub_agent
    puts "   ✓ Sub Agent already exists: #{sub_agent.first_name} #{sub_agent.last_name}"
  else
    # Find sub_agent role
    sub_agent_role = Role.find_by(name: "sub_agent") || Role.find(1)
    sub_agent = SubAgent.create!(
      first_name: "Sub",
      last_name: "Agent",
      email: user2_email,
      mobile: "9898981234",
      status: "active",
      role_id: sub_agent_role.id,
      pan_no: "SUBAG1234P",
      password: user2_password,
      password_confirmation: user2_password
    )
    puts "   ✓ Created Sub Agent: #{sub_agent.first_name} #{sub_agent.last_name}"
  end
rescue => e
  puts "   ✗ Error creating Sub Agent: #{e.message}"
end

puts

# 3. Create Test Customer
puts "3. Creating Test Customer:"
puts "-" * 40

begin
  # Create a test customer with PAN
  test_customer = Customer.find_by(mobile: "9876543210")

  if test_customer
    puts "   ✓ Test Customer already exists: #{test_customer.display_name}"
  else
    test_customer = Customer.create!(
      name: "Rajesh Kumar",
      display_name: "Rajesh Kumar",
      email: "rajesh.kumar@example.com",
      mobile: "9876543210",
      pan_number: "ABCDE1234F",
      aadhar_number: "123456789012",
      address: "123, MG Road, Bangalore",
      city: "Bangalore",
      state: "Karnataka",
      pincode: "560001",
      customer_type: "individual",
      date_of_birth: "1985-05-15"
    )
    puts "   ✓ Created Test Customer: #{test_customer.display_name}"
    puts "     - Mobile: #{test_customer.mobile}"
    puts "     - PAN: #{test_customer.pan_number}"
    puts "     - Email: #{test_customer.email}"
  end
rescue => e
  puts "   ✗ Error creating customer: #{e.message}"
end

puts

# 4. Create Test Policies
puts "4. Creating Test Policies:"
puts "-" * 40

if test_customer && sub_agent
  # Policy 1: Regular active policy
  begin
    policy1 = HealthInsurance.create!(
      customer: test_customer,
      sub_agent: sub_agent,
      policy_holder: "Self",
      insurance_company_name: "Star Health Insurance",
      policy_type: "New",
      insurance_type: "Family Floater",
      policy_number: "STAR-HEALTH-#{Time.current.to_i}",
      policy_booking_date: Date.current,
      policy_start_date: Date.current - 6.months,
      policy_end_date: Date.current + 6.months,
      payment_mode: "Yearly",
      sum_insured: 1000000,
      net_premium: 35000,
      gst_percentage: 18.0,
      total_premium: 41300,
      main_agent_commission_percentage: 15.0,
      sub_agent_commission_percentage: 5.0,
      status: "active"
    )
    puts "   ✓ Created Policy 1: Regular active policy"
    puts "     - Policy Number: #{policy1.policy_number}"
    puts "     - Valid until: #{policy1.policy_end_date}"
  rescue => e
    puts "   ✗ Error creating Policy 1: #{e.message}"
  end

  # Policy 2: Renewal due in 5 days
  begin
    renewal_date = Date.current + 5.days
    policy2 = HealthInsurance.create!(
      customer: test_customer,
      sub_agent: sub_agent,
      policy_holder: "Self",
      insurance_company_name: "ICICI Lombard",
      policy_type: "New",
      insurance_type: "Individual",
      policy_number: "ICICI-RENEWAL-#{Time.current.to_i}",
      policy_booking_date: Date.current - 360.days,
      policy_start_date: Date.current - 360.days,
      policy_end_date: renewal_date,
      payment_mode: "Yearly",
      sum_insured: 500000,
      net_premium: 18000,
      gst_percentage: 18.0,
      total_premium: 21240,
      main_agent_commission_percentage: 15.0,
      sub_agent_commission_percentage: 5.0,
      status: "active"
    )
    puts "   ✓ Created Policy 2: Renewal due in 5 days"
    puts "     - Policy Number: #{policy2.policy_number}"
    puts "     - Renewal Date: #{policy2.policy_end_date}"
    puts "     - Days until renewal: 5"
  rescue => e
    puts "   ✗ Error creating Policy 2: #{e.message}"
  end

  # Policy 3: Motor Insurance with upcoming installment in 5 days
  begin
    installment_date = Date.current + 5.days
    policy3 = MotorInsurance.create!(
      customer: test_customer,
      sub_agent: sub_agent,
      policy_holder: "Self",
      insurance_company_name: "Bajaj Allianz",
      policy_type: "Comprehensive",
      policy_number: "BAJAJ-MOTOR-#{Time.current.to_i}",
      policy_booking_date: Date.current - 3.months,
      policy_start_date: Date.current - 3.months,
      policy_end_date: Date.current + 9.months,
      payment_mode: "Quarterly",
      vehicle_make: "Honda",
      vehicle_model: "City",
      vehicle_number: "KA01AB1234",
      vehicle_type: "Car",
      registration_year: 2022,
      idv: 600000,
      net_premium: 6000,  # Quarterly payment
      gst_percentage: 18.0,
      total_premium: 7080,
      main_agent_commission_percentage: 10.0,
      sub_agent_commission_percentage: 3.0,
      status: "active",
      next_installment_date: installment_date,
      installment_amount: 7080,
      total_installments: 4,
      paid_installments: 1,
      remaining_installments: 3
    )
    puts "   ✓ Created Policy 3: Motor Insurance with installment"
    puts "     - Policy Number: #{policy3.policy_number}"
    puts "     - Next Installment: #{installment_date}"
    puts "     - Installment Amount: ₹#{policy3.installment_amount}"
    puts "     - Payment Mode: Quarterly"
  rescue => e
    puts "   ✗ Error creating Policy 3: #{e.message}"
    # Try without installment fields if they don't exist
    begin
      policy3 = MotorInsurance.create!(
        customer: test_customer,
        sub_agent: sub_agent,
        policy_holder: "Self",
        insurance_company_name: "Bajaj Allianz",
        policy_type: "Comprehensive",
        policy_number: "BAJAJ-MOTOR-#{Time.current.to_i}",
        policy_booking_date: Date.current - 3.months,
        policy_start_date: Date.current - 3.months,
        policy_end_date: Date.current + 9.months,
        payment_mode: "Quarterly",
        vehicle_make: "Honda",
        vehicle_model: "City",
        vehicle_number: "KA01AB1234",
        vehicle_type: "Car",
        registration_year: 2022,
        idv: 600000,
        net_premium: 6000,
        gst_percentage: 18.0,
        total_premium: 7080,
        main_agent_commission_percentage: 10.0,
        sub_agent_commission_percentage: 3.0,
        status: "active"
      )
      puts "   ✓ Created Policy 3: Motor Insurance (basic)"
      puts "     - Policy Number: #{policy3.policy_number}"
      puts "     - Payment Mode: Quarterly"
    rescue => e2
      puts "   ✗ Error: #{e2.message}"
    end
  end
else
  puts "   ✗ Cannot create policies without customer and sub agent"
end

puts
puts "=" * 70
puts "Setup Complete!"
puts "=" * 70
puts
puts "Login Credentials:"
puts "  1. Customer: 95krishnamurthy@gmail.com / KRIS@1995"
puts "  2. Sub Agent: subagent1@insurebook.com / password123"
puts
puts "Test Customer Details:"
puts "  - Name: Rajesh Kumar"
puts "  - Mobile: 9876543210"
puts "  - PAN: ABCDE1234F"
puts "  - Email: rajesh.kumar@example.com"
puts
puts "Policies Created:"
puts "  1. Regular Health Insurance (Active)"
puts "  2. Health Insurance (Renewal in 5 days)"
puts "  3. Motor Insurance (Quarterly payments)"
puts
puts "Users can login with email/mobile/PAN once enabled in the application."
puts "=" * 70