class Admin::WithdrawalRequestsController < Admin::ApplicationController
  include ConfigurablePagination

  before_action :set_withdrawal_request, only: [:approve, :reject]

  TABS = %w[pending approved rejected].freeze

  # GET /admin/withdrawal_requests
  def index
    @tab = TABS.include?(params[:status]) ? params[:status] : 'pending'

    @tab_counts = {
      'pending'  => WithdrawalRequest.pending.count,
      'approved' => WithdrawalRequest.approved.count,
      'rejected' => WithdrawalRequest.rejected.count
    }

    scope = WithdrawalRequest.where(status: @tab).includes(:owner)
    @withdrawal_requests = paginate_records(scope.recent_first)
  end

  # PATCH /admin/withdrawal_requests/:id/approve
  def approve
    @withdrawal_request.approve!(reviewed_by: current_user.email)
    redirect_to admin_withdrawal_requests_path(status: 'approved'),
                notice: "Withdrawal of #{helpers.indian_currency(@withdrawal_request.amount)} approved for #{@withdrawal_request.owner_label}."
  rescue ArgumentError => e
    redirect_to admin_withdrawal_requests_path(status: 'pending'), alert: e.message
  end

  # PATCH /admin/withdrawal_requests/:id/reject
  def reject
    @withdrawal_request.reject!(reviewed_by: current_user.email, reason: params[:rejection_reason])
    redirect_to admin_withdrawal_requests_path(status: 'rejected'),
                notice: "Withdrawal request from #{@withdrawal_request.owner_label} rejected."
  rescue ArgumentError => e
    redirect_to admin_withdrawal_requests_path(status: 'pending'), alert: e.message
  end

  private

  def set_withdrawal_request
    @withdrawal_request = WithdrawalRequest.find(params[:id])
  end
end
