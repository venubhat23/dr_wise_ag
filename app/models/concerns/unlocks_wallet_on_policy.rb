# Included by every policy model that carries a sub_agent_id. The first policy
# an affiliate creates unlocks their inactive wallet money (and the ambassador
# money that depends on them) - see WalletUnlockService.
module UnlocksWalletOnPolicy
  extend ActiveSupport::Concern

  included do
    after_commit :unlock_wallet_holds, on: %i[create update]
  end

  private

  def unlock_wallet_holds
    return if sub_agent_id.blank?
    return unless saved_change_to_id? || saved_change_to_sub_agent_id?

    WalletUnlockService.policy_created!(sub_agent)
  rescue => e
    # Never let a wallet problem break policy creation.
    Rails.logger.error "[WalletUnlock] #{self.class.name}##{id}: #{e.message}"
  end
end
