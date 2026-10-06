## Shared behaviour for the Affiliate / Ambassador wallet admin screens.
#
# The including controller must implement:
#   owner_class          -> the AR model (SubAgent / Distributor)
#   owner_scope          -> base relation to list
#   owner_noun           -> label, e.g. "Affiliate"
#   owner_icon           -> bootstrap icon class for headers
#   wallet_index_path    -> path to the listing page
#   wallet_entity_path(owner)      -> path to a single wallet
#   wallet_add_funds_path(owner)   -> POST path to add funds
#   wallet_remove_funds_path(owner)-> POST path to remove funds
module WalletManagement
  extend ActiveSupport::Concern

  included do
    include ConfigurablePagination
    before_action :set_owner, only: [:show, :add_funds, :remove_funds, :set_balance,
                                     :update_transaction, :destroy_transaction, :update_hold, :unlock_hold]
    before_action :build_wallet_config
  end

  def index
    scope = owner_scope

    if params[:search].to_s.strip.length >= 3
      scope = scope.search_by_name_mobile_email(params[:search].strip)
    end

    case params[:status]
    when 'active'   then scope = scope.active
    when 'inactive' then scope = scope.inactive
    end

    @total_filtered_count = scope.count
    @owners = paginate_records(scope.order(created_at: :desc), @total_filtered_count)

    @wallets_by_owner = Wallet
                        .where(owner_type: owner_class.name, owner_id: @owners.map(&:id))
                        .index_by(&:owner_id)

    wallet_ids = @wallets_by_owner.values.map(&:id)
    @inactive_by_wallet = WalletHold.locked.where(wallet_id: wallet_ids).group(:wallet_id).sum(:amount)

    totals = Wallet.where(owner_type: owner_class.name)
    @total_wallets     = totals.count
    @total_balance     = totals.sum(:balance)
    @total_inactive_balance = WalletHold.locked.where(wallet_id: totals.select(:id)).sum(:amount)
    @wallets_with_funds = totals.where('balance > 0').count
  end

  def show
    @wallet = @owner.wallet!
    @transactions = paginate_records(@wallet.wallet_transactions.recent_first)
    @locked_holds = @wallet.wallet_holds.locked.includes(:trigger_sub_agent).recent_first.to_a
    @inactive_balance = @locked_holds.sum(&:amount)

    # Entries another record points at: editing the amount updates that
    # record too; they can't be deleted. Three queries for the whole page.
    txn_ids = @transactions.map(&:id)
    payout_refs = CommissionPayout.where(transaction_id: txn_ids.map { |i| "WALLET-TXN-#{i}" }).pluck(:transaction_id)
    @linked_txn_reasons = WithdrawalRequest.where(wallet_transaction_id: txn_ids).pluck(:wallet_transaction_id).index_with { 'withdrawal request' }
                                           .merge(WalletHold.where(wallet_transaction_id: txn_ids).pluck(:wallet_transaction_id).index_with { 'unlocked amount' })
                                           .merge(payout_refs.to_h { |ref| [ref.delete_prefix('WALLET-TXN-').to_i, 'policy commission payout'] })
  end

  def add_funds
    apply_wallet_change(:credit)
  end

  def remove_funds
    apply_wallet_change(:debit)
  end

  # Admin corrections. The mobile wallet APIs read these same rows, so the
  # app shows the change on its next load.

  def set_balance
    wallet_action do |wallet|
      wallet.set_balance!(parse_amount(params[:balance]), description: params[:description].to_s.strip, performed_by: current_user&.email)
      "Active balance set to #{helpers.indian_currency(wallet.reload.balance)}."
    end
  end

  def update_transaction
    wallet_action do |wallet|
      txn = wallet.wallet_transactions.find(params[:txn_id])
      wallet.edit_transaction!(txn, amount: params[:amount].presence && parse_amount(params[:amount]),
                                    description: params[:description].to_s.strip, performed_by: current_user&.email)
      'Transaction updated and balances recalculated.'
    end
  end

  def destroy_transaction
    wallet_action do |wallet|
      wallet.delete_transaction!(wallet.wallet_transactions.find(params[:txn_id]))
      'Transaction deleted and balances recalculated.'
    end
  end

  def update_hold
    wallet_action do |wallet|
      hold = wallet.wallet_holds.find(params[:hold_id])
      wallet.edit_hold!(hold, amount: params[:amount].presence && parse_amount(params[:amount]), description: params[:description].to_s.strip)
      'Locked amount updated.'
    end
  end

  def unlock_hold
    wallet_action do |wallet|
      hold = wallet.wallet_holds.find(params[:hold_id])
      raise ArgumentError, 'This amount is already unlocked' unless wallet.release_hold!(hold, performed_by: current_user&.email)
      "#{helpers.indian_currency(hold.amount)} unlocked and moved to the active wallet."
    end
  end

  private

  def wallet_action
    begin
      flash[:notice] = yield(@owner.wallet!)
    rescue ArgumentError, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      flash[:alert] = e.message
    end
    redirect_to wallet_entity_path(@owner)
  end

  def parse_amount(value)
    value.to_s.gsub(/[,\s]/, '').to_d
  end

  def apply_wallet_change(direction)
    wallet = @owner.wallet!
    amount = params[:amount].to_s.gsub(/[,\s]/, '').to_d
    note   = params[:description].to_s.strip

    begin
      if direction == :credit
        wallet.credit!(amount, description: note, performed_by: current_user&.email)
        flash[:notice] = "#{helpers.indian_currency(amount)} added to #{@owner.display_name}'s wallet."
      else
        wallet.debit!(amount, description: note, performed_by: current_user&.email)
        flash[:notice] = "#{helpers.indian_currency(amount)} removed from #{@owner.display_name}'s wallet."
      end
    rescue ArgumentError, ActiveRecord::RecordInvalid => e
      flash[:alert] = e.message
    end

    redirect_to wallet_entity_path(@owner)
  end

  def build_wallet_config
    @wallet_config = {
      noun: owner_noun,
      icon: owner_icon,
      index_path: wallet_index_path
    }
  end
end
