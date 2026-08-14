class VendorPortalController < ApplicationController
  include ConfigurablePagination

  before_action :authenticate_user!
  before_action :ensure_vendor_user
  before_action :setup_vendor_data

  # GET /vendor/dashboard
  def dashboard
    cache_gen = Rails.cache.read("vendor_cache_gen") || "0"

    # Stats + recent activity are always rendered together on this page, so
    # they're fetched as a single cache entry — one round trip instead of two.
    bundle = Rails.cache.fetch("vendor_dashboard_bundle_v1_#{@vendor_id}_#{cache_gen}", expires_in: 2.minutes) do
      vid = @vendor_id
      row = ActiveRecord::Base.connection.execute(<<~SQL).first
        SELECT
          (
            (SELECT COUNT(*) FROM leads WHERE vendor_id = #{vid}) +
            (SELECT COUNT(*) FROM client_services WHERE vendor_id = #{vid}) +
            (SELECT COUNT(*) FROM mutual_funds WHERE vendor_id = #{vid})
          )                                                                                         AS leads_received,
          (
            (SELECT COUNT(*) FROM leads WHERE vendor_id = #{vid} AND current_stage = 'converted') +
            (SELECT COUNT(*) FROM client_services WHERE vendor_id = #{vid} AND status = 'completed')
          )                                                                                         AS leads_converted,
          COALESCE((SELECT SUM(commission_amount) FROM vendor_payouts WHERE vendor_id = #{vid} AND status = 0), 0) AS pending_amount,
          COALESCE((SELECT SUM(commission_amount) FROM vendor_payouts WHERE vendor_id = #{vid} AND status = 1), 0) AS paid_amount
      SQL

      lead_rows = Lead.where(vendor_id: vid).order(created_at: :desc).limit(5).map do |lead|
        {
          name: lead.name,
          product: "#{lead.product_category&.humanize} / #{lead.product_subcategory&.humanize}",
          stage: lead.stage_display_name,
          badge_class: lead.stage_badge_class,
          date: lead.created_at
        }
      end

      service_rows = ClientService.where(vendor_id: vid).includes(:customer).order(created_at: :desc).limit(5).map do |cs|
        {
          name: cs.customer&.display_name,
          product: cs.service_type_label,
          stage: cs.status_display_name,
          badge_class: cs.status_badge_class,
          date: cs.created_at
        }
      end

      {
        leads_received:  row['leads_received'].to_i,
        leads_converted: row['leads_converted'].to_i,
        pending_amount:  row['pending_amount'].to_f,
        paid_amount:     row['paid_amount'].to_f,
        recent_activity: (lead_rows + service_rows).sort_by { |r| r[:date] }.reverse.first(5)
      }
    end

    @leads_received   = bundle[:leads_received]
    @leads_converted  = bundle[:leads_converted]
    @pending_amount   = bundle[:pending_amount]
    @paid_amount      = bundle[:paid_amount]
    @recent_activity  = bundle[:recent_activity]
  end

  # GET /vendor/leads
  def leads
    cache_gen = Rails.cache.read("vendor_cache_gen") || "0"
    page_cache_key = [
      "vendor_leads_bundle_v1", @vendor_id, cache_gen, per_page_param, params[:page], params[:stage]
    ].join('|')

    # Leads pagination and the assigned-products list are always rendered
    # together on this page, so they're fetched as a single cache entry —
    # one round trip instead of two.
    page_bundle = Rails.cache.fetch(page_cache_key, expires_in: 2.minutes) do
      scope = Lead.where(vendor_id: @vendor_id)
      scope = scope.where(current_stage: params[:stage]) if params[:stage].present?

      total_filtered_count = scope.count
      paginated = paginate_records(scope.order(created_at: :desc), total_filtered_count)

      services = ClientService.where(vendor_id: @vendor_id).includes(:customer).order(created_at: :desc).limit(50).map do |cs|
        {
          id: cs.id,
          client_name: cs.customer&.display_name,
          product: cs.service_type_label,
          amount: cs.amount,
          status: cs.status_display_name,
          badge_class: cs.status_badge_class,
          date: cs.start_date || cs.created_at.to_date,
          ref: cs.reference_number,
          next_status_options: cs.next_status_options
        }
      end

      investments = MutualFund.where(vendor_id: @vendor_id).includes(:customer).order(created_at: :desc).limit(50).map do |mf|
        {
          id: nil,
          client_name: mf.customer&.display_name,
          product: "Mutual Fund - #{mf.fund_name}",
          amount: mf.amount,
          status: nil,
          badge_class: 'bg-light text-dark',
          date: mf.created_at.to_date,
          ref: mf.folio_number,
          next_status_options: []
        }
      end

      {
        records: paginated.to_a,
        total_record_count: @total_record_count,
        items_per_page: @items_per_page,
        show_pagination: @show_pagination,
        assigned_products: (services + investments).sort_by { |row| row[:date] || Date.new(0) }.reverse
      }
    end

    @leads               = Kaminari.paginate_array(page_bundle[:records], total_count: page_bundle[:total_record_count])
                                    .page(params[:page]).per(page_bundle[:items_per_page])
    @total_record_count  = page_bundle[:total_record_count]
    @items_per_page      = page_bundle[:items_per_page]
    @show_pagination     = page_bundle[:show_pagination]
    @assigned_products   = page_bundle[:assigned_products]
  end

  # PATCH /vendor/leads/1/update_stage
  def update_lead_stage
    lead = Lead.where(vendor_id: @vendor_id).find(params[:id])
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

  # PATCH /vendor/services/1/update_status
  def update_service_status
    service = ClientService.where(vendor_id: @vendor_id).find(params[:id])
    new_status = params[:new_status]

    unless ClientService::STATUSES.include?(new_status)
      redirect_to vendor_leads_path, alert: 'Invalid stage.'
      return
    end

    unless service.next_status_options.include?(new_status)
      redirect_to vendor_leads_path, alert: 'Cannot transition to this stage from current state.'
      return
    end

    service.update!(status: new_status)
    redirect_to vendor_leads_path, notice: "Service successfully moved to: #{service.status_display_name}"
  rescue ActiveRecord::RecordNotFound
    redirect_to vendor_leads_path, alert: 'Service not found.'
  end

  # GET /vendor/payouts
  def payouts
    cache_gen = Rails.cache.read("vendor_cache_gen") || "0"
    page_cache_key = [
      "vendor_payouts_page_v1", @vendor_id, cache_gen, per_page_param, params[:page], params[:status]
    ].join('|')

    page_bundle = Rails.cache.fetch(page_cache_key, expires_in: 2.minutes) do
      scope = VendorPayout.where(vendor_id: @vendor_id).includes(:lead, client_service: :customer)
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

  # PATCH /vendor/payouts/:id/mark_paid
  def mark_payout_paid
    payout = VendorPayout.where(vendor_id: @vendor_id).find(params[:id])
    payout.mark_paid!(paid_by: current_user.email)
    redirect_to vendor_payouts_path, notice: 'Payout marked as paid.'
  rescue ActiveRecord::RecordNotFound
    redirect_to vendor_payouts_path, alert: 'Payout not found.'
  end

  private

  def ensure_vendor_user
    redirect_to new_vendor_session_path, alert: 'Access denied. Vendor account required.' unless current_user&.vendor?
  end

  # The vendor<->user link is resolved by e-mail lookup, which otherwise runs
  # on every single request (before_action). The session cookie is stored
  # client-side, so stashing the resolved id/name there means we only pay for
  # that lookup once per login instead of once per page view.
  def setup_vendor_data
    if session[:vendor_user_id] == current_user.id && session[:vendor_id]
      @vendor_id           = session[:vendor_id]
      @vendor_display_name = session[:vendor_display_name]
      return
    end

    vendor = Vendor.find_by(email: current_user.email)
    unless vendor
      redirect_to new_vendor_session_path, alert: 'No vendor profile is linked to this account. Contact DrWise support.'
      return
    end

    @vendor_id           = vendor.id
    @vendor_display_name = vendor.display_name
    session[:vendor_user_id]       = current_user.id
    session[:vendor_id]            = vendor.id
    session[:vendor_display_name]  = vendor.display_name
  end
end
