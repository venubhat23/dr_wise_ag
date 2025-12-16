class CommissionPayout < ApplicationRecord
  validates :policy_type, presence: true, inclusion: { in: ['health', 'life', 'motor', 'other'] }
  validates :policy_id, presence: true, numericality: { greater_than: 0 }
  validates :payout_to, presence: true, inclusion: { in: ['agent', 'distributor', 'sub_agent'] }
  validates :payout_amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: ['pending', 'paid', 'cancelled'] }

  scope :paid, -> { where(status: 'paid') }
  scope :pending, -> { where(status: 'pending') }
  scope :for_policy_type, ->(type) { where(policy_type: type) }
  scope :for_payout_to, ->(recipient) { where(payout_to: recipient) }

  def policy
    case policy_type
    when 'health'
      HealthInsurance.find_by(id: policy_id)
    when 'life'
      LifeInsurance.find_by(id: policy_id)
    when 'motor'
      MotorInsurance.find_by(id: policy_id)
    when 'other'
      OtherInsurance.find_by(id: policy_id)
    end
  end
end
