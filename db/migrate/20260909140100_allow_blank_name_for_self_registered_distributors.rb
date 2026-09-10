class AllowBlankNameForSelfRegisteredDistributors < ActiveRecord::Migration[8.0]
  # Public ambassador self-registration (AmbassadorRegistrationsController) only
  # collects email / mobile / password up front - first and last name are filled
  # in later during the admin KYC review, mirroring the self-registered affiliate
  # flow (see AllowBlankNameForSelfRegisteredSubAgents).
  def change
    change_column_null :distributors, :first_name, true
    change_column_null :distributors, :last_name, true
  end
end
