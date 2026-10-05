# Company share of a policy's commission. Health/Motor used to shadow the
# company_expenses_amount column with an attr_accessor, so it was never saved
# (and Life has no column at all) — the view page then showed Rs. 0.00 while the
# edit page recomputed it in JS. Fall back to the same formula the edit form uses.
module CompanyExpensesAmount
  extend ActiveSupport::Concern

  def company_expenses_amount
    stored = has_attribute?(:company_expenses_amount) ? self[:company_expenses_amount] : nil
    return stored if stored.to_f.positive?

    (net_premium.to_f * company_expenses_percentage.to_f / 100.0).round(2)
  end
end
