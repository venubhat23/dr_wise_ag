class Admin::AmbassadorKycVerificationsController < Admin::ApplicationController
  before_action :set_distributor, only: [:approve, :reject, :mark_submitted]

  # Tab key => kyc_status enum value. 'just_registered' and 'registered' are
  # both kyc_status: pending, split further by kyc_step (see #index).
  TABS = {
    'just_registered' => :pending,  # signed up, hasn't touched the KYC wizard yet
    'registered'       => :pending,  # started the KYC wizard, not submitted yet
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
    just_registered = base.kyc_pending.where(kyc_step: 0)
    in_progress      = base.kyc_pending.where.not(kyc_step: 0)

    @tab_counts = {
      'just_registered' => just_registered.count,
      'registered'      => in_progress.count,
      'submitted'       => base.kyc_submitted.count,
      'approved'        => base.kyc_approved.count,
      'rejected'        => base.kyc_rejected.count
    }

    @distributors = case @tab
                    when 'just_registered' then just_registered
                    when 'registered'      then in_progress
                    else base.where(kyc_status: TABS[@tab])
                    end.order(kyc_submitted_at: :desc, created_at: :desc)

    # Anything that still needs an admin to act on it.
    @pending_count = @tab_counts['just_registered'] + @tab_counts['registered'] + @tab_counts['submitted']
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
