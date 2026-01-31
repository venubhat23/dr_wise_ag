puts '🔧 Fixing remaining user issues...'
puts

# Get customer role
customer_role = Role.find_by(name: 'customer')

# Create user for Test Client
test_client = Customer.find_by(email: 'testclient@example.com')
if test_client
  existing_user = User.find_by(email: 'testclient@example.com')
  if !existing_user
    # Try with a unique mobile number
    user = User.new(
      email: 'testclient@example.com',
      first_name: 'Test',
      last_name: 'Client',
      password: 'password123',
      password_confirmation: 'password123',
      role_id: customer_role.id,
      original_password: 'password123',
      mobile: '9999999999-' + Time.current.to_i.to_s, # Make it unique
      user_type: 'customer',
      status: 'active'
    )

    if user.save
      puts "✅ Created user for Test Client"
      puts "   Password: password123"
    else
      puts "❌ Failed to create Test Client: #{user.errors.full_messages.join(', ')}"
    end
  end
end

# Update Priya Sharma's original_password
priya_user = User.find_by(email: 'priya.sharma@example.com')
if priya_user
  priya_user.update(original_password: 'password123')
  puts "✅ Updated Priya Sharma's original_password to: password123"
end

puts
puts '📋 FINAL STATUS:'
puts
['ddfsd@gmail.com', 'testclient@example.com', 'priya.sharma@example.com'].each do |email|
  user = User.find_by(email: email)
  if user
    puts "#{email}: original_password = #{user.original_password || 'NULL'}"
  else
    puts "#{email}: NO USER ACCOUNT"
  end
end