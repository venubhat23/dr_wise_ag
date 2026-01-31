puts '🔧 Creating user accounts and updating passwords to password123'
puts '=' * 60
puts

# First, get the customer role
customer_role = Role.find_by(name: 'customer') || Role.find_by(name: 'Customer')
if !customer_role
  puts 'Creating customer role...'
  customer_role = Role.create!(name: 'customer', description: 'Customer role', status: true)
end

# Customers without accounts
customers_to_create = [
  'testclient@example.com',
  'john.doe@example.com',
  'john.test@example.com',
  'test.lead2@example.com',
  'suresh.rao@example.com',
  'meera.joshi@example.com',
  'ravi.gupta@example.com'
]

# Create accounts for customers without users
puts '📝 Creating new user accounts:'
puts
customers_to_create.each do |email|
  customer = Customer.find_by(email: email)
  next unless customer

  if User.exists?(email: email)
    puts "⚠️  User already exists for: #{email}"
    next
  end

  password = 'password123'
  name_parts = customer.display_name.split(' ', 2)

  user = User.new(
    email: email,
    first_name: name_parts[0] || customer.display_name,
    last_name: name_parts[1] || '',
    password: password,
    password_confirmation: password,
    role_id: customer_role.id,
    original_password: password,
    mobile: customer.mobile,
    user_type: 'customer',
    status: 'active'
  )

  if user.save
    # Customer model doesn't have user_id field, just save the user
    puts "✅ Created user for: #{customer.display_name}"
    puts "   Email: #{email}"
    puts "   Password: password123"
    puts
  else
    puts "❌ Failed: #{email} - #{user.errors.full_messages.join(', ')}"
    puts
  end
end

# Handle special case with Time.current email
special_customer = Customer.find_by('email LIKE ?', '%Time.current%')
if special_customer
  new_email = "test.customer.#{Time.current.to_i}@example.com"
  special_customer.update(email: new_email)

  if !User.exists?(email: new_email)
    password = 'password123'
    name_parts = special_customer.display_name.split(' ', 2)

    user = User.new(
      email: new_email,
      first_name: name_parts[0] || special_customer.display_name,
      last_name: name_parts[1] || '',
      password: password,
      password_confirmation: password,
      role_id: customer_role.id,
      original_password: password,
      mobile: special_customer.mobile,
      user_type: 'customer',
      status: 'active'
    )

    if user.save
      special_customer.update(user_id: user.id)
      puts "✅ Created user for: #{special_customer.display_name}"
      puts "   Email: #{new_email}"
      puts "   Password: password123"
      puts
    end
  end
end

puts
puts '📝 Updating existing users to password123:'
puts

# Update all existing users to have password123
User.where(user_type: 'customer').each do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.original_password = 'password123'

  if user.save
    puts "✅ Updated password for: #{user.email}"
    puts "   New Password: password123"
  else
    puts "❌ Failed to update: #{user.email}"
  end
end

puts
puts '=' * 60
puts '✅ All operations completed!'
puts
puts '📋 SUMMARY:'
puts "All customer users now have password: password123"
puts "122pramod bhat's original password was: 122P@2025"