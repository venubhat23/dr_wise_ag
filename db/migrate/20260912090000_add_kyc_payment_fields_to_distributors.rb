class AddKycPaymentFieldsToDistributors < ActiveRecord::Migration[8.0]
  # Registration-fee payment step, shown right after an ambassador submits
  # their KYC (SystemSetting.ambassador_registration_fee), collected via
  # Razorpay before the account can be used.
  def change
    add_column :distributors, :payment_amount, :decimal, precision: 10, scale: 2
    add_column :distributors, :payment_paid, :boolean, default: false, null: false
    add_column :distributors, :payment_paid_at, :datetime
    add_column :distributors, :razorpay_order_id, :string
    add_column :distributors, :razorpay_payment_id, :string
  end
end
