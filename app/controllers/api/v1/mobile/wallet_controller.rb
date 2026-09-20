# Wallet & withdrawal-request APIs shared by the mobile app's Ambassador and
# Affiliate (Sub Agent) accounts - mirrors the web AmbassadorController#wallet
# / Admin::WithdrawalRequestsController flow, just exposed over JSON.
class Api::V1::Mobile::WalletController < Api::V1::Mobile::BaseController
  before_action :authenticate_wallet_owner!

  # GET /api/v1/mobile/wallet/summary
  def summary
    wallet = @owner.wallet!
    pending_request = @owner.withdrawal_requests.pending.first
    locked_holds = wallet.wallet_holds.locked.includes(:trigger_sub_agent).recent_first.to_a
    inactive_total = locked_holds.sum(&:amount)
    total = wallet.balance + inactive_total

    render_success(
      # `balance` / `total_balance` = active + inactive. Only `active_balance`
      # is withdrawable.
      balance: total.to_f,
      balance_formatted: format_indian_amount(total),
      total_balance: total.to_f,
      total_balance_formatted: format_indian_amount(total),
      active_balance: wallet.balance.to_f,
      active_balance_formatted: format_indian_amount(wallet.balance),
      inactive_balance: inactive_total.to_f,
      inactive_balance_formatted: format_indian_amount(inactive_total),
      inactive_holds: locked_holds.map { |hold| hold_json(hold) },
      total_credited: wallet.total_credited.to_f,
      total_debited: wallet.total_debited.to_f,
      min_withdrawal_amount: WithdrawalRequest::MIN_AMOUNT.to_f,
      pending_withdrawal_request: pending_request && withdrawal_request_json(pending_request)
    )
  end

  # GET /api/v1/mobile/wallet/transactions
  def transactions
    page, per_page = pagination_params
    wallet = @owner.wallet!
    scope = wallet.wallet_transactions.recent_first

    # One merged history:
    #  * ledger entries (active wallet)
    #  * money still locked in the inactive wallet - once a hold unlocks it
    #    becomes a ledger credit ("Unlocked: ...") and drops out of this list
    #  * withdrawal requests still pending or rejected - an approved request is
    #    already in the ledger as a debit, so it is not repeated here
    locked_holds = wallet.wallet_holds.locked.recent_first.to_a
    open_requests = @owner.withdrawal_requests.where(status: %i[pending rejected]).recent_first.to_a
    total_count = scope.count + locked_holds.size + open_requests.size
    ledger = scope.limit(page * per_page).to_a

    entries = ledger.map { |txn| [txn.created_at, txn.id, transaction_json(txn)] } +
              locked_holds.map { |hold| [hold.created_at, hold.id, locked_hold_transaction_json(hold)] } +
              open_requests.map { |wr| [wr.created_at, wr.id, withdrawal_transaction_json(wr)] }
    entries = entries.sort_by { |created_at, id, _| [created_at, id] }.reverse
    records = entries.drop((page - 1) * per_page).first(per_page).map(&:last)

    render_success(
      transactions: records,
      # Full withdrawal-request history (all statuses), same shape as
      # GET /wallet/withdrawal_requests.
      withdrawal_requests: @owner.withdrawal_requests.recent_first.map { |wr| withdrawal_request_json(wr) },
      wallet: wallet_balances_json,
      pagination: pagination_meta(page, per_page, total_count)
    )
  end

  # GET /api/v1/mobile/wallet/withdrawal_requests
  def withdrawal_requests
    page, per_page = pagination_params
    scope = @owner.withdrawal_requests.recent_first

    total_count = scope.count
    records = scope.limit(per_page).offset((page - 1) * per_page)

    render_success(
      withdrawal_requests: records.map { |wr| withdrawal_request_json(wr) },
      wallet: wallet_balances_json,
      pagination: pagination_meta(page, per_page, total_count)
    )
  end

  # POST /api/v1/mobile/wallet/withdraw
  # params: amount, reason
  def withdraw
    withdrawal_request = @owner.withdrawal_requests.new(
      amount: params[:amount],
      reason: params[:reason]
    )

    if withdrawal_request.save
      render_success(
        { withdrawal_request: withdrawal_request_json(withdrawal_request), wallet: wallet_balances_json },
        'Withdrawal request submitted. We will review it shortly.'
      )
    else
      render_error('Withdrawal request could not be submitted', :unprocessable_entity,
                    withdrawal_request.errors.full_messages + ["Active wallet: #{format_indian_amount(@owner.wallet!.balance)}, Inactive wallet: #{format_indian_amount(@owner.wallet!.inactive_balance)}"])
    end
  end

  private

  # Resolves @owner to the Distributor (Ambassador) or SubAgent (Affiliate)
  # whose wallet is being accessed. Ambassadors log in as a `User` record
  # (role 'ambassador'); their business data lives on a separate Distributor
  # row matched by email - same lookup the web AmbassadorController uses.
  def authenticate_wallet_owner!
    token = request.headers['Authorization']&.split(' ')&.last
    return render_error('Authorization token is required', :unauthorized) if token.blank?

    decoded_token = JWT.decode(token, Rails.application.secret_key_base)[0]

    case decoded_token['role']
    when 'sub_agent'
      @owner = SubAgent.find_by(id: decoded_token['user_id'])
      return render_error('Affiliate account not found', :unauthorized) unless @owner
    when 'ambassador'
      user = User.find_by(id: decoded_token['user_id'])
      return render_error('Ambassador account not found', :unauthorized) unless user

      @owner = Distributor.find_by(email: user.email)
      return render_error('Ambassador profile not found', :unauthorized) unless @owner
    else
      return render_error('Ambassador or affiliate access required', :unauthorized)
    end
  rescue JWT::DecodeError
    render_error('Invalid authorization token', :unauthorized)
  end

  def pagination_params
    page = [params[:page].to_i, 1].max
    per_page = params[:per_page].to_i
    per_page = 15 if per_page <= 0
    per_page = [per_page, 50].min
    [page, per_page]
  end

  def pagination_meta(page, per_page, total_count)
    total_pages = (total_count.to_f / per_page).ceil
    {
      current_page: page,
      per_page: per_page,
      total_pages: total_pages,
      total_count: total_count,
      has_next_page: page < total_pages,
      has_prev_page: page > 1
    }
  end

  def transaction_json(txn)
    {
      id: txn.id,
      txn_type: txn.txn_type,
      amount: txn.debit? ? -txn.amount.to_f : txn.amount.to_f,
      balance_after: txn.balance_after.to_f,
      description: txn.description,
      wallet_type: 'active',
      status: 'completed',
      created_at: txn.created_at.iso8601
    }
  end

  # A pending/rejected withdrawal request in the transaction-history shape. No
  # money has moved (approval is what debits the ledger), so `balance_after` is null.
  def withdrawal_transaction_json(wr)
    {
      id: nil,
      withdrawal_request_id: wr.id,
      txn_type: 'withdrawal_request',
      amount: -wr.amount.to_f,
      balance_after: nil,
      description: "Withdrawal request: #{wr.reason}",
      wallet_type: 'active',
      status: wr.status,
      rejection_reason: wr.rejection_reason,
      created_at: wr.created_at.iso8601
    }
  end

  # A locked hold rendered in the transaction-history shape. It has no ledger
  # row yet, so `id` is null and `balance_after` is null.
  def locked_hold_transaction_json(hold)
    {
      id: nil,
      hold_id: hold.id,
      txn_type: 'credit',
      amount: hold.amount.to_f,
      balance_after: nil,
      description: hold.description,
      wallet_type: 'inactive',
      status: 'locked',
      unlock_condition: hold.unlock_condition,
      created_at: hold.created_at.iso8601
    }
  end

  # Active (withdrawable) + inactive (locked) balances, shown next to withdrawals.
  def wallet_balances_json
    wallet = @owner.wallet!
    inactive = wallet.inactive_balance
    {
      active_balance: wallet.balance.to_f,
      active_balance_formatted: format_indian_amount(wallet.balance),
      inactive_balance: inactive.to_f,
      inactive_balance_formatted: format_indian_amount(inactive),
      total_balance: (wallet.balance + inactive).to_f,
      total_balance_formatted: format_indian_amount(wallet.balance + inactive),
      min_withdrawal_amount: WithdrawalRequest::MIN_AMOUNT.to_f
    }
  end

  def hold_json(hold)
    {
      id: hold.id,
      amount: hold.amount.to_f,
      kind: hold.kind,
      status: hold.status,
      description: hold.description,
      unlock_condition: hold.unlock_condition,
      created_at: hold.created_at.iso8601
    }
  end

  def withdrawal_request_json(wr)
    {
      id: wr.id,
      amount: wr.amount.to_f,
      reason: wr.reason,
      status: wr.status,
      rejection_reason: wr.rejection_reason,
      requested_at: wr.created_at.iso8601,
      reviewed_at: wr.reviewed_at&.iso8601
    }
  end
end
