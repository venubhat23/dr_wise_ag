class AddPayoutYearsToInvestors < ActiveRecord::Migration[8.0]
  # Financial years (FY start year, e.g. 2024 = FY 2024-25) admin has added to
  # an investor's Yearly Payments table, so old/future years can be tracked
  # even before they are paid. Paid years live in investor_yearly_payouts.
  def change
    add_column :investors, :payout_years, :integer, array: true, default: [], null: false
  end
end
