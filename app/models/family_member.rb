class FamilyMember < ApplicationRecord
  belongs_to :customer
  has_many_attached :documents

  validates :name, presence: true
  validates :birth_date, presence: true
  validates :relationship, presence: true, inclusion: { in: ['self', 'spouse', 'child', 'parent', 'sibling', 'other'] }

  enum :relationship, { self: 'self', spouse: 'spouse', child: 'child', parent: 'parent', sibling: 'sibling', other: 'other' }

  before_save :calculate_age

  private

  def calculate_age
    if birth_date.present?
      self.age = Date.current.year - birth_date.year
      self.age -= 1 if Date.current < birth_date + age.years
    end
  end
end
