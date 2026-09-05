class Admin::KycVerificationsController < Admin::ApplicationController
  # GET /admin/kyc_verifications
  def index
    @kyc_status_filter = %w[submitted pending rejected approved].include?(params[:status]) ? params[:status] : 'submitted'
    @sub_agents = SubAgent.where(kyc_status: @kyc_status_filter).order(kyc_submitted_at: :desc, created_at: :desc)

    @pending_count = SubAgent.kyc_submitted.count
  end
end
