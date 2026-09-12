# Minimal Razorpay Orders API client - just enough to create an order and
# verify the checkout signature for the ambassador KYC payment step. Talks to
# the REST API directly (Basic Auth with key_id:key_secret) so we don't need
# to add the `razorpay` gem for two calls.
class RazorpayService
  class Error < StandardError; end

  API_BASE = "https://api.razorpay.com/v1".freeze

  # amount_rupees: BigDecimal/Numeric rupee amount (Razorpay wants paise).
  # Returns the parsed JSON order (includes "id", "amount", "currency").
  def self.create_order(amount_rupees:, receipt:)
    uri = URI("#{API_BASE}/orders")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(RAZORPAY_CONFIG[:key_id], RAZORPAY_CONFIG[:key_secret])
    request["Content-Type"] = "application/json"
    request.body = {
      amount: (amount_rupees.to_d * 100).to_i,
      currency: "INR",
      receipt: receipt,
      payment_capture: 1
    }.to_json

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(request) }
    body = JSON.parse(response.body)
    raise Error, body.dig("error", "description") || "Could not create Razorpay order" unless response.is_a?(Net::HTTPSuccess)

    body
  end

  # Verifies the signature Razorpay Checkout returns on successful payment.
  def self.verify_signature(order_id:, payment_id:, signature:)
    expected = OpenSSL::HMAC.hexdigest("SHA256", RAZORPAY_CONFIG[:key_secret], "#{order_id}|#{payment_id}")
    ActiveSupport::SecurityUtils.secure_compare(expected, signature.to_s)
  end
end
