# Pays a single affiliate or ambassador CommissionPayout into the owner's
# ACTIVE wallet and sends them an in-app notification.
#
# Triggered by the admin "Pay" buttons on a policy's commission table
# (Admin::CommissionTrackingController - settle_distribution_payouts and
# transfer_to_ambassador). The credited amount is the after-TDS value shown in
# that table. The payout is marked paid with payment_mode 'wallet' and tagged
# with MARKER, so it is never credited twice.
class CommissionWalletCredit
  MARKER = '[migrated_to_wallet]'.freeze

  # payout_to values per role, and the policy column prefix holding the amounts.
  ROLES = {
    affiliate:  { payout_to: %w[sub_agent affiliate], prefix: 'sub_agent' },
    ambassador: { payout_to: %w[ambassador],          prefix: 'ambassador' }
  }.freeze

  def self.role_for(payout)
    ROLES.find { |_, cfg| cfg[:payout_to].include?(payout.payout_to) }&.first
  end

  def self.credited?(payout)
    payout.payment_mode == 'wallet' || payout.notes.to_s.include?(MARKER)
  end

  # Wallet owner: the policy's affiliate (SubAgent), or its ambassador
  # (Distributor) - the policy's own distributor_id, else the affiliate's.
  def self.owner_for(role, pol)
    return nil unless pol

    sub_agent = pol.try(:sub_agent_id) && SubAgent.find_by(id: pol.sub_agent_id)
    case role
    when :affiliate  then sub_agent
    when :ambassador then (pol.try(:distributor_id) && Distributor.find_by(id: pol.distributor_id)) || sub_agent&.ambassador
    end
  end

  # After-TDS amount, same fallbacks as the admin commission pages.
  def self.net_amount(role, payout, pol)
    prefix = ROLES.fetch(role)[:prefix]
    gross = pol.try(:"#{prefix}_commission_amount").to_f
    tds   = pol.try(:"#{prefix}_tds_amount").to_f
    net   = pol.try(:"#{prefix}_after_tds_value").to_f
    net   = (gross - tds).round(2) if net.zero? && gross > 0
    net   = payout.payout_amount.to_f if net.zero?
    net.to_d.round(2)
  end

  def self.marked_notes(notes, date = Date.current)
    [notes.presence, "#{MARKER} #{date}"].compact.join("\n")
  end

  # Returns the WalletTransaction, or nil when nothing was credited.
  def self.call(payout, paid_date: Date.current, performed_by: 'admin')
    new(payout, paid_date, performed_by).call
  end

  def initialize(payout, paid_date, performed_by)
    @payout = payout
    @paid_date = paid_date
    @performed_by = performed_by
  end

  def call
    owner = amount = pol = nil

    txn = ActiveRecord::Base.transaction do
      @payout.lock!
      role = self.class.role_for(@payout)
      next nil if role.nil? || self.class.credited?(@payout)

      pol = @payout.policy
      owner = self.class.owner_for(role, pol)
      next nil unless owner

      amount = self.class.net_amount(role, @payout, pol)
      next nil if amount <= 0

      t = owner.wallet!.credit!(
        amount,
        description: "Commission earned: #{@payout.policy_type.titleize} policy #{policy_label(pol)} (after TDS)",
        performed_by: @performed_by
      )
      @payout.update_columns(
        status: 'paid', payment_mode: 'wallet', payout_date: @paid_date, transaction_id: "WALLET-TXN-#{t.id}",
        processed_by: @performed_by, processed_at: Time.current,
        notes: self.class.marked_notes(@payout.notes, @paid_date), updated_at: Time.current
      )
      t
    end

    notify(owner, amount, pol) if txn
    txn
  end

  private

  # Ambassadors use the app as their `User` login (matched by email), so the
  # notification goes there; affiliates are the SubAgent itself.
  def notify(owner, amount, pol)
    recipient = owner.is_a?(Distributor) ? (User.find_by(email: owner.email) || owner) : owner
    Notification.notify(
      recipient, 'commission_credited', 'Commission credited to your wallet',
      "Rs. #{format('%.2f', amount)} commission for #{@payout.policy_type.titleize} policy #{policy_label(pol)} " \
      'has been added to your wallet.',
      pol
    )
  end

  def policy_label(pol)
    pol.try(:policy_number).presence || "##{pol.id}"
  end
end
