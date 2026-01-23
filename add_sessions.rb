# Add more test session data
puts 'Adding session data for dashboard...'

# Create sessions for today
10.times do |i|
  visit = Ahoy::Visit.create!(
    visit_token: SecureRandom.hex(16),
    visitor_token: SecureRandom.hex(16),
    user_id: User.pluck(:id).sample,
    ip: "192.168.1.#{rand(1..255)}",
    user_agent: 'Mozilla/5.0',
    browser: ['Chrome', 'Safari', 'Firefox'].sample,
    os: ['Windows', 'Mac OS X', 'Linux'].sample,
    device_type: ['Desktop', 'Mobile', 'Tablet'].sample,
    country: ['United States', 'India', 'Canada'].sample,
    started_at: Time.current - i.hours
  )

  # Add events
  3.times do |j|
    Ahoy::Event.create!(
      visit: visit,
      user_id: visit.user_id,
      name: 'Viewed page',
      properties: {
        page: ['/admin/dashboard', '/admin/customers', '/admin/reports/sessions'].sample
      },
      time: visit.started_at + j.minutes
    )
  end
end

puts 'Session stats:'
puts "  Total visits: #{Ahoy::Visit.count}"
puts "  Active (30 min): #{Ahoy::Visit.where('started_at > ?', 30.minutes.ago).count}"
puts "  Today: #{Ahoy::Visit.where(started_at: Date.current.all_day).count}"
puts "  This week: #{Ahoy::Visit.where(started_at: 1.week.ago..Time.current).count}"