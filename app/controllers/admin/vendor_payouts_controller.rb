class Admin::VendorPayoutsController < Admin::ApplicationController
  include ConfigurablePagination

  before_action :set_vendor_payout, only: [:mark_paid, :mark_pending]

  # GET /admin/vendor_payouts
  def index
    cache_gen = Rails.cache.read("vendor_cache_gen") || "0"

    stats = Rails.cache.fetch("vendor_payouts_statistics_#{cache_gen}", expires_in: 2.minutes) do
      row = ActiveRecord::Base.connection.execute(<<~SQL).first
        SELECT
          COUNT(*)                                                      AS total,
          COUNT(*) FILTER (WHERE status = 0)                            AS pending_count,
          COUNT(*) FILTER (WHERE status = 1)                            AS paid_count,
          COALESCE(SUM(commission_amount) FILTER (WHERE status = 0), 0) AS pending_amount,
          COALESCE(SUM(commission_amount) FILTER (WHERE status = 1), 0) AS paid_amount
        FROM vendor_payouts
      SQL
      {
        total: row['total'].to_i,
        pending_count: row['pending_count'].to_i,
        paid_count: row['paid_count'].to_i,
        pending_amount: row['pending_amount'].to_f,
        paid_amount: row['paid_amount'].to_f
      }
    end
    @total_payouts   = stats[:total]
    @pending_count   = stats[:pending_count]
    @paid_count      = stats[:paid_count]
    @pending_amount  = stats[:pending_amount]
    @paid_amount     = stats[:paid_amount]

    page_cache_key = [
      "vendor_payouts_page_v1", cache_gen, per_page_param, params[:page], params[:vendor_id], params[:status]
    ].join('|')

    page_bundle = Rails.cache.fetch(page_cache_key, expires_in: 2.minutes) do
      scope = VendorPayout.includes(:vendor, :lead)
      scope = scope.where(vendor_id: params[:vendor_id]) if params[:vendor_id].present?
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

    @vendor_payouts      = Kaminari.paginate_array(page_bundle[:records], total_count: page_bundle[:total_record_count])
                                    .page(params[:page]).per(page_bundle[:items_per_page])
    @total_record_count  = page_bundle[:total_record_count]
    @items_per_page      = page_bundle[:items_per_page]
    @show_pagination     = page_bundle[:show_pagination]

    @vendors_for_filter = Rails.cache.fetch("vendors_for_filter_dropdown_#{cache_gen}", expires_in: 5.minutes) do
      Vendor.order(:name).pluck(:name, :id)
    end
  end

  # PATCH /admin/vendor_payouts/1/mark_paid
  def mark_paid
    @vendor_payout.mark_paid!(paid_by: current_user.email, notes: params[:notes])
    redirect_to admin_vendor_payouts_path, notice: 'Payout marked as paid.'
  rescue => e
    redirect_to admin_vendor_payouts_path, alert: "Failed to mark payout as paid: #{e.message}"
  end

  # PATCH /admin/vendor_payouts/1/mark_pending
  def mark_pending
    @vendor_payout.mark_pending!
    redirect_to admin_vendor_payouts_path, notice: 'Payout marked as pending.'
  rescue => e
    redirect_to admin_vendor_payouts_path, alert: "Failed to mark payout as pending: #{e.message}"
  end

  private

  def set_vendor_payout
    @vendor_payout = VendorPayout.find(params[:id])
  end
end
