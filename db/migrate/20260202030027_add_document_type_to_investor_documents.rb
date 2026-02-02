class AddDocumentTypeToInvestorDocuments < ActiveRecord::Migration[8.0]
  def change
    add_column :investor_documents, :document_type, :string
  end
end
