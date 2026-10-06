class Admin::WithdrawalRequestsController < Admin::ApplicationController
  include ConfigurablePagination

  before_action :set_withdrawal_request, only: [:approve, :reject]

  TABS = %w[pending approved rejected].freeze

  # GET /admin/withdrawal_requests
  def index
    @tab = TABS.include?(params[:status]) ? params[:status] : 'pending'

    counts = WithdrawalRequest.group(:status).count # one query for all three tabs
    @tab_counts = TABS.index_with { |tab| counts[tab] || 0 }

    scope = WithdrawalRequest.where(status: @tab).includes(owner: { wallet: :wallet_holds })
    @withdrawal_requests = paginate_records(scope.recent_first)
  end

  # PATCH /admin/withdrawal_requests/:id/approve
  def approve
    @withdrawal_request.approve!(reviewed_by: current_user.email)
    redirect_to admin_withdrawal_requests_path(status: 'approved'),
                notice: "Withdrawal of #{helpers.indian_currency(@withdrawal_request.amount)} approved for #{@withdrawal_request.owner_label}."
  rescue ArgumentError, ActiveRecord::RecordInvalid => e
    review_failed('approve', e)
  end

  # PATCH /admin/withdrawal_requests/:id/reject
  def reject
    @withdrawal_request.reject!(reviewed_by: current_user.email, reason: params[:rejection_reason])
    redirect_to admin_withdrawal_requests_path(status: 'rejected'),
                notice: "Withdrawal request from #{@withdrawal_request.owner_label} rejected."
  rescue ArgumentError, ActiveRecord::RecordInvalid => e
    review_failed('reject', e)
  end

  private

  # Back to the list with the reason shown in a pop-up (index.html.erb)
  # instead of a raw error page.
  def review_failed(action, error)
    message = error.is_a?(ActiveRecord::RecordInvalid) ? error.record.errors.full_messages.to_sentence : error.message
    flash[:review_error] = { 'action' => action, 'id' => @withdrawal_request.id, 'message' => message }
    redirect_to admin_withdrawal_requests_path(status: @withdrawal_request.status)
  end

  def set_withdrawal_request
    @withdrawal_request = WithdrawalRequest.find(params[:id])
  end
end
