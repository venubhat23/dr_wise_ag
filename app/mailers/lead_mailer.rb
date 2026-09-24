class LeadMailer < ApplicationMailer
  def lead_submitted_to_affiliate(lead)
    @lead = lead
    @affiliate = lead.affiliate
    mail(to: @affiliate.email, subject: "Lead #{@lead.lead_id} submitted successfully")
  end

  def lead_submitted_to_customer(lead)
    @lead = lead
    @affiliate = lead.affiliate
    mail(to: @lead.email, subject: "Thank you for your interest in #{@lead.insurance_interest || 'our services'}")
  end
end
