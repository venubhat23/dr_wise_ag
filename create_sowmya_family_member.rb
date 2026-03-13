puts '🔍 Creating SOWMYA HT as family member for M P VIJENDRA...'
puts

customer = Customer.find(75)
puts "Customer: #{customer.display_name} (ID: #{customer.id})"
puts "Current family members: #{customer.family_members.count}"

# Check if SOWMYA already exists
existing = customer.family_members.where('first_name ILIKE ?', '%SOWMYA%').first

if existing
  puts 'SOWMYA already exists for this customer'
else
  # Create SOWMYA HT as spouse
  family_member = customer.family_members.create!(
    first_name: 'SOWMYA',
    last_name: 'HT',
    relationship: 'spouse',
    gender: 'female',
    age: 30
  )

  if family_member.persisted?
    puts "✅ Created family member: #{family_member.name}"
    puts "   Relationship: #{family_member.relationship}"
    puts "   Age: #{family_member.age}"
    puts "   ID: #{family_member.id}"
  else
    puts '❌ Failed to create family member'
    puts family_member.errors.full_messages
  end
end

puts
puts 'Testing API response for M P VIJENDRA now:'
nominee_options = []
customer.family_members.reload.each do |member|
  if member.name.present? && member.name.strip.length > 0
    nominee_options << {
      nominee_name: member.name,
      relationship: member.relationship&.downcase || 'other',
      age: member.age || 0
    }
  end
end

response = {
  success: true,
  nominees: nominee_options,
  customer_name: customer.display_name
}

puts response.to_json