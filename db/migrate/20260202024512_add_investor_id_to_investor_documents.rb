class AddInvestorIdToInvestorDocuments < ActiveRecord::Migration[8.0]
  def change
    add_reference :investor_documents, :investor_id, null: false, foreign_key: true
  end
end
