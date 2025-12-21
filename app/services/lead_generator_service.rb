class LeadGeneratorService
  def self.create_lead_for_insurance(insurance)
    return if insurance.lead_id.present? # Skip if lead already exists

    product_type = determine_product_type(insurance)

    lead = Lead.create!(
      name: insurance.customer.display_name,
      contact_number: insurance.customer.mobile,
      email: insurance.customer.email,
      product_interest: product_type,
      current_stage: 'policy_created',
      lead_source: determine_lead_source(insurance),
      converted_customer_id: insurance.customer.id,
      policy_created_id: insurance.id,
      stage_updated_at: Time.current,
      created_date: insurance.policy_booking_date || Date.current,
      referred_by: determine_referred_by(insurance),
      notes: "Auto-generated lead from #{insurance.class.name.underscore.humanize.downcase} policy creation. Policy Number: #{insurance.policy_number}"
    )

    # Update the insurance with the generated lead_id
    insurance.update_column(:lead_id, lead.lead_id)

    lead
  rescue StandardError => e
    Rails.logger.error "Failed to create lead for #{insurance.class.name} #{insurance.id}: #{e.message}"
    nil
  end

  private

  def self.determine_product_type(insurance)
    case insurance.class.name
    when 'HealthInsurance' then 'health'
    when 'LifeInsurance' then 'life'
    when 'MotorInsurance' then 'motor'
    when 'OtherInsurance' then 'other'
    else 'other'
    end
  end

  def self.determine_lead_source(insurance)
    # Check if it's customer-added
    if insurance.respond_to?(:is_customer_added?) && insurance.is_customer_added?
      'online'
    elsif insurance.sub_agent_id.present?
      'agent_referral'
    else
      'offline'
    end
  end

  def self.determine_referred_by(insurance)
    if insurance.sub_agent_id.present?
      insurance.sub_agent&.display_name
    elsif insurance.respond_to?(:distributor_id) && insurance.distributor_id.present?
      insurance.distributor&.full_name
    else
      nil
    end
  end
end