class Admin::KycVerificationsController < Admin::ApplicationController
  # GET /admin/kyc_verifications
  def index
    @kyc_status_filter = %w[submitted rejected approved just_registered].include?(params[:status]) ? params[:status] : 'submitted'

    scope = if @kyc_status_filter == 'just_registered'
      # Signed up but haven't submitted KYC yet, regardless of what step they're on.
      SubAgent.kyc_pending
    else
      SubAgent.where(kyc_status: @kyc_status_filter)
    end

    @sub_agents = scope.order(kyc_submitted_at: :desc, created_at: :desc)

    @pending_count = SubAgent.kyc_submitted.count
    @just_registered_count = SubAgent.kyc_pending.count
  end
end
