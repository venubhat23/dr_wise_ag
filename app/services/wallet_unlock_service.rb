# Decides when locked (inactive) wallet money becomes withdrawable.
#
# Rule: locked money unlocks once the affiliate it depends on has done real
# business, i.e. created at least one policy (Health / Life / Motor / Other).
#   * a hold tied to an affiliate (trigger_sub_agent_id)  -> that affiliate's first policy
#   * a hold with no affiliate on an ambassador's wallet   -> first policy of ANY of their affiliates
module WalletUnlockService
  POLICY_MODELS = %w[HealthInsurance LifeInsurance MotorInsurance OtherInsurance].freeze

  # Called after an affiliate's policy is saved.
  def self.policy_created!(sub_agent)
    return if sub_agent.blank?

    holds = WalletHold.locked.where(trigger_sub_agent_id: sub_agent.id)
    ambassador_wallet_id = sub_agent.ambassador&.wallet&.id
    if ambassador_wallet_id
      holds = holds.or(WalletHold.locked.where(trigger_sub_agent_id: nil, wallet_id: ambassador_wallet_id))
    end

    holds.includes(:wallet).find_each { |hold| release_if_qualified!(hold) }
  end

  # Releases the hold if its unlock rule is met. Returns true when released.
  def self.release_if_qualified!(hold)
    return false unless hold.locked? && qualified?(hold)

    hold.wallet.release_hold!(hold).present?
  end

  def self.qualified?(hold)
    ids = affiliate_ids_for(hold)
    ids.any? && any_policy?(ids)
  end

  def self.affiliate_ids_for(hold)
    return [hold.trigger_sub_agent_id] if hold.trigger_sub_agent_id

    owner = hold.wallet.owner
    return [] unless owner.is_a?(Distributor)

    (owner.sub_agents.pluck(:id) + owner.assigned_sub_agents.pluck(:id)).uniq
  end

  def self.any_policy?(sub_agent_ids)
    POLICY_MODELS.any? { |name| name.constantize.exists?(sub_agent_id: sub_agent_ids) }
  end
end
