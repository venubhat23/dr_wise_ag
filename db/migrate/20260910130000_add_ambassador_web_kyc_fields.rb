class AddAmbassadorWebKycFields < ActiveRecord::Migration[8.0]
  # Web KYC wizard for self-registered ambassadors (Distributor + User pair).
  # Mirrors the mobile affiliate KYC flow: upload ID docs -> OCR -> confirm
  # personal details -> bank details -> photo -> submit for admin review.
  def change
    # Aadhaar number captured during the "Personal details" step (PAN column
    # pan_no already exists on distributors).
    add_column :distributors, :aadhaar_no, :string

    # Furthest wizard step the ambassador has completed:
    #   0 nothing, 1 documents, 2 personal, 3 bank, 4 photo.
    add_column :distributors, :kyc_step, :integer, default: 0, null: false

    # OCR results per uploaded KYC document (same shape as sub_agent_documents).
    add_column :distributor_documents, :ocr_text, :text
    add_column :distributor_documents, :ocr_extracted_data, :jsonb, default: {}, null: false
    add_column :distributor_documents, :ocr_status, :string
    add_column :distributor_documents, :ocr_error, :text
  end
end
