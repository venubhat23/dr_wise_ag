# Referral-program rules for affiliate (SubAgent) sign-up.
#
# Hierarchy is strictly two levels: AMBASSADOR -> AFFILIATE.
# A referral code (ambassador OR affiliate) only ever attributes the new
# affiliate to an Ambassador — it never nests one affiliate under another,
# and it never pays the referrer or the ambassador. Only the newly
# registered affiliate receives the one-time signup bonus.
class AffiliateReferralService
  SIGNUP_BONUS = BigDecimal('100')

  # Outcome of resolving a referral code.
  #   success  - false only when a code was supplied but is unusable
  #   ambassador - the Distributor the new affiliate must be mapped under (may be nil when no code given)
  #   referrer   - the referring SubAgent, when an affiliate code was used
  #   kind       - 'ambassador' | 'affiliate' | nil
  #   error      - user-facing message when success is false
  Resolution = Struct.new(:success, :ambassador, :referrer, :kind, :error, keyword_init: true) do
    def success?
      success
    end

    # Eligible for the signup bonus: a valid code that resolved to an Ambassador.
    def bonus_eligible?
      success? && ambassador.present?
    end
  end

  # Resolve a referral code WITHOUT creating anything.
  def self.resolve(code)
    normalized = code.to_s.strip
    return Resolution.new(success: true, kind: nil) if normalized.blank?

    if (ambassador = Distributor.find_by_referral_code(normalized))
      return Resolution.new(success: true, ambassador: ambassador, kind: 'ambassador')
    end

    if (referrer = SubAgent.find_by_referral_code(normalized))
      ambassador = referrer.ambassador
      unless ambassador
        return Resolution.new(
          success: false,
          error: 'This referral code cannot be used right now — the referring affiliate is not linked to an ambassador.'
        )
      end

      return Resolution.new(success: true, ambassador: ambassador, referrer: referrer, kind: 'affiliate')
    end

    Resolution.new(success: false, error: 'Invalid referral code.')
  end

  # Map a freshly-created affiliate under the resolved Ambassador.
  # Keeps the direct FK and the assignment join row in sync so both the
  # payout logic (distributor_id) and the admin UI (assignment) agree.
  def self.attribute!(sub_agent, resolution)
    return unless resolution.ambassador

    ambassador = resolution.ambassador
    sub_agent.update_columns(
      distributor_id: ambassador.id,
      referred_by_kind: resolution.kind
    )

    unless DistributorAssignment.exists?(sub_agent_id: sub_agent.id)
      DistributorAssignment.create!(distributor_id: ambassador.id, sub_agent_id: sub_agent.id, assigned_at: Time.current)
    end
  end

  # Credit the one-time signup bonus into the new affiliate's own wallet.
  # Idempotent: never credits twice.
  def self.credit_signup_bonus!(sub_agent, code:)
    return if sub_agent.referral_bonus_credited?

    sub_agent.wallet!.credit!(
      SIGNUP_BONUS,
      description: "Referral signup bonus#{" (code: #{code.to_s.strip.upcase})" if code.present?}",
      performed_by: 'referral_program'
    )
    sub_agent.update_columns(referral_bonus_credited_at: Time.current)
  end
end
