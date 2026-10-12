# Wipes an affiliate's wallet (ledger + locked amounts) and rebuilds it as a
# per-policy history, oldest first:
#
#   1. Welcome bonus           -> INACTIVE wallet (locked hold)
#   2. First commission arrives -> bonus unlocked into the ACTIVE wallet
#   3. Per commission payout:   credit  "Commission earned" (gross commission amount)
#                               debit   "Commission paid"   (only when the payout is paid)
#
# So the active balance ends at bonus + unpaid commission. Affiliates with
# withdrawal requests are skipped - their withdrawals point at ledger rows.
class AffiliateWalletRebuild
  BONUS = BigDecimal('10')
  PERFORMED_BY = 'wallet_rebuild'.freeze
  MARKER = CommissionWalletCredit::MARKER
  POLICY_CLASSES = CommissionWalletMigration::POLICY_CLASSES

  # One wallet row to write, at `at`.
  Entry = Struct.new(:at, :kind, :amount, :description, :payout, keyword_init: true)
  Plan = Struct.new(:sub_agent, :entries, :skip_reason, keyword_init: true) do
    def active_end
      entries.sum(BigDecimal(0)) do |e|
        case e.kind
        when :credit, :unlock then e.amount
        when :debit then -e.amount
        else 0
        end
      end
    end

    def inactive_end
      first = entries.find { |e| e.kind == :bonus }
      first && entries.none? { |e| e.kind == :unlock } ? first.amount : 0
    end
  end

  def initialize(dry_run: true, sub_agent_id: nil, logger: $stdout)
    @dry_run = dry_run
    @sub_agent_id = sub_agent_id
    @logger = logger
  end

  def call
    scope = SubAgent.order(:id)
    scope = scope.where(id: @sub_agent_id) if @sub_agent_id
    plans = scope.map { |sa| build_plan(sa) }
    plans.each { |plan| apply!(plan) unless @dry_run || plan.skip_reason }
    report(plans)
    plans
  end

  private

  def build_plan(sub_agent)
    if WithdrawalRequest.exists?(owner_type: 'SubAgent', owner_id: sub_agent.id)
      return Plan.new(sub_agent: sub_agent, entries: [], skip_reason: 'has withdrawal requests')
    end

    commissions = payouts_for(sub_agent)
    # Never after the first commission - the bonus has to exist before it can unlock.
    bonus_at = [sub_agent.kyc_reviewed_at || sub_agent.created_at, commissions.first&.last].compact.min
    entries = [Entry.new(at: bonus_at, kind: :bonus, amount: BONUS, description: 'Welcome bonus')]

    commissions.each_with_index do |(payout, pol, at), i|
      label = "#{payout.policy_type.titleize} policy #{pol.try(:policy_number).presence || "##{pol.id}"}"
      gross = gross_amount(payout, pol)
      next if gross <= 0

      if i.zero?
        entries << Entry.new(at: at, kind: :unlock, amount: BONUS, description: 'Unlocked: Welcome bonus (first commission)')
      end
      entries << Entry.new(at: at, kind: :credit, amount: gross, payout: payout,
                           description: "Commission earned: #{label}")
      next unless payout.paid?

      entries << Entry.new(at: at, kind: :debit, amount: gross, payout: payout,
                           description: "Commission paid: #{label}#{paid_ref(payout)}")
    end

    Plan.new(sub_agent: sub_agent, entries: entries)
  end

  # [payout, policy, date] for every affiliate payout on this affiliate's policies, oldest first.
  def payouts_for(sub_agent)
    POLICY_CLASSES.flat_map do |ptype, klass|
      policies = klass.where(sub_agent_id: sub_agent.id).index_by(&:id)
      next [] if policies.empty?

      CommissionPayout.where(policy_type: ptype, policy_id: policies.keys,
                             payout_to: CommissionWalletCredit::ROLES[:affiliate][:payout_to],
                             status: %w[paid pending processing])
                      .map do |p|
        date = p.payout_date&.in_time_zone&.change(hour: 12) || p.created_at
        [p, policies[p.policy_id], date]
      end
    end.sort_by { |p, _, at| [at, p.id] }
  end

  # Commission amount column of the policy commission table (before TDS).
  def gross_amount(payout, pol)
    gross = pol.try(:sub_agent_commission_amount).to_d
    gross = payout.payout_amount.to_d if gross.zero?
    gross.round(2)
  end

  def paid_ref(payout)
    ref = payout.transaction_id.presence unless payout.transaction_id.to_s.start_with?('WALLET-TXN-')
    ref ? " (ref #{ref})" : ''
  end

  def apply!(plan)
    ActiveRecord::Base.transaction do
      wallet = plan.sub_agent.wallet!
      wallet.lock!
      wallet.wallet_holds.delete_all
      wallet.wallet_transactions.delete_all
      wallet.update_columns(balance: 0, updated_at: Time.current)

      now = Time.current
      hold = nil
      plan.entries.each_with_index do |e, i|
        # Same-day rows keep their order; nothing is dated in the future.
        at = [e.at, now].min + i.seconds
        case e.kind
        when :bonus
          hold = wallet.wallet_holds.create!(amount: e.amount, kind: 'signup_bonus', description: e.description,
                                             trigger_sub_agent: plan.sub_agent, created_at: at, updated_at: at)
        when :unlock
          txn = write!(wallet, 'credit', e, at)
          hold.update_columns(status: 'released', released_at: at, wallet_transaction_id: txn.id, updated_at: at)
        when :credit
          write!(wallet, 'credit', e, at)
        when :debit
          txn = write!(wallet, 'debit', e, at)
          mark_payout!(e.payout, txn)
        end
      end
      plan.sub_agent.update_columns(referral_bonus_credited_at: plan.entries.first.at)
    end
  end

  def write!(wallet, txn_type, entry, at)
    wallet.reload
    new_balance = txn_type == 'credit' ? wallet.balance + entry.amount : wallet.balance - entry.amount
    wallet.update_columns(balance: new_balance, updated_at: Time.current)
    wallet.wallet_transactions.create!(txn_type: txn_type, amount: entry.amount, balance_after: new_balance,
                                       description: entry.description, performed_by: PERFORMED_BY,
                                       created_at: at, updated_at: at)
  end

  # Keep the "never credit twice" marker, and repoint wallet-stamped payouts at the new debit row.
  def mark_payout!(payout, txn)
    attrs = {}
    attrs[:notes] = CommissionWalletCredit.marked_notes(payout.notes) unless payout.notes.to_s.include?(MARKER)
    attrs[:transaction_id] = "WALLET-TXN-#{txn.id}" if payout.transaction_id.blank? || payout.transaction_id.start_with?('WALLET-TXN-')
    payout.update_columns(attrs.merge(updated_at: Time.current)) if attrs.any?
  end

  def report(plans)
    @logger.puts(@dry_run ? '== DRY RUN affiliate wallet rebuild (nothing written) ==' : '== REBUILT affiliate wallets ==')
    plans.each do |plan|
      sa = plan.sub_agent
      if plan.skip_reason
        @logger.puts "SA#{sa.id} #{sa.display_name} - SKIPPED (#{plan.skip_reason})"
        next
      end
      @logger.puts format('SA%-4d %-28s active %10.2f  inactive %7.2f', sa.id, sa.display_name.to_s[0, 28],
                          plan.active_end, plan.inactive_end)
      plan.entries.each do |e|
        sign = { bonus: 'LOCK  ', unlock: 'UNLOCK', credit: 'CREDIT', debit: 'DEBIT ' }[e.kind]
        @logger.puts format('        %s %s %10.2f  %s', e.at.to_date, sign, e.amount, e.description)
      end
    end
  end
end
