class OtpVerification < ApplicationRecord
  OTP_LENGTH = 6
  EXPIRY = 3.minutes
  MAX_ATTEMPTS = 5
  RESEND_COOLDOWN = 30.seconds

  validates :identifier, :identifier_type, :purpose, :otp_digest, :expires_at, presence: true

  scope :active, -> { where(verified_at: nil).where("expires_at > ?", Time.current) }

  def self.generate!(identifier:, identifier_type:, purpose: "login")
    otp = SecureRandom.random_number(10**OTP_LENGTH).to_s.rjust(OTP_LENGTH, "0")

    record = active.where(identifier: identifier, purpose: purpose).order(created_at: :desc).first
    if record && record.created_at > RESEND_COOLDOWN.ago
      return [ nil, record, record.created_at + RESEND_COOLDOWN ]
    end

    record = create!(
      identifier: identifier,
      identifier_type: identifier_type,
      purpose: purpose,
      otp_digest: digest(otp),
      expires_at: EXPIRY.from_now
    )

    [ otp, record, nil ]
  end

  def self.verify!(identifier:, otp:, purpose: "login")
    record = active.where(identifier: identifier, purpose: purpose).order(created_at: :desc).first
    return :not_found unless record

    if record.attempts >= MAX_ATTEMPTS
      return :too_many_attempts
    end

    record.increment!(:attempts)

    if record.otp_digest == digest(otp.to_s)
      record.update!(verified_at: Time.current)
      :verified
    else
      :invalid
    end
  end

  def self.digest(otp)
    Digest::SHA256.hexdigest("#{otp}:#{Rails.application.secret_key_base}")
  end
end
