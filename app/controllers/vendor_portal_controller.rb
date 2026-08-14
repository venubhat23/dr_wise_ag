class VendorPortalController < ApplicationController
  include ConfigurablePagination

  layout 'vendor_portal'

  before_action :authenticate_user!
  before_action :ensure_vendor_user
  before_action :setup_vendor_data

  # GET /vendor/dashboard
  def dashboard
    cache_gen = Rails.cache.read("vendor_cache_gen") || "0"
    stats = Rails.cache.fetch("vendor_dashboard_stats_#{@vendor.id}_#{cache_gen}", expires_in: 2.minutes) do
      vid = @vendor.id.to_i
      row = ActiveRecord::Base.connection.execute(<<~SQL).first
        SELECT
          (SELECT COUNT(*) FROM leads WHERE vendor_id = #{vid})                                    AS leads_received,
          (SELECT COUNT(*) FROM leads WHERE vendor_id = #{vid} AND current_stage = 'converted')     AS leads_converted,
          COALESCE((SELECT SUM(commission_amount) FROM vendor_payouts WHERE vendor_id = #{vid} AND status = 0), 0) AS pending_amount,
          COALESCE((SELECT SUM(commission_amount) FROM vendor_payouts WHERE vendor_id = #{vid} AND status = 1), 0) AS paid_amount
      SQL
      {
        leads_received: row['leads_received'].to_i,
        leads_converted: row['leads_converted'].to_i,
        pending_amount: row['pending_amount'].to_f,
        paid_amount: row['paid_amount'].to_f
      }
    end
    @leads_received  = stats[:leads_received]
    @leads_converted = stats[:leads_converted]
    @pending_amount  = stats[:pending_amount]
    @paid_amount     = stats[:paid_amount]

    @recent_leads = Rails.cache.fetch("vendor_recent_leads_#{@vendor.id}_#{cache_gen}", expires_in: 2.minutes) do
      @vendor.leads.order(created_at: :desc).limit(5).to_a
    end
  end

  # GET /vendor/leads
  def leads
    cache_gen = Rails.cache.read("vendor_cache_gen") || "0"
    page_cache_key = [
      "vendor_leads_page_v1", @vendor.id, cache_gen, per_page_param, params[:page], params[:stage]
    ].join('|')

    page_bundle = Rails.cache.fetch(page_cache_key, expires_in: 2.minutes) do
      scope = @vendor.leads
      scope = scope.where(current_stage: params[:stage]) if params[:stage].present?

      total_filtered_count = scope.count
      paginated = paginate_records(scope.order(created_at: :desc), total_filtered_count)

      {
        records: paginated.to_a,
        total_record_count: @total_record_count,
        items_per_page: @items_per_page,
        show_pagination: @show_pagination
      }
    end

    @leads               = Kaminari.paginate_array(page_bundle[:records], total_count: page_bundle[:total_record_count])
                                    .page(params[:page]).per(page_bundle[:items_per_page])
    @total_record_count  = page_bundle[:total_record_count]
    @items_per_page      = page_bundle[:items_per_page]
    @show_pagination     = page_bundle[:show_pagination]
  end

  # PATCH /vendor/leads/1/update_stage
  def update_lead_stage
    lead = @vendor.leads.find(params[:id])
    new_stage = params[:new_stage]

    unless Lead.current_stages.key?(new_stage)
      redirect_to vendor_leads_path, alert: 'Invalid stage.'
      return
    end

    unless lead.next_stage_options.include?(new_stage)
      redirect_to vendor_leads_path, alert: 'Cannot transition to this stage from current state.'
      return
    end

    if lead.cannot_change_stage?
      redirect_to vendor_leads_path, alert: 'Lead stage cannot be changed after conversion.'
      return
    end

    # Same transition methods Admin::LeadsController#update_stage uses.
    success = case new_stage
    when 'consultation_scheduled' then lead.move_to_consultation_scheduled!
    when 'one_on_one'             then lead.move_to_one_on_one!
    when 'follow_up'               then lead.move_to_follow_up!
    when 'follow_up_successful'    then lead.mark_follow_up_successful!
    when 'follow_up_unsuccessful'  then lead.mark_follow_up_unsuccessful!
    when 'not_interested'          then lead.mark_not_interested!
    when 're_follow_up'            then lead.move_to_re_follow_up!
    when 'converted'
      lead.update!(current_stage: 'converted', stage_updated_at: Time.current)
      true
    when 'lead_closed' then lead.close_lead!
    else false
    end

    if success
      redirect_to vendor_leads_path, notice: "Lead successfully moved to: #{lead.stage_display_name}"
    else
      redirect_to vendor_leads_path, alert: "Failed to update lead stage."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to vendor_leads_path, alert: 'Lead not found.'
  end

  # GET /vendor/payouts
  def payouts
    cache_gen = Rails.cache.read("vendor_cache_gen") || "0"
    page_cache_key = [
      "vendor_payouts_page_v1", @vendor.id, cache_gen, per_page_param, params[:page], params[:status]
    ].join('|')

    page_bundle = Rails.cache.fetch(page_cache_key, expires_in: 2.minutes) do
      scope = @vendor.vendor_payouts.includes(:lead)
      scope = scope.where(status: params[:status]) if params[:status].present?

      total_filtered_count = scope.count
      paginated = paginate_records(scope.order(created_at: :desc), total_filtered_count)

      {
        records: paginated.to_a,
        total_record_count: @total_record_count,
        items_per_page: @items_per_page,
        show_pagination: @show_pagination
      }
    end

    @vendor_payouts       = Kaminari.paginate_array(page_bundle[:records], total_count: page_bundle[:total_record_count])
                                     .page(params[:page]).per(page_bundle[:items_per_page])
    @total_record_count   = page_bundle[:total_record_count]
    @items_per_page       = page_bundle[:items_per_page]
    @show_pagination      = page_bundle[:show_pagination]
  end

  private

  def ensure_vendor_user
    redirect_to new_vendor_session_path, alert: 'Access denied. Vendor account required.' unless current_user&.vendor?
  end

  def setup_vendor_data
    @vendor = Vendor.find_by(email: current_user.email)
    redirect_to new_vendor_session_path, alert: 'No vendor profile is linked to this account. Contact DrWise support.' unless @vendor
  end
end
