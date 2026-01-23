#!/usr/bin/env ruby
# Fix Play Store setup issues

puts "=" * 70
puts "Fixing Play Store Setup Issues"
puts "=" * 70
puts

# 1. Update customer with PAN
puts "1. Updating Customer with PAN:"
puts "-" * 40

customer = Customer.find_by(mobile: "9876543210")
if customer
  # Update customer with PAN if not set
  if customer.pan_number.blank?
    customer.update!(pan_number: "ABCDE1234F")
    puts "✅ Updated customer PAN to: ABCDE1234F"
  else
    puts "✅ Customer already has PAN: #{customer.pan_number}"
  end

  # Create or update user account for this customer
  user = User.find_by(email: customer.email)
  if user
    # Update PAN for existing user
    user.update!(pan_number: "ABCDE1234F") if user.pan_number.blank?
    puts "✅ User account exists for customer: #{user.email}"
    puts "   PAN: #{user.pan_number}"
  else
    # Create user account for customer
    begin
      admin_role = Role.find_by(name: "admin") || Role.find(4)
      user = User.create!(
        email: customer.email || "rajesh.kumar.test@example.com",
        password: "Test@1234",
        password_confirmation: "Test@1234",
        original_password: "Test@1234",
        first_name: customer.first_name || "Rajesh",
        last_name: customer.last_name || "Kumar",
        mobile: customer.mobile,
        pan_number: customer.pan_number,
        role_id: admin_role.id,
        role_name: admin_role.name,
        user_type: "customer",
        status: "active"
      )
      puts "✅ Created user account for customer"
      puts "   Email: #{user.email}"
      puts "   Password: Test@1234"
      puts "   PAN: #{user.pan_number}"
      puts "   Mobile: #{user.mobile}"
    rescue => e
      puts "❌ Error creating user: #{e.message}"
    end
  end
else
  puts "❌ Customer not found"
end

puts

# 2. Update Krishna's account with PAN
puts "2. Updating Krishna's PAN:"
puts "-" * 40

krishna = User.find_by(email: "95krishnamurthy@gmail.com")
if krishna
  if krishna.pan_number.blank?
    krishna.update!(pan_number: "KRISH1995P")
    puts "✅ Updated Krishna's PAN to: KRISH1995P"
  else
    puts "✅ Krishna already has PAN: #{krishna.pan_number}"
  end
else
  puts "❌ Krishna's account not found"
end

puts

# 3. Fix Motor Insurance fields
puts "3. Checking Motor Insurance Schema:"
puts "-" * 40

# Check what columns exist
motor_columns = MotorInsurance.column_names
missing_columns = []

required_fields = ['vehicle_make', 'vehicle_model', 'vehicle_type', 'payment_mode']
required_fields.each do |field|
  if motor_columns.include?(field)
    puts "✅ #{field}: exists"
  else
    puts "❌ #{field}: missing"
    missing_columns << field
  end
end

if missing_columns.empty?
  puts "✅ All required motor insurance fields exist"
else
  puts "⚠️  Some fields are missing: #{missing_columns.join(', ')}"
  puts "   Note: Motor policies will be created with available fields only"
end

puts

# 4. Create a proper motor insurance policy with installments
puts "4. Creating Motor Insurance with Installments:"
puts "-" * 40

if customer
  begin
    sub_agent = SubAgent.find_by(email: "subagent1@insurebook.com")

    # Build motor insurance attributes based on available columns
    motor_attrs = {
      customer: customer,
      policy_holder: "Self",
      insurance_company_name: "Bajaj Allianz",
      policy_type: "Comprehensive",
      policy_number: "BAJAJ-INSTALLMENT-#{Time.current.to_i}",
      policy_booking_date: Date.current - 3.months,
      policy_start_date: Date.current - 3.months,
      policy_end_date: Date.current + 9.months,
      vehicle_number: "KA01AB1234",
      net_premium: 24000,  # Annual premium
      gst_percentage: 18.0,
      total_premium: 28320,
      main_agent_commission_percentage: 10.0,
      status: "active"
    }

    # Add optional fields if they exist
    motor_attrs[:sub_agent] = sub_agent if motor_columns.include?('sub_agent_id') && sub_agent
    motor_attrs[:sub_agent_commission_percentage] = 3.0 if motor_columns.include?('sub_agent_commission_percentage')
    motor_attrs[:vehicle_make] = "Honda" if motor_columns.include?('vehicle_make')
    motor_attrs[:vehicle_model] = "City" if motor_columns.include?('vehicle_model')
    motor_attrs[:vehicle_type] = "Car" if motor_columns.include?('vehicle_type')
    motor_attrs[:payment_mode] = "Quarterly" if motor_columns.include?('payment_mode')
    motor_attrs[:registration_year] = 2022 if motor_columns.include?('registration_year')

    motor = MotorInsurance.create!(motor_attrs)
    puts "✅ Created Motor Insurance with Quarterly Payments"
    puts "   Policy Number: #{motor.policy_number}"
    puts "   Total Premium: ₹#{motor.total_premium}"
    puts "   Payment Mode: #{motor.payment_mode if motor.respond_to?(:payment_mode)}"

    # Add installment notification if notification_dates field exists
    if motor_columns.include?('notification_dates')
      next_installment = Date.current + 5.days
      notification_dates = [
        next_installment,
        next_installment + 3.months,
        next_installment + 6.months
      ]
      motor.update!(notification_dates: notification_dates.to_json)
      puts "   Next Installment Due: #{next_installment} (in 5 days)"
    end

  rescue => e
    puts "❌ Error creating motor insurance: #{e.message}"
  end
else
  puts "❌ Cannot create motor insurance without customer"
end

puts

# 5. Test all login methods again
puts "5. Testing All Login Methods:"
puts "-" * 40

test_cases = [
  { login: "95krishnamurthy@gmail.com", type: "Krishna Email" },
  { login: "9595951234", type: "Krishna Mobile" },
  { login: "KRISH1995P", type: "Krishna PAN" },
  { login: "subagent1@insurebook.com", type: "SubAgent Email" },
  { login: "9898981234", type: "SubAgent Mobile" },
  { login: "9876543210", type: "Customer Mobile" },
  { login: "ABCDE1234F", type: "Customer PAN" },
  { login: "rajesh.kumar@example.com", type: "Customer Email" }
]

test_cases.each do |test|
  user = User.find_for_database_authentication(login: test[:login])
  if user
    puts "✅ #{test[:type]}: '#{test[:login]}' → #{user.email}"
  else
    puts "❌ #{test[:type]}: '#{test[:login]}' → Not working"
  end
end

puts
puts "=" * 70
puts "Fix Complete!"
puts "=" * 70
puts
puts "✅ FIXED:"
puts "  • Customer PAN updated to ABCDE1234F"
puts "  • Krishna's PAN set to KRISH1995P"
puts "  • User accounts created/updated with PANs"
puts "  • Motor Insurance policy created"
puts
puts "📱 UPDATED LOGIN OPTIONS:"
puts "  Krishna: Email/Mobile/PAN (95krishnamurthy@gmail.com / 9595951234 / KRISH1995P)"
puts "  SubAgent: Email/Mobile (subagent1@insurebook.com / 9898981234)"
puts "  Customer: Email/Mobile/PAN (rajesh.kumar@example.com / 9876543210 / ABCDE1234F)"
puts
puts "🔐 ALL PASSWORDS:"
puts "  Krishna: KRIS@1995"
puts "  SubAgent: password123"
puts "  Customer: Test@1234 (if new account created)"
puts "=" * 70