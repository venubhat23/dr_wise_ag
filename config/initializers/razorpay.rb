# Razorpay Checkout configuration for the ambassador KYC registration-fee
# payment step. Same "credentials with a fallback" pattern as cloudflare_r2.rb.
RAZORPAY_CONFIG = {
  key_id: Rails.application.credentials.dig(:razorpay, :key_id) || "rzp_live_TczAzpajz1IvPu",
  key_secret: Rails.application.credentials.dig(:razorpay, :key_secret) || "Gf5C41HeZfkp5mjwbyGfReTA"
}.freeze
