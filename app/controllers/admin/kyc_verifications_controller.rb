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

    return render_kyc_lookup(scope) if params[:lookup].present?

    scope = apply_kyc_search(scope)

    # Registration-fee payment filter: paid / unpaid (unpaid = self-registered and not yet paid).
    @payment_filter = %w[paid unpaid].include?(params[:payment]) ? params[:payment] : nil
    scope = case @payment_filter
            when 'paid' then scope.where(payment_paid: true)
            when 'unpaid' then scope.where(payment_paid: false, self_registered: true)
            else scope
            end

    # 3 queries however many rows: affiliates, their documents, their assignment
    # rows. (This DB has ~350ms per round trip, so round trips are what cost.)
    @sub_agents = scope.includes(:sub_agent_documents, :distributor_assignment, :subscriptions)
                       .order(kyc_submitted_at: :desc, created_at: :desc).load
    preload_legacy_attachments(@sub_agents)

    # Ambassador names for the "Referred By" cell: one query, and only if needed.
    # Includes admin-connected affiliates too (map_to_ambassador! sets ambassador_id
    # with no referred_by_code), not just referral signups.
    referred_ids = @sub_agents.filter_map(&:ambassador_id).uniq
    @ambassadors_by_id = referred_ids.any? ? Distributor.where(id: referred_ids).select(:id, :first_name, :last_name).index_by(&:id) : {}

    # Ambassadors an unmapped affiliate can be connected to while approving:
    # only fetched when such a row is actually on screen, and cached.
    needs_ambassador_picker = @sub_agents.any? { |s| s.kyc_submitted? && s.ambassador_id.nil? }
    @ambassador_options = needs_ambassador_picker ? cached_ambassador_options : []

    # Per-tab counts in one grouped query (cache is cleared by SubAgent's after_commit).
    counts = Rails.cache.fetch('kyc_queue/affiliate_tab_counts', expires_in: 5.minutes) do
      SubAgent.group(:kyc_status).count
    end
    @tab_counts = {
      'just_registered' => counts['pending'].to_i,
      'submitted'       => counts['submitted'].to_i,
      'approved'        => counts['approved'].to_i,
      'rejected'        => counts['rejected'].to_i
    }
    @pending_count = @tab_counts['submitted']
    @just_registered_count = @tab_counts['just_registered']
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
    ambassador = Distributor.find_by(id: params[:assigned_distributor_id]) if params[:assigned_distributor_id].present?
    result = run_bulk(SubAgent.where(id: ids).includes(:distributor, :assigned_distributor, :distributor_assignment)) do |sub_agent|
      next :skip unless sub_agent.kyc_submitted?

      if action == 'approve'
        # Only affiliates with no Ambassador yet are connected; existing mappings are left alone.
        sub_agent.map_to_ambassador!(ambassador) if ambassador
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

  private

  def cached_ambassador_options
    Rails.cache.fetch('kyc_queue/ambassador_options', expires_in: 10.minutes) do
      Distributor.active.order(:first_name, :last_name).pluck(:id, :first_name, :last_name, :email).map do |id, first, last, email|
        ["#{first} #{last} - #{email}", id]
      end
    end
  end

  # Documents uploaded before R2 storage have no r2_file_key and are checked via
  # ActiveStorage (`attached?`), which would query once per document. Load all
  # of those attachments in a single query (none at all when there are no such docs).
  def preload_legacy_attachments(sub_agents)
    legacy = sub_agents.flat_map(&:sub_agent_documents).select { |d| d.r2_file_key.blank? }
    return if legacy.empty?

    ActiveRecord::Associations::Preloader.new(records: legacy, associations: :document_file_attachment).call
  end
end
