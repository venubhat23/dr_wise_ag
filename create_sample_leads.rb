#!/usr/bin/env ruby

# Create sample leads for demonstration
puts "Creating sample leads for demonstration..."

sample_leads = [
  {
    name: "Rajesh Kumar",
    contact_number: "9876543210",
    email: "rajesh.kumar@email.com",
    product_interest: "health",
    referred_by: "Agent - Amit Shah",
    current_stage: "one_on_one",
    created_date: 2.days.ago,
    note: "Family of 4 looking for comprehensive health insurance. Budget: ₹25,000-35,000 annually."
  },
  {
    name: "Priya Sharma",
    contact_number: "8765432109",
    email: "priya.sharma@email.com",
    product_interest: "life",
    referred_by: "Online Campaign",
    current_stage: "consultation",
    created_date: 3.days.ago,
    note: "Young professional interested in term life insurance. First-time buyer."
  },
  {
    name: "Suresh Patel",
    contact_number: "7654321098",
    email: "suresh.patel@email.com",
    product_interest: "motor",
    referred_by: "Walk-in",
    current_stage: "converted",
    created_date: 5.days.ago,
    note: "Owns Honda City, looking for comprehensive motor insurance with add-ons."
  },
  {
    name: "Kavita Singh",
    contact_number: "6543210987",
    email: "kavita.singh@email.com",
    product_interest: "health",
    referred_by: "Agent - Ravi Kumar",
    current_stage: "policy_created",
    created_date: 9.days.ago,
    note: "Senior citizen health insurance. Policy created and documentation completed."
  },
  {
    name: "Arun Mehta",
    contact_number: "5432109876",
    email: "arun.mehta@email.com",
    product_interest: "other",
    referred_by: "Tele-calling",
    current_stage: "referral_settled",
    created_date: 12.days.ago,
    note: "Travel insurance for business trips. Commission settled with referrer."
  },
  {
    name: "Meera Jain",
    contact_number: "9988776655",
    email: "meera.jain@email.com",
    product_interest: "health",
    referred_by: "Agent - Priya Singh",
    current_stage: "consultation",
    created_date: 1.day.ago,
    note: "Pregnant woman looking for maternity coverage. Urgent requirement."
  },
  {
    name: "Vikram Gupta",
    contact_number: "8877665544",
    email: "vikram.gupta@email.com",
    product_interest: "life",
    referred_by: "Online Campaign",
    current_stage: "one_on_one",
    created_date: 4.days.ago,
    note: "High income individual seeking ULIP with tax benefits. Investment oriented."
  },
  {
    name: "Sunita Reddy",
    contact_number: "7766554433",
    email: "sunita.reddy@email.com",
    product_interest: "motor",
    referred_by: "Agent - Amit Shah",
    current_stage: "consultation",
    created_date: 6.days.ago,
    note: "New car owner. First-time motor insurance buyer. Needs guidance on coverage."
  },
  {
    name: "Rohit Sharma",
    contact_number: "6655443322",
    email: "rohit.sharma@email.com",
    product_interest: "health",
    referred_by: "Agent - Suresh Patel",
    current_stage: "converted",
    created_date: 8.days.ago,
    note: "Diabetic patient looking for health insurance. Pre-existing condition coverage required."
  },
  {
    name: "Anita Verma",
    contact_number: "5544332211",
    email: "anita.verma@email.com",
    product_interest: "life",
    referred_by: "Walk-in",
    current_stage: "policy_created",
    created_date: 11.days.ago,
    note: "Working mother. Life insurance for child's education planning. Policy issued."
  }
]

sample_leads.each_with_index do |lead_data, index|
  begin
    lead = Lead.create!(lead_data)
    puts "✅ Created lead #{index + 1}: #{lead.name}"
  rescue => e
    puts "❌ Error creating lead #{lead_data[:name]}: #{e.message}"
  end
end

puts "\n📊 Lead Statistics:"
puts "Total Leads: #{Lead.count}"
puts "Consultation: #{Lead.where(current_stage: 'consultation').count}"
puts "One-on-One: #{Lead.where(current_stage: 'one_on_one').count}"
puts "Converted: #{Lead.where(current_stage: 'converted').count}"
puts "Policy Created: #{Lead.where(current_stage: 'policy_created').count}"
puts "Referral Settled: #{Lead.where(current_stage: 'referral_settled').count}"

puts "\n🎉 Sample leads created successfully!"