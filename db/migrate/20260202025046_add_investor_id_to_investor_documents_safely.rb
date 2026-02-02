class AddInvestorIdToInvestorDocumentsSafely < ActiveRecord::Migration[8.0]
  def change
    add_column :investor_documents, :investor_id, :integer
    add_index :investor_documents, :investor_id
  end
end
