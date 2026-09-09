class Admin::KycVerificationsController < Admin::ApplicationController
  # GET /admin/kyc_verifications
  def index
    @kyc_status_filter = %w[submitted pending rejected approved just_registered].include?(params[:status]) ? params[:status] : 'submitted'

    scope = if @kyc_status_filter == 'just_registered'
      # Self-registered affiliates who created an account but have not uploaded
      # their KYC documents yet (kyc_status still pending, account still inactive).
      SubAgent.kyc_pending.where(status: :inactive)
    else
      SubAgent.where(kyc_status: @kyc_status_filter)
    end

    @sub_agents = scope.order(kyc_submitted_at: :desc, created_at: :desc)

    @pending_count = SubAgent.kyc_submitted.count
    @just_registered_count = SubAgent.kyc_pending.where(status: :inactive).count
  end
end
