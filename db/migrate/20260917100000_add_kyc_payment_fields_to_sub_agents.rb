class AddKycPaymentFieldsToSubAgents < ActiveRecord::Migration[8.0]
  # Registration-fee payment step for affiliates, mirroring Distributor's
  # ambassador registration-fee payment (SystemSetting.affiliate_registration_fee),
  # collected via Razorpay from the mobile app after KYC submission.
  #
  # self_registered distinguishes affiliates who signed up themselves via the
  # mobile app (POST /api/v1/mobile/auth/register) from ones created directly
  # by an admin - only the former are ever required to pay.
  def change
    add_column :sub_agents, :self_registered, :boolean, default: false, null: false
    add_column :sub_agents, :payment_amount, :decimal, precision: 10, scale: 2
    add_column :sub_agents, :payment_paid, :boolean, default: false, null: false
    add_column :sub_agents, :payment_paid_at, :datetime
    add_column :sub_agents, :razorpay_order_id, :string
    add_column :sub_agents, :razorpay_payment_id, :string
  end
end
