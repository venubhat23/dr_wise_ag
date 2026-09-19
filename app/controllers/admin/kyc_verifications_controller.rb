class Admin::KycVerificationsController < Admin::ApplicationController
  include KycQueueTools

  # GET /admin/kyc_verifications
  def index
    @kyc_status_filter = %w[submitted rejected approved just_registered].include?(params[:status]) ? params[:status] : 'submitted'

    scope = if @kyc_status_filter == 'just_registered'
      # Signed up but haven't submitted KYC yet, regardless of what step they're on.
      SubAgent.kyc_pending
    else
      SubAgent.where(kyc_status: @kyc_status_filter)
    end

    scope = apply_kyc_search(scope)

    @sub_agents = scope.includes(:sub_agent_documents).order(kyc_submitted_at: :desc, created_at: :desc)

    @pending_count = SubAgent.kyc_submitted.count
    @just_registered_count = SubAgent.kyc_pending.count
  end

  # POST /admin/kyc_verifications/bulk_action
  # params: ids[], bulk_action (approve|reject), reason (reject only), status, q
  def bulk_action
    ids = Array(params[:ids]).reject(&:blank?)
    action = params[:bulk_action].to_s
    back = admin_kyc_verifications_path(status: params[:status].presence, q: params[:q].presence)

    if ids.empty? || !%w[approve reject].include?(action)
      return redirect_to back, alert: 'Select at least one affiliate first.'
    end

    reason = params[:reason].presence || DEFAULT_REJECTION_REASON
    result = run_bulk(SubAgent.where(id: ids)) do |sub_agent|
      next :skip unless sub_agent.kyc_submitted?

      if action == 'approve'
        sub_agent.approve_kyc!
        SendKycStatusEmailJob.perform_later(sub_agent_id: sub_agent.id, event: 'approved')
      else
        sub_agent.reject_kyc!(reason)
        SendKycStatusEmailJob.perform_later(sub_agent_id: sub_agent.id, event: 'rejected')
      end
    end

    flash_type = result[:failed].any? || result[:done].zero? ? :alert : :notice
    redirect_to back, flash_type => bulk_flash(result, action == 'approve' ? 'approved' : 'rejected')
  end
end
