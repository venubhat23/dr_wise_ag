class AddMissingColumnsToLifeInsuranceDocuments < ActiveRecord::Migration[8.0]
  def change
    add_column :life_insurance_documents, :life_insurance_id, :integer
    add_index :life_insurance_documents, :life_insurance_id
    add_column :life_insurance_documents, :document_type, :string
    add_column :life_insurance_documents, :document_name, :string
  end
end
