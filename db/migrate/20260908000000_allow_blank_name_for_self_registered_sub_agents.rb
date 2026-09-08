class AllowBlankNameForSelfRegisteredSubAgents < ActiveRecord::Migration[8.0]
  # Self-service affiliate registration (Api::V1::Mobile::AuthenticationController#register_sub_agent)
  # only collects email / mobile / password up front - first and last name arrive
  # later from the OCR-extracted KYC details (Api::V1::Mobile::KycController#update_details).
  def change
    change_column_null :sub_agents, :first_name, true
    change_column_null :sub_agents, :last_name, true
  end
end
