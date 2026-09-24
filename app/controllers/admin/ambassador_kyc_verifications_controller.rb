class Admin::AmbassadorKycVerificationsController < Admin::ApplicationController
  include KycQueueTools

  before_action :set_distributor, only: [:approve, :reject, :mark_submitted]

  # Tab key => kyc_status enum value.
  TABS = {
    'just_registered' => :pending,   # signed up, KYC not submitted yet (wizard in progress or untouched)
    'submitted'        => :submitted, # KYC submitted, awaiting admin review
    'approved'         => :approved,
    'rejected'         => :rejected
  }.freeze

  # GET /admin/ambassador_kyc_verifications
  #
  # Review queue for ambassadors who signed up through the public
  # "Register as Ambassador" form (AmbassadorRegistrationsController).
  def index
    @tab = TABS.key?(params[:status]) ? params[:status] : 'just_registered'

    base = Distributor.self_registered

    # One grouped query instead of four counts.
    counts = base.group(:kyc_status).count
    @tab_counts = TABS.transform_values { |status| counts[status.to_s].to_i }

    return render_kyc_lookup(base.where(kyc_status: TABS[@tab])) if params[:lookup].present?

    @distributors = apply_kyc_search(base.where(kyc_status: TABS[@tab]))
                        .order(kyc_submitted_at: :desc, created_at: :desc)

    # Anything that still needs an admin to act on it.
    @pending_count = @tab_counts['just_registered'] + @tab_counts['submitted']
  end

  # POST /admin/ambassador_kyc_verifications/bulk_action
  # params: ids[], bulk_action (approve|reject), reason (reject only), status, q
  def bulk_action
    ids = Array(params[:ids]).reject(&:blank?)
    action = params[:bulk_action].to_s
    back = admin_ambassador_kyc_verifications_path(status: params[:status].presence, q: params[:q].presence)

    if ids.empty? || !%w[approve reject].include?(action)
      return redirect_to back, alert: 'Select at least one ambassador first.'
    end

    reason = params[:reason].presence || 'Rejected by admin'
    result = run_bulk(Distributor.self_registered.where(id: ids)) do |distributor|
      next :skip unless distributor.kyc_pending? || distributor.kyc_submitted?

      if action == 'approve'
        distributor.approve_kyc!
        SendAmbassadorKycEmailJob.perform_later(distributor_id: distributor.id, event: 'approved')
      else
        distributor.reject_kyc!(reason)
        SendAmbassadorKycEmailJob.perform_later(distributor_id: distributor.id, event: 'rejected')
      end
    end

    flash_type = result[:failed].any? || result[:done].zero? ? :alert : :notice
    redirect_to back, flash_type => bulk_flash(result, action == 'approve' ? 'approved' : 'rejected')
  end

  # PATCH /admin/ambassador_kyc_verifications/:id/mark_submitted
  # Move a "just registered" ambassador into the review queue.
  def mark_submitted
    @distributor.update!(kyc_status: :submitted, kyc_submitted_at: Time.current)
    redirect_to admin_ambassador_kyc_verifications_path(status: 'submitted'),
                notice: "#{ambassador_label}'s KYC moved to the review queue."
  end

  # PATCH /admin/ambassador_kyc_verifications/:id/approve
  def approve
    @distributor.approve_kyc!
    SendAmbassadorKycEmailJob.perform_later(distributor_id: @distributor.id, event: 'approved')
    redirect_to admin_ambassador_kyc_verifications_path(status: 'approved'),
                notice: "#{ambassador_label}'s KYC approved and account activated."
  end

  # PATCH /admin/ambassador_kyc_verifications/:id/reject
  def reject
    @distributor.reject_kyc!(params[:kyc_rejection_reason])
    SendAmbassadorKycEmailJob.perform_later(distributor_id: @distributor.id, event: 'rejected')
    redirect_to admin_ambassador_kyc_verifications_path(status: 'rejected'),
                notice: "#{ambassador_label}'s KYC has been rejected."
  end

  private

  def ambassador_label
    @distributor.display_name.presence || @distributor.email
  end

  def set_distributor
    @distributor = Distributor.self_registered.find(params[:id])
  end
end
