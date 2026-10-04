class CreateInvestorYearlyPayouts < ActiveRecord::Migration[8.0]
  # One row per investor per financial year (Apr–Mar) that admin has marked
  # paid from the investor page's Yearly revenue breakup. Amount / shares /
  # per-share are snapshotted at pay time.
  def change
    create_table :investor_yearly_payouts do |t|
      t.references :investor, null: false, foreign_key: true
      t.integer  :financial_year, null: false # FY start year, e.g. 2025 = FY 2025-26
      t.decimal  :amount, precision: 12, scale: 2, null: false, default: 0
      t.integer  :shares, null: false, default: 0
      t.decimal  :per_share, precision: 14, scale: 4, null: false, default: 0
      t.datetime :paid_at, null: false
      t.references :paid_by, foreign_key: { to_table: :users }
      t.timestamps
    end
    add_index :investor_yearly_payouts, [:investor_id, :financial_year], unique: true
  end
end
