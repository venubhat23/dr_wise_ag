#!/usr/bin/env ruby
# Create Motor Insurance with proper fields

puts "Creating Motor Insurance with Installment in 5 days..."
puts "-" * 60

customer = Customer.find_by(mobile: "9876543210")
sub_agent = SubAgent.find_by(email: "subagent1@insurebook.com")

if customer
  begin
    # Create motor insurance with quarterly payment (installment in 5 days)
    motor = MotorInsurance.create!(
      customer: customer,
      sub_agent: sub_agent,
      policy_holder: "Self",
      insurance_company_name: "Bajaj Allianz General Insurance",
      policy_type: "Comprehensive",
      insurance_type: "Comprehensive",
      policy_number: "BAJ-MOTOR-Q#{Time.current.to_i}",
      policy_booking_date: Date.current - 85.days,  # Started ~3 months ago
      policy_start_date: Date.current - 85.days,
      policy_end_date: Date.current + 280.days,    # ~1 year total
      payment_mode: "Quarterly",
      vehicle_type: "New Vehicle",
      class_of_vehicle: "Private Car",
      vehicle_make: "Honda",
      vehicle_model: "City",
      vehicle_number: "KA01AB1234",
      registration_number: "KA01AB1234",
      vehicle_idv: 600000,
      net_premium: 6000,    # Quarterly payment
      gst_percentage: 18.0,
      total_premium: 7080,  # Quarterly amount
      main_agent_commission_percentage: 10.0,
      sub_agent_commission_percentage: 3.0,
      status: "active"
    )

    puts "✅ Motor Insurance Created Successfully!"
    puts "   Policy Number: #{motor.policy_number}"
    puts "   Vehicle: #{motor.vehicle_make} #{motor.vehicle_model} (#{motor.vehicle_number})"
    puts "   Payment Mode: #{motor.payment_mode}"
    puts "   Quarterly Premium: ₹#{motor.total_premium}"
    puts "   Policy Period: #{motor.policy_start_date} to #{motor.policy_end_date}"
    puts
    puts "📅 Installment Schedule:"
    puts "   1st Installment: Paid on #{motor.policy_booking_date}"
    puts "   2nd Installment: Due on #{Date.current + 5.days} (in 5 days) ⚠️"
    puts "   3rd Installment: Due on #{Date.current + 95.days}"
    puts "   4th Installment: Due on #{Date.current + 185.days}"

    # Update notification dates if field exists
    if MotorInsurance.column_names.include?('notification_dates')
      notification_dates = [
        Date.current + 5.days,
        Date.current + 95.days,
        Date.current + 185.days
      ]
      motor.update!(notification_dates: notification_dates.to_json)
      puts
      puts "✅ Notification reminders set for upcoming installments"
    end

  rescue => e
    puts "❌ Error creating motor insurance: #{e.message}"
    puts "   Details: #{e.record.errors.full_messages.join(', ')}" if e.respond_to?(:record)
  end
else
  puts "❌ Customer not found"
end

puts
puts "-" * 60
puts "Summary:"
puts "  • Motor Insurance created with quarterly payments"
puts "  • Next installment due in 5 days"
puts "  • Customer will receive payment reminders"