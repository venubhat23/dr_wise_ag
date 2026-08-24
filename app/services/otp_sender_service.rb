require "net/http"

# Delivers an OTP to a mobile number or an email address (via ActionMailer).
#
# SMS delivery goes through 2Factor.in (https://2factor.in), using the
# DLT-approved OTP template already set up on the 2Factor account.
class OtpSenderService
  class DeliveryError < StandardError; end

  TWOFACTOR_BASE_URL = "https://2factor.in/API/V1"
  TWOFACTOR_API_KEY = "fb821f89-f745-11f0-a6b2-0200cd936042"
  TWOFACTOR_OTP_TEMPLATE = "LoginOTP"

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
    deliver_via_twofactor
  end

  # https://2factor.in/API/V1/{api_key}/SMS/{phone_number}/{otp}/{template_name}
  # Sends our own locally-generated OTP through 2Factor's approved template
  # (rather than their AUTOGEN endpoint) so it matches the OTP already stored
  # in OtpVerification and verified locally.
  def deliver_via_twofactor
    phone = twofactor_phone_number

    path = [ TWOFACTOR_BASE_URL, TWOFACTOR_API_KEY, "SMS", phone, otp, ERB::Util.url_encode(TWOFACTOR_OTP_TEMPLATE) ].join("/")
    uri = URI.parse(path)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 5
    http.read_timeout = 5

    response = http.get(uri.request_uri)
    body = begin
      JSON.parse(response.body)
    rescue JSON::ParserError
      {}
    end

    unless response.is_a?(Net::HTTPSuccess) && body["Status"] == "Success"
      Rails.logger.error("OTP SMS delivery failed (2Factor) for #{identifier}: #{response.code} #{response.body}")
      raise DeliveryError, body["Details"].presence || "2Factor responded with #{response.code}"
    end

    true
  rescue DeliveryError
    raise
  rescue => e
    Rails.logger.error("OTP SMS delivery error (2Factor) for #{identifier}: #{e.message}")
    raise DeliveryError, e.message
  end

  # 2Factor expects a bare 10-digit Indian mobile number (it assumes +91).
  def twofactor_phone_number
    digits = identifier.to_s.gsub(/\D/, "")
    digits = digits[2..] if digits.length == 12 && digits.start_with?("91")
    digits
  end
end
