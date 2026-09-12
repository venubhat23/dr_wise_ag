# Razorpay Checkout configuration for the ambassador KYC registration-fee
# payment step. Same "credentials with a fallback" pattern as cloudflare_r2.rb.
RAZORPAY_CONFIG = {
  key_id: Rails.application.credentials.dig(:razorpay, :key_id) || "rzp_test_Tb0F8rgwRPsFzV",
  key_secret: Rails.application.credentials.dig(:razorpay, :key_secret) || "6aMUehrgq50ccDyO8CQUlyOK"
}.freeze
