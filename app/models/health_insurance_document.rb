class HealthInsuranceDocument < ApplicationRecord
  belongs_to :health_insurance

  validates :title, presence: true
  validates :document_type, presence: true
  validates :r2_file_key, presence: true

  # Document type options
  DOCUMENT_TYPES = [
    'policy_document',
    'medical_report',
    'identity_proof',
    'income_proof',
    'previous_policy',
    'claim_form',
    'discharge_summary',
    'prescription',
    'lab_report',
    'other'
  ].freeze

  validates :document_type, inclusion: { in: DOCUMENT_TYPES }

  # Generate public URL for R2 stored document
  def document_url
    return nil unless r2_file_key.present?
    R2Service.public_url(r2_file_key)
  end

  # Check if document has a valid R2 file
  def has_r2_file?
    r2_file_key.present? && r2_filename.present?
  end

  # Human readable file size
  def formatted_file_size
    return 'Unknown' unless r2_file_size.present?
    ActionController::Base.helpers.number_to_human_size(r2_file_size)
  end
end
