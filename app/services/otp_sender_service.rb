require "net/http"

# Delivers an OTP to a mobile number (via a generic HTTP SMS provider,
# configured through ENV so any gateway - MSG91, Twilio, Fast2SMS, etc. -
# can be plugged in later) or an email address (via ActionMailer).
#
# Until OTP_SMS_PROVIDER_URL / OTP_SMS_API_KEY are configured, SMS delivery
# just logs the OTP so mobile login can be developed/tested end to end.
class OtpSenderService
  class DeliveryError < StandardError; end

  def self.deliver(identifier:, identifier_type:, otp:)
    new(identifier, identifier_type, otp).deliver
  end

  def initialize(identifier, identifier_type, otp)
    @identifier = identifier
    @identifier_type = identifier_type
    @otp = otp
  end

  def deliver
    identifier_type == "email" ? deliver_email : deliver_sms
  end

  private

  attr_reader :identifier, :identifier_type, :otp

  def deliver_email
    OtpMailer.otp_code(identifier, otp).deliver_now
  rescue => e
    Rails.logger.error("OTP email delivery failed for #{identifier}: #{e.message}")
    raise DeliveryError, e.message
  end

  def deliver_sms
    provider_url = ENV["OTP_SMS_PROVIDER_URL"]
    api_key = ENV["OTP_SMS_API_KEY"]

    unless provider_url.present? && api_key.present?
      Rails.logger.info("[OTP] SMS provider not configured - OTP for #{identifier} is #{otp}")
      return true
    end

    uri = URI.parse(provider_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"
    http.open_timeout = 5
    http.read_timeout = 5

    request = Net::HTTP::Post.new(uri.request_uri)
    request["Authorization"] = "Bearer #{api_key}"
    request["Content-Type"] = "application/json"
    request.body = {
      to: identifier,
      message: "Your InsureBook login OTP is #{otp}. It expires in #{OtpVerification::EXPIRY.to_i / 60} minutes."
    }.to_json

    response = http.request(request)

    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.error("OTP SMS delivery failed for #{identifier}: #{response.code} #{response.body}")
      raise DeliveryError, "SMS provider responded with #{response.code}"
    end

    true
  rescue DeliveryError
    raise
  rescue => e
    Rails.logger.error("OTP SMS delivery error for #{identifier}: #{e.message}")
    raise DeliveryError, e.message
  end
end
