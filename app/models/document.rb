class Document < ApplicationRecord
  belongs_to :documentable, polymorphic: true
  has_one_attached :file

  validates :document_type, presence: true
  validates :file, presence: true

  DOCUMENT_TYPES = [
    'aadhar', 'pan_card', 'driving_license', 'passport', 'voter_id',
    'birth_certificate', 'marriage_certificate', 'income_certificate',
    'salary_slip', 'bank_statement', 'gst_certificate', 'other'
  ].freeze

  validates :document_type, inclusion: { in: DOCUMENT_TYPES }

  scope :by_type, ->(type) { where(document_type: type) }
end