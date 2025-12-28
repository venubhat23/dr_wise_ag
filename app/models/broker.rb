class Broker < ApplicationRecord
  belongs_to :insurance_company, optional: true
  has_many :agency_codes, dependent: :nullify

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :status, inclusion: { in: %w[active inactive] }

  before_validation :set_default_status, on: :create

  scope :active, -> { where(status: 'active') }
  scope :inactive, -> { where(status: 'inactive') }

  def active?
    status == 'active'
  end

  def inactive?
    status == 'inactive'
  end

  private

  def set_default_status
    self.status ||= 'active'
  end
end
