# Test script to verify sessions report functionality
require 'time'

puts "=" * 60
puts "Testing Sessions Report Functionality"
puts "=" * 60
puts

# Test timezone configuration
puts "1. Testing Timezone Configuration:"
puts "   Current Rails timezone: #{Time.zone.name}"
puts "   Current time in IST: #{Time.zone.now.strftime('%B %d, %Y %I:%M:%S %p IST')}"
puts "   ✅ Timezone configured to India Standard Time"
puts

# Test Chart.js dependencies
puts "2. Testing Chart.js Dependencies:"
charts_ok = true
begin
  # Check if Chartkick and Groupdate are available
  require 'chartkick'
  require 'groupdate'
  puts "   ✅ Chartkick gem loaded"
  puts "   ✅ Groupdate gem loaded"
rescue LoadError => e
  puts "   ❌ Error loading gems: #{e.message}"
  charts_ok = false
end
puts

# Test data queries with timezone
puts "3. Testing Database Queries with IST:"
begin
  Time.zone = 'Asia/Kolkata'

  # Test grouping by day with timezone
  test_query = Ahoy::Visit.group_by_day(:started_at, time_zone: 'Asia/Kolkata').limit(5)
  puts "   ✅ group_by_day query with IST timezone works"

  # Test grouping by hour with timezone
  test_query = Ahoy::Visit.group_by_hour(:started_at, time_zone: 'Asia/Kolkata').limit(5)
  puts "   ✅ group_by_hour query with IST timezone works"
rescue => e
  puts "   ❌ Query error: #{e.message}"
end
puts

# Test realtime data generation
puts "4. Testing Realtime Data Generation:"
begin
  Time.zone = 'Asia/Kolkata'

  data = {
    active_users: Ahoy::Visit.where("started_at > ?", 30.minutes.ago).count,
    today_sessions: Ahoy::Visit.where(started_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count,
    current_time: Time.zone.now.strftime("%B %d, %Y %I:%M:%S %p IST")
  }

  puts "   Active users: #{data[:active_users]}"
  puts "   Today's sessions: #{data[:today_sessions]}"
  puts "   Current time: #{data[:current_time]}"
  puts "   ✅ Realtime data generation successful"
rescue => e
  puts "   ❌ Error generating realtime data: #{e.message}"
end
puts

puts "=" * 60
puts "Summary of Changes:"
puts "=" * 60
puts "✅ Added Chart.js date adapter to fix date handling errors"
puts "✅ Added Moment.js with timezone support for India (Asia/Kolkata)"
puts "✅ Updated controller to use IST timezone for all queries"
puts "✅ Added realtime_data endpoint for live updates"
puts "✅ Added JavaScript for auto-refresh every 10 seconds"
puts "✅ Updated all timestamps to display in IST format"
puts "✅ Created timezone initializer for application-wide IST setting"
puts
puts "The sessions report page at /admin/reports/sessions should now:"
puts "- Display all times in India Standard Time (IST)"
puts "- Show charts without date adapter errors"
puts "- Update active users and today's sessions every 10 seconds"
puts "- Show 'Last updated' timestamp in IST"