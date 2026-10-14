namespace :customers do
  # Report customers without a mobile app login; with CREATE=1, create the missing
  # logins using Customer::DEFAULT_LOGIN_PASSWORD.
  #   bin/rails customers:mobile_logins
  #   CREATE=1 bin/rails customers:mobile_logins
  desc 'Report (and with CREATE=1 create) missing customer mobile logins'
  task mobile_logins: :environment do
    create = ENV['CREATE'] == '1'

    customers = Customer.select(:id, :first_name, :last_name, :company_name, :customer_type, :email, :mobile).to_a
    emails = customers.map(&:email).compact_blank
    mobiles = customers.map(&:mobile).compact_blank
    users = User.where(email: emails).or(User.where(mobile: mobiles + mobiles.map { |m| "+91#{m}" }))
                .pluck(:email, :mobile)
    user_emails = users.map(&:first).to_set
    user_mobiles = users.map { |_, m| m.to_s.delete_prefix('+91') }.to_set

    with_login, no_email, missing = [], [], []
    customers.each do |c|
      if user_emails.include?(c.email) || user_mobiles.include?(c.mobile)
        with_login << c
      elsif c.email.blank?
        no_email << c
      else
        missing << c
      end
    end

    puts "Customers: #{customers.size} | with login: #{with_login.size} | " \
         "missing login: #{missing.size} | no email (cannot create): #{no_email.size}"

    missing.each do |c|
      line = "  ##{c.id} #{c.display_name} <#{c.email}> #{c.mobile}"
      if create
        begin
          Customer.find(c.id).create_login_user!
          puts "#{line} -> created (#{Customer::DEFAULT_LOGIN_PASSWORD})"
        rescue ActiveRecord::RecordInvalid => e
          puts "#{line} -> FAILED: #{e.record.errors.full_messages.to_sentence}"
        end
      else
        puts line
      end
    end
    no_email.each { |c| puts "  ##{c.id} #{c.display_name} (no email) #{c.mobile}" }
    puts "Dry run only. Re-run with CREATE=1 to create the missing logins." unless create || missing.empty?
  end
end
