class SendOtpJob < ApplicationJob
  queue_as :default
  retry_on OtpSenderService::DeliveryError, wait: 5.seconds, attempts: 3

  def perform(identifier:, identifier_type:, otp:, purpose: "login")
    OtpSenderService.deliver(identifier: identifier, identifier_type: identifier_type, otp: otp, purpose: purpose)
  end
end
