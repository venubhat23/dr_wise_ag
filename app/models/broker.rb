class Broker < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :status, inclusion: { in: %w[active inactive] }

  scope :active, -> { where(status: 'active') }
  scope :inactive, -> { where(status: 'inactive') }

  def active?
    status == 'active'
  end

  def inactive?
    status == 'inactive'
  end
end
