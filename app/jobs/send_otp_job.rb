class SendOtpJob < ApplicationJob
  queue_as :default
  retry_on OtpSenderService::DeliveryError, wait: 5.seconds, attempts: 3

  def perform(identifier:, identifier_type:, otp:)
    OtpSenderService.deliver(identifier: identifier, identifier_type: identifier_type, otp: otp)
  end
end
