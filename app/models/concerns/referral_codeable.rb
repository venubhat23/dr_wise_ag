# Gives a model a unique, human-shareable referral code (e.g. "AMB123456",
# "AFF987654"). The prefix is declared per-model with `referral_code_prefix`.
module ReferralCodeable
  extend ActiveSupport::Concern

  included do
    before_create :ensure_referral_code
  end

  class_methods do
    # Declares/reads the code prefix for this model.
    def referral_code_prefix(value = nil)
      @referral_code_prefix = value if value
      @referral_code_prefix || 'REF'
    end

    # Case-insensitive lookup by referral code. Returns nil for blank input.
    def find_by_referral_code(code)
      normalized = code.to_s.strip
      return nil if normalized.blank?

      where('UPPER(referral_code) = ?', normalized.upcase).first
    end
  end

  def ensure_referral_code
    return if referral_code.present?

    self.referral_code = generate_referral_code
  end

  private

  def generate_referral_code
    prefix = self.class.referral_code_prefix
    10.times do
      candidate = "#{prefix}#{SecureRandom.random_number(100_000..999_999)}"
      return candidate unless self.class.exists?(referral_code: candidate)
    end
    "#{prefix}#{SecureRandom.hex(4).upcase}"
  end
end
