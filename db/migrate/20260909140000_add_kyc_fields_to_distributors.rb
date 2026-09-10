class AddKycFieldsToDistributors < ActiveRecord::Migration[8.0]
  def change
    add_column :distributors, :kyc_status, :integer, default: 0, null: false
    add_column :distributors, :kyc_submitted_at, :datetime
    add_column :distributors, :kyc_reviewed_at, :datetime
    add_column :distributors, :kyc_rejection_reason, :text
    add_column :distributors, :self_registered, :boolean, default: false, null: false
    add_index :distributors, :kyc_status
  end
end
