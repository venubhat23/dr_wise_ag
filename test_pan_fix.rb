# Test the PAN validation fix
puts '=== Testing PAN Validation Fix ==='
puts

# Check current lead 26
begin
  lead = Lead.find(26)
  puts "Lead 26 current details:"
  puts "  Name: #{lead.display_name}"
  puts "  PAN: #{lead.pan_no}"
  puts "  Is Branch Out: #{lead.is_branch_out}"
  puts "  Current Stage: #{lead.current_stage}"
  puts

  # Check if there are other leads with same PAN but are branch out leads
  same_pan_leads = Lead.where(pan_no: lead.pan_no).where.not(id: lead.id)
  puts "Other leads with same PAN (#{lead.pan_no}):"
  same_pan_leads.each do |other_lead|
    puts "  ID #{other_lead.id}: #{other_lead.display_name} - Branch Out: #{other_lead.is_branch_out}"
  end
  puts

  # Test if lead 26 can now be updated
  puts 'Testing lead update...'
  lead.notes = 'Testing PAN validation fix'
  if lead.valid?
    puts '✅ Lead validation passed!'
    lead.save!
    puts '✅ Lead updated successfully!'
  else
    puts '❌ Lead validation failed:'
    lead.errors.full_messages.each { |msg| puts "  - #{msg}" }
  end

rescue => e
  puts "❌ Error: #{e.message}"
end