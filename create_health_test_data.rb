puts 'Creating test data for Health Insurance Broker Code functionality:'

# Create some Health insurance agency codes for testing
puts '1. Creating Health insurance agency codes...'
unless AgencyCode.where(insurance_type: 'Health Insurance').exists?
  [
    { agent_name: 'Health Agent 1', code: 'H001', company_name: 'ICICI Lombard' },
    { agent_name: 'Health Agent 2', code: 'H002', company_name: 'Star Health' },
    { agent_name: 'Health Agent 3', code: 'H003', company_name: 'HDFC ERGO' }
  ].each do |data|
    AgencyCode.create!(
      insurance_type: 'Health Insurance',
      agent_name: data[:agent_name],
      code: data[:code],
      company_name: data[:company_name]
    )
  end
  puts "Created #{AgencyCode.where(insurance_type: 'Health Insurance').count} Health agency codes"
else
  puts "Health agency codes already exist: #{AgencyCode.where(insurance_type: 'Health Insurance').count}"
end

# Create some Health insurance companies
puts '2. Creating Health insurance companies...'
unless InsuranceCompany.where(insurance_type: 'health').exists?
  ['ICICI Lombard', 'Star Health', 'HDFC ERGO', 'Max Bupa', 'Care Health'].each do |company_name|
    InsuranceCompany.create!(
      name: company_name,
      insurance_type: 'health'
    )
  end
  puts "Created #{InsuranceCompany.where(insurance_type: 'health').count} Health insurance companies"
else
  puts "Health insurance companies already exist: #{InsuranceCompany.where(insurance_type: 'health').count}"
end

puts '✅ Test data created successfully!'