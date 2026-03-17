puts '🔧 Adding family members to Raj b tet customer...'

customer = Customer.find(95)
puts "Customer: #{customer.display_name}"

# Add family members for testing
family_members_data = [
  {
    first_name: 'Sunita',
    last_name: 'Raj',
    relationship: 'spouse',
    age: 35,
    customer_id: customer.id
  },
  {
    first_name: 'Arjun',
    last_name: 'Raj',
    relationship: 'son',
    age: 12,
    customer_id: customer.id
  },
  {
    first_name: 'Kavya',
    last_name: 'Raj',
    relationship: 'daughter',
    age: 8,
    customer_id: customer.id
  }
]

puts 'Adding family members:'
family_members_data.each do |member_data|
  member = FamilyMember.create!(member_data)
  puts "  ✅ Added: #{member.name} (#{member.relationship}, Age: #{member.age})"
end

puts
puts '🎉 Family members added successfully!'
puts "Now customer #{customer.display_name} has #{customer.family_members.count} family members"

# Test the API response now
family_members = customer.family_members.reload
nominee_options = []
family_members.each do |member|
  if member.name.present? && member.name.strip.length > 0 && !member.name.strip.match?(/^\d+$/)
    nominee_options << {
      nominee_name: member.name,
      relationship: member.relationship&.downcase || 'other',
      age: member.age || 0
    }
  end
end

puts
puts '✅ API will now return:'
nominee_options.each { |n| puts "  - #{n[:nominee_name]} (#{n[:relationship]}, #{n[:age]})" }

puts
puts '💡 Now when you click "Load from Client" in Motor Insurance, it will auto-load these nominees!'