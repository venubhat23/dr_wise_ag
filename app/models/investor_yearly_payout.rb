# An investor's share for one financial year (Apr–Mar), marked paid by admin
# from the Yearly revenue breakup. See InvestorRevenueBreakupService.
class InvestorYearlyPayout < ApplicationRecord
  belongs_to :investor
  belongs_to :paid_by, class_name: 'User', optional: true

  validates :financial_year, presence: true, uniqueness: { scope: :investor_id, message: 'is already marked paid for this investor' }
  validates :amount, numericality: { greater_than: 0 }
  validates :paid_at, presence: true

  def fy_label
    "FY #{financial_year}-#{(financial_year + 1).to_s.last(2)}"
  end
end
