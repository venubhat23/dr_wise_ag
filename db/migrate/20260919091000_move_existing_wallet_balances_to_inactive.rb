# One-time backfill for the active/inactive wallet split: every existing
# balance is moved into the inactive wallet, EXCEPT for owners who have already
# done business (they have already met the unlock rule, so their money stays
# active):
#   * affiliate  - has created at least one policy
#   * ambassador - at least one of their affiliates has created a policy
class MoveExistingWalletBalancesToInactive < ActiveRecord::Migration[8.0]
  class MWallet < ActiveRecord::Base
    self.table_name = 'wallets'
  end

  class MHold < ActiveRecord::Base
    self.table_name = 'wallet_holds'
  end

  class MTxn < ActiveRecord::Base
    self.table_name = 'wallet_transactions'
  end

  POLICY_TABLES = %w[health_insurances life_insurances motor_insurances other_insurances].freeze

  def up
    MWallet.where('balance > 0').find_each do |wallet|
      affiliate_ids = trigger_affiliate_ids(wallet)
      next if affiliate_ids.any? && any_policy?(affiliate_ids)

      amount = wallet.balance
      MHold.create!(
        wallet_id: wallet.id,
        amount: amount,
        kind: 'legacy_balance',
        description: 'Existing balance moved to inactive wallet',
        trigger_sub_agent_id: wallet.owner_type == 'SubAgent' ? wallet.owner_id : nil,
        status: 'locked'
      )
      MTxn.create!(
        wallet_id: wallet.id,
        txn_type: 'debit',
        amount: amount,
        balance_after: 0,
        description: 'Moved to inactive wallet (unlocks after first policy)',
        performed_by: 'system'
      )
      wallet.update_columns(balance: 0, updated_at: Time.current)
    end
  end

  def down
    MHold.where(kind: 'legacy_balance', status: 'locked').find_each do |hold|
      wallet = MWallet.find(hold.wallet_id)
      wallet.update_columns(balance: wallet.balance + hold.amount)
      hold.destroy
    end
  end

  private

  # Affiliates whose business unlocks this wallet.
  def trigger_affiliate_ids(wallet)
    if wallet.owner_type == 'SubAgent'
      [wallet.owner_id]
    else
      direct   = select_ids("SELECT id FROM sub_agents WHERE distributor_id = #{wallet.owner_id.to_i}")
      assigned = select_ids("SELECT sub_agent_id FROM distributor_assignments WHERE distributor_id = #{wallet.owner_id.to_i}")
      (direct + assigned).uniq
    end
  end

  def select_ids(sql)
    connection.select_values(sql).map(&:to_i)
  end

  def any_policy?(affiliate_ids)
    list = affiliate_ids.map(&:to_i).join(',')
    POLICY_TABLES.any? do |table|
      connection.select_value("SELECT 1 FROM #{table} WHERE sub_agent_id IN (#{list}) LIMIT 1").present?
    end
  end
end
