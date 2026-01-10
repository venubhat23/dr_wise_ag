#!/usr/bin/env ruby

# Don't clear existing data due to foreign key constraints
# Just add new companies that don't already exist
puts "Checking existing insurance companies..."
puts "Current count: #{InsuranceCompany.count}"

# Life Insurance Companies
life_companies = [
  "LIC",
  "HDFC Life Insurance",
  "Axis Max Life Insurance",
  "ICICI Prudential Life Insurance",
  "Kotak Life Insurance",
  "Aditya Birla Sun Life Insurance",
  "TATA AIA Life Insurance",
  "SBI Life Insurance",
  "Bajaj Allianz Life Insurance",
  "Reliance Nippon Life Insurance Company",
  "Shriram Life Insurance",
  "Canara HSBC Life Insurance",
  "Edelweiss Life Insurance",
  "Go Digit Life Insurance Limited"
]

# Health Insurance Companies
health_companies = [
  "Aditya Birla Health Ins",
  "Bajaj Allianz General Ins",
  "Manipal Cigna Health Ins Co. Ltd",
  "HDFC ERGO General Ins Co.",
  "ICICI Lombard",
  "Zurich Kotak General Ins",
  "Niva Bupa Health Ins",
  "National Ins Co.",
  "New India Assurance",
  "Reliance General Ins",
  "Care Health Ins Ltd",
  "Royal Sundaram General Ins",
  "SBI General Ins",
  "Star Health and Allied Ins Co Ltd",
  "Tata AIG General Ins",
  "The Oriental Ins Co.",
  "United India Ins Co.",
  "Galaxy Health Ins Co Ltd"
]

# General Insurance Companies
general_companies = [
  "Agriculture Ins Co of India",
  "Bajaj Allianz General Ins",
  "Cholamandalam MS General Ins",
  "Navi General Ins Limited",
  "Go Digit Ins",
  "Zuno General Ins",
  "ECGC Limited",
  "Future Generali India Ins",
  "HDFC ERGO General Ins Co",
  "ICICI Lombard",
  "IFFCO TOKIO General Ins",
  "Zurich Kotak General Ins",
  "Liberty General Ins",
  "Magma General Ins",
  "National Ins Co",
  "New India Assurance",
  "Raheja QBE General Ins",
  "Reliance General Ins",
  "Royal Sundaram General Ins",
  "SBI General Ins",
  "Shriram General Ins",
  "Tata AIG General Ins",
  "The Oriental Ins Co",
  "United India Ins Co",
  "Universal Sompo General Ins Co",
  "Kshema General Ins Limited"
]

def generate_code(name)
  # Generate code from company name
  words = name.gsub(/[^a-zA-Z\s]/, '').split(/\s+/)
  code = if words.length == 1
           words[0][0..3].upcase
         elsif words.length == 2
           "#{words[0][0]}#{words[1][0..2]}".upcase
         else
           words[0..2].map { |w| w[0] }.join.upcase
         end
  code
end

puts "Creating Life Insurance Companies..."
life_companies.each_with_index do |company, index|
  next if InsuranceCompany.exists?(name: company)

  InsuranceCompany.create!(
    name: company,
    code: generate_code(company),
    insurance_type: 'Life',
    status: true,
    contact_person: "Contact Person #{index + 1}",
    email: "contact.#{company.downcase.gsub(/[^a-z0-9]/, '')}@example.com",
    mobile: "9#{(1000000000 + index).to_s[1..-1]}",
    address: "#{company} Head Office, Mumbai, India"
  )
  print "."
end
puts " ✅ #{life_companies.count} Life Insurance companies created"

puts "Creating Health Insurance Companies..."
health_companies.each_with_index do |company, index|
  next if InsuranceCompany.exists?(name: company)

  InsuranceCompany.create!(
    name: company,
    code: generate_code(company),
    insurance_type: 'Health',
    status: true,
    contact_person: "Health Contact #{index + 1}",
    email: "health.#{company.downcase.gsub(/[^a-z0-9]/, '')}@example.com",
    mobile: "8#{(1000000000 + index).to_s[1..-1]}",
    address: "#{company} Health Division, Delhi, India"
  )
  print "."
end
puts " ✅ #{health_companies.count} Health Insurance companies created"

puts "Creating General Insurance Companies..."
general_companies.each_with_index do |company, index|
  next if InsuranceCompany.exists?(name: company)

  InsuranceCompany.create!(
    name: company,
    code: generate_code(company),
    insurance_type: 'General',
    status: true,
    contact_person: "General Contact #{index + 1}",
    email: "general.#{company.downcase.gsub(/[^a-z0-9]/, '')}@example.com",
    mobile: "7#{(1000000000 + index).to_s[1..-1]}",
    address: "#{company} General Insurance Office, Bangalore, India"
  )
  print "."
end
puts " ✅ #{general_companies.count} General Insurance companies created"

puts "\n🎉 Successfully populated insurance companies database!"
puts "Total companies created: #{InsuranceCompany.count}"
puts "Life: #{InsuranceCompany.life.count}"
puts "Health: #{InsuranceCompany.health.count}"
puts "General: #{InsuranceCompany.general.count}"