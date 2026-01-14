class SubAgentDocument < ApplicationRecord
  # Associations
  belongs_to :sub_agent
  has_one_attached :document_file

  # Validations
  validates :document_type, presence: true
  # Custom validation for document file presence
  validate :document_file_presence
  validates :document_type, inclusion: {
    in: ['Aadhaar Card', 'Pancard', 'Driving License', 'Mediclaim', 'RC Book', 'Other File']
  }
  validate :validate_document_file_size

  private

  def document_file_presence
    return if document_file.attached?
    errors.add(:document_file, "must be attached")
  end

  def validate_document_file_size
    return unless document_file.attached?

    if document_file.blob.byte_size > 10.megabytes
      errors.add(:document_file, 'size should be less than 10MB')
    end
  end

  public

  # Instance methods
  def document_name
    document_file.attached? ? document_file.filename.to_s : "No file attached"
  end

  def document_size
    document_file.attached? ? number_to_human_size(document_file.byte_size) : "0 KB"
  end

  def document_url
    document_file.attached? ? Rails.application.routes.url_helpers.rails_blob_path(document_file, only_path: true) : nil
  end

  private

  def number_to_human_size(number)
    ActionController::Base.helpers.number_to_human_size(number)
  end
end