puts 'Testing complete Health Insurance creation flow...'

# Find a customer to use
customer = Customer.first
sub_agent = SubAgent.first
puts "Using Customer: #{customer&.display_name}"
puts "Using Sub Agent: #{sub_agent&.full_name}"

# Create a test health insurance policy
hi_params = {
  customer: customer,
  sub_agent: sub_agent,
  policy_holder: 'Self',
  insurance_company_name: 'Test Health Insurance Co Ltd',
  policy_type: 'New',
  insurance_type: 'Family Floater',
  policy_number: 'TEST-' + Time.current.to_i.to_s,
  policy_booking_date: Date.current,
  policy_start_date: Date.current,
  policy_end_date: 1.year.from_now,
  payment_mode: 'Yearly',
  sum_insured: 500000,
  net_premium: 25000,
  gst_percentage: 18.0,
  total_premium: 29500,
  main_agent_commission_percentage: 20.0,
  sub_agent_commission_percentage: 3.0,
  ambassador_commission_percentage: 5.0,
  investor_commission_percentage: 1.0,
  company_expenses_percentage: 5.0,
  policy_added_by_admin: true,
  is_admin_added: true,
  is_customer_added: false,
  is_agent_added: false
}

puts "\nCreating Health Insurance policy..."
hi = HealthInsurance.create!(hi_params)
puts "✅ Created Health Insurance ID: #{hi.id}"
puts "   Policy Number: #{hi.policy_number}"
puts "   Lead ID: #{hi.lead_id}"

puts "\nChecking created records..."

# Check if lead was created
if hi.lead_id.present?
  lead = Lead.find_by(lead_id: hi.lead_id)
  if lead
    puts "✅ Lead created: #{lead.lead_id} - Stage: #{lead.current_stage}"
  else
    puts "❌ Lead ID exists but Lead record not found: #{hi.lead_id}"
  end
else
  puts "❌ No Lead ID assigned"
end

# Check commission payouts
payouts = CommissionPayout.where(policy_type: 'health', policy_id: hi.id)
puts "✅ Commission Payouts created: #{payouts.count}"
payouts.each do |payout|
  puts "   #{payout.payout_to}: Rs.#{payout.payout_amount} (#{payout.status})"
end

# Check main payout
main_payouts = Payout.where(policy_type: 'health', policy_id: hi.id)
puts "✅ Main Payouts created: #{main_payouts.count}"
main_payouts.each do |payout|
  puts "   Total Commission: Rs.#{payout.total_commission_amount} (#{payout.status})"
end

puts "\n🎉 Health Insurance creation flow test completed!"