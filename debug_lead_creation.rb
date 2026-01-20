# Clear the existing lead_id and try again
hi = HealthInsurance.find(9)
hi.update_column(:lead_id, nil)

puts 'Trying Lead creation with detailed error handling...'

customer = hi.customer
product_type = case hi.class.name
when 'HealthInsurance' then 'health'
when 'LifeInsurance' then 'life'
when 'MotorInsurance' then 'motor'
else 'other'
end

generated_lead_id = LeadIdGeneratorService.generate_for_policy(customer, hi.class.name)
puts "Generated Lead ID: #{generated_lead_id}"

# Build lead data manually to see what fails
lead_data = {
  lead_id: generated_lead_id,
  name: customer.display_name,
  contact_number: customer.mobile,
  email: customer.email,
  product_category: 'insurance',
  product_subcategory: product_type,
  current_stage: 'converted',
  customer_type: customer.customer_type,
  converted_customer_id: customer.id,
  policy_created_id: hi.id,
  stage_updated_at: Time.current,
  created_date: hi.policy_booking_date || Date.current,
  notes: "Auto-generated lead from health insurance policy creation. Policy Number: #{hi.policy_number}",
  is_direct: hi.sub_agent_id.blank?,
  affiliate_id: hi.sub_agent_id
}

puts 'Lead data prepared:'
lead_data.each { |k, v| puts "  #{k}: #{v}" }

puts "\nAttempting to create Lead..."
begin
  lead = Lead.create!(lead_data)
  puts "✅ Lead created successfully: #{lead.lead_id}"

  # Update the insurance with the generated lead_id
  hi.update_column(:lead_id, generated_lead_id)
  puts "✅ Updated Health Insurance with lead_id: #{generated_lead_id}"

rescue => e
  puts "❌ Lead creation failed: #{e.message}"
  if e.respond_to?(:record) && e.record&.errors&.any?
    puts '  Validation errors:'
    e.record.errors.each do |error|
      puts "    #{error.attribute}: #{error.message}"
    end
  end
end