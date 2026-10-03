# One-off move of affiliate or ambassador commission (CommissionPayout rows)
# into wallets.
#
# Per owner, using the after-TDS amount from the policy commission table:
#   * credit  = all earned commission (paid + pending + processing)
#   * debit   = the part already paid outside the wallet
# so the ACTIVE balance grows by exactly the unpaid commission, and the ledger
# shows both "earned" and "already paid".
#
# Unpaid payouts are then marked paid (payment_mode 'wallet') so the old payout
# flow can't pay them a second time. Every migrated payout gets MARKER in its
# notes, which makes re-running safe - already-migrated rows are skipped.
class CommissionWalletMigration
  MARKER = CommissionWalletCredit::MARKER
  POLICY_CLASSES = { 'health' => HealthInsurance, 'life' => LifeInsurance,
                     'motor' => MotorInsurance,   'other' => OtherInsurance }.freeze

  Row = Struct.new(:owner, :earned, :already_paid, :unpaid, :payouts, keyword_init: true)

  # role: :affiliate or :ambassador; owner_id limits it to one SubAgent / Distributor.
  def initialize(role:, dry_run: true, owner_id: nil, logger: $stdout)
    @role = role.to_sym
    @dry_run = dry_run
    @owner_id = owner_id
    @logger = logger
  end

  def call
    rows = build_rows
    rows.each { |row| migrate!(row) unless @dry_run }
    report(rows)
    rows
  end

  private

  def build_rows
    payouts = CommissionPayout.where(payout_to: CommissionWalletCredit::ROLES.fetch(@role)[:payout_to],
                                     status: %w[paid pending processing])
                              .where("notes IS NULL OR notes NOT LIKE ?", "%#{MARKER}%")
                              .to_a

    policies = {}
    payouts.group_by(&:policy_type).each do |ptype, ps|
      klass = POLICY_CLASSES[ptype] or next
      policies[ptype] = klass.where(id: ps.map(&:policy_id).uniq).index_by(&:id)
    end

    by_owner = Hash.new { |h, k| h[k] = [] }
    owners = {}
    payouts.each do |payout|
      pol = policies.dig(payout.policy_type, payout.policy_id)
      owner = owner_for(pol) or next
      next if @owner_id && owner.id != @owner_id

      owners[owner.id] = owner
      by_owner[owner.id] << [payout, CommissionWalletCredit.net_amount(@role, payout, pol)]
    end

    by_owner.map do |owner_id, items|
      paid   = items.select { |p, _| p.paid? }.sum { |_, net| net }.round(2)
      unpaid = items.reject { |p, _| p.paid? }.sum { |_, net| net }.round(2)
      Row.new(owner: owners[owner_id], earned: (paid + unpaid).round(2), already_paid: paid,
              unpaid: unpaid, payouts: items.map(&:first))
    end.sort_by { |r| r.owner.id }
  end

  # Memoised CommissionWalletCredit.owner_for - policies share owners.
  def owner_for(pol)
    return nil unless pol

    @owner_cache ||= {}
    key = [pol.try(:sub_agent_id), pol.try(:distributor_id)]
    return @owner_cache[key] if @owner_cache.key?(key)

    @owner_cache[key] = CommissionWalletCredit.owner_for(@role, pol)
  end

  def migrate!(row)
    return if row.earned <= 0

    ActiveRecord::Base.transaction do
      wallet = row.owner.wallet!
      n = row.payouts.size
      wallet.credit!(row.earned, description: "Commission earned (#{n} #{'policy'.pluralize(n)}, after TDS) - migrated",
                                 performed_by: 'commission_migration')
      if row.already_paid > 0
        wallet.debit!(row.already_paid, description: 'Commission already paid before wallet migration',
                                        performed_by: 'commission_migration')
      end

      now = Time.current
      row.payouts.each do |payout|
        attrs = { notes: CommissionWalletCredit.marked_notes(payout.notes, now.to_date) }
        unless payout.paid?
          attrs.merge!(status: 'paid', payment_mode: 'wallet', processed_by: 'commission_migration',
                       processed_at: now, payout_date: payout.payout_date || now.to_date)
        end
        payout.update_columns(attrs.merge(updated_at: now))
      end
    end
  end

  def report(rows)
    label = @role.to_s.titleize
    @logger.puts(@dry_run ? "== DRY RUN #{label} (nothing written) ==" : "== MIGRATED #{label} ==")
    @logger.puts format('%-6s %-30s %12s %12s %14s', 'ID', label, 'Earned', 'Paid', 'To wallet')
    rows.each do |r|
      name = r.owner.try(:display_name).presence || r.owner.try(:full_name).presence ||
             r.owner.try(:name).presence || r.owner.email
      @logger.puts format('%-6d %-30s %12.2f %12.2f %14.2f', r.owner.id, name.to_s[0, 30],
                          r.earned, r.already_paid, r.unpaid)
    end
    @logger.puts format('%-37s %12.2f %12.2f %14.2f', "TOTAL (#{rows.size} #{label.pluralize.downcase})",
                        rows.sum(&:earned), rows.sum(&:already_paid), rows.sum(&:unpaid))
  end
end
