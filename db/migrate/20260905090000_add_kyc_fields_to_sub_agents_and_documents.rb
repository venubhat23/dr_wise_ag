class AddKycFieldsToSubAgentsAndDocuments < ActiveRecord::Migration[8.0]
  def change
    add_column :sub_agents, :kyc_status, :integer, default: 0, null: false
    add_column :sub_agents, :kyc_submitted_at, :datetime
    add_column :sub_agents, :kyc_reviewed_at, :datetime
    add_column :sub_agents, :kyc_rejection_reason, :text
    add_column :sub_agents, :aadhaar_no, :string
    add_index :sub_agents, :kyc_status

    add_column :sub_agent_documents, :ocr_text, :text
    add_column :sub_agent_documents, :ocr_extracted_data, :jsonb, default: {}, null: false
    add_column :sub_agent_documents, :ocr_status, :string, default: "pending", null: false
    add_column :sub_agent_documents, :ocr_error, :text
  end
end
