class Admin::AmbassadorKycVerificationsController < Admin::ApplicationController
  before_action :set_distributor, only: [:approve, :reject]

  # GET /admin/ambassador_kyc_verifications
  #
  # Review queue for ambassadors who signed up through the public
  # "Register as Ambassador" form (AmbassadorRegistrationsController).
  def index
    @kyc_status_filter = %w[submitted approved rejected].include?(params[:status]) ? params[:status] : 'submitted'

    @distributors = Distributor.self_registered
                               .where(kyc_status: @kyc_status_filter)
                               .order(kyc_submitted_at: :desc, created_at: :desc)

    @pending_count = Distributor.self_registered.kyc_submitted.count
  end

  # PATCH /admin/ambassador_kyc_verifications/:id/approve
  def approve
    @distributor.approve_kyc!
    redirect_to admin_ambassador_kyc_verifications_path,
                notice: "#{@distributor.display_name.presence || @distributor.email}'s KYC approved and account activated."
  end

  # PATCH /admin/ambassador_kyc_verifications/:id/reject
  def reject
    @distributor.reject_kyc!(params[:kyc_rejection_reason])
    redirect_to admin_ambassador_kyc_verifications_path(status: 'rejected'),
                notice: "#{@distributor.display_name.presence || @distributor.email}'s KYC has been rejected."
  end

  private

  def set_distributor
    @distributor = Distributor.self_registered.find(params[:id])
  end
end
