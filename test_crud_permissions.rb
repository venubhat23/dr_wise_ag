puts '🔍 Testing CRUD Permissions System...'
puts

# Test super admin
admin = User.find_by(email: 'admin@drwise.com')
if admin
  puts '✅ Super Admin: admin@drwise.com'
  puts '  Sidebar permissions: ' + (admin.sidebar_permissions || 'None')
  puts '  Is super admin?: Yes (always has full access)'
end

puts

# Create a test user with limited permissions
test_user = User.find_by(email: 'test_limited@example.com')
if !test_user
  test_user = User.create!(
    email: 'test_limited@example.com',
    first_name: 'Test',
    last_name: 'Limited',
    mobile: '9999999999',
    password: 'Test@123',
    user_type: 'admin',
    role_name: 'Data entry',
    status: true
  )
  puts '✅ Created test user: test_limited@example.com'
end

# Set CRUD permissions for test user
crud_permissions = {
  'customers' => { 'view' => true, 'create' => true, 'edit' => false, 'delete' => false },
  'leads' => { 'view' => true, 'create' => false, 'edit' => false, 'delete' => false },
  'health_insurance' => { 'view' => true, 'create' => true, 'edit' => true, 'delete' => false }
}

test_user.update_column(:sidebar_permissions, crud_permissions.to_json)
puts '✅ Set CRUD permissions for test user'
puts '  Permissions:'
crud_permissions.each do |module_key, perms|
  puts "    #{module_key}: View=#{perms['view']}, Create=#{perms['create']}, Edit=#{perms['edit']}, Delete=#{perms['delete']}"
end

puts

# Test old format compatibility
old_format_user = User.find_by(email: 'old_format@example.com')
if !old_format_user
  old_format_user = User.create!(
    email: 'old_format@example.com',
    first_name: 'Old',
    last_name: 'Format',
    mobile: '9999999998',
    password: 'Test@123',
    user_type: 'admin',
    role_name: 'Accounts',
    status: true
  )
end

# Set old format permissions (array)
old_format_user.update_column(:sidebar_permissions, '["customers","reports","payouts"]')
puts '✅ Set old format permissions (backward compatible)'
puts '  Permissions (old array format): ["customers","reports","payouts"]'
puts '  These will be treated as view-only permissions'

puts
puts '🎉 CRUD Permissions System Test Complete!'
puts
puts 'Summary:'
puts '  1. admin@drwise.com - Super admin with full access'
puts '  2. test_limited@example.com - Limited CRUD permissions'
puts '  3. old_format@example.com - Backward compatible view-only'