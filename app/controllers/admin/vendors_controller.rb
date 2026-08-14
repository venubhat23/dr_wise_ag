class Admin::VendorsController < Admin::ApplicationController
  include ConfigurablePagination

  before_action :set_vendor, only: [:show, :edit, :update, :destroy, :toggle_status, :activate, :deactivate]

  # GET /admin/vendors
  def index
    # Whole-table stats — cached briefly (bumped immediately on any vendor
    # write) to avoid a DB round trip on every single page load.
    cache_gen = Rails.cache.read("vendor_cache_gen") || "0"
    stats = Rails.cache.fetch("vendor_statistics_#{cache_gen}", expires_in: 5.minutes) do
      row = ActiveRecord::Base.connection.execute(<<~SQL).first
        SELECT
          COUNT(*)                             AS total,
          COUNT(*) FILTER (WHERE status = 0)   AS active_count,
          COUNT(*) FILTER (WHERE status = 1)   AS inactive_count
        FROM vendors
      SQL
      { total: row['total'].to_i, active_count: row['active_count'].to_i, inactive_count: row['inactive_count'].to_i }
    end
    @total_vendors    = stats[:total]
    @active_vendors   = stats[:active_count]
    @inactive_vendors = stats[:inactive_count]

    # The filtered/sorted/paginated page (with its products preloaded via a
    # single JOIN, no N+1) is cached as one unit per unique filter+page
    # combination, so repeat views skip the DB entirely.
    page_cache_key = [
      "vendors_page_v1", cache_gen, per_page_param, params[:page], params[:search], params[:status]
    ].join('|')

    page_bundle = Rails.cache.fetch(page_cache_key, expires_in: 5.minutes) do
      scope = Vendor.eager_load(:vendor_products)
      scope = scope.search_by_name_company_contact(params[:search]) if params[:search].present?
      case params[:status]
      when 'active'   then scope = scope.active
      when 'inactive' then scope = scope.inactive
      end

      total_filtered_count = scope.count
      paginated = paginate_records(scope.order(created_at: :desc), total_filtered_count)

      {
        records: paginated.to_a,
        total_filtered_count: total_filtered_count,
        total_record_count: @total_record_count,
        items_per_page: @items_per_page,
        show_pagination: @show_pagination
      }
    end

    @vendors               = Kaminari.paginate_array(page_bundle[:records], total_count: page_bundle[:total_record_count])
                                      .page(params[:page]).per(page_bundle[:items_per_page])
    @total_filtered_count  = page_bundle[:total_filtered_count]
    @total_record_count    = page_bundle[:total_record_count]
    @items_per_page        = page_bundle[:items_per_page]
    @show_pagination       = page_bundle[:show_pagination]
  end

  # GET /admin/vendors/1
  def show
  end

  # GET /admin/vendors/new
  def new
    @vendor = Vendor.new
  end

  # GET /admin/vendors/1/edit
  def edit
  end

  # POST /admin/vendors
  def create
    @vendor = Vendor.new(vendor_params)
    assign_products(@vendor)

    if @vendor.save
      redirect_to admin_vendors_path, notice: 'Vendor was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/vendors/1
  def update
    @vendor.assign_attributes(vendor_params)

    if @vendor.save
      assign_products(@vendor)
      redirect_to admin_vendors_path, notice: 'Vendor was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/vendors/1
  def destroy
    @vendor.destroy
    redirect_to admin_vendors_path, notice: 'Vendor was successfully deleted.'
  rescue => e
    redirect_to admin_vendors_path, alert: "Failed to delete vendor: #{e.message}"
  end

  # PATCH /admin/vendors/1/toggle_status
  def toggle_status
    new_status = @vendor.active? ? :inactive : :active
    if @vendor.update(status: new_status)
      redirect_to admin_vendors_path, notice: "Vendor status updated to #{new_status}."
    else
      redirect_to admin_vendors_path, alert: 'Failed to update status.'
    end
  end

  # PATCH /admin/vendors/1/activate
  def activate
    if @vendor.update(status: :active)
      redirect_to admin_vendors_path, notice: 'Vendor was successfully activated.'
    else
      redirect_to admin_vendors_path, alert: 'Failed to activate vendor.'
    end
  end

  # PATCH /admin/vendors/1/deactivate
  def deactivate
    if @vendor.update(status: :inactive)
      redirect_to admin_vendors_path, notice: 'Vendor was successfully deactivated.'
    else
      redirect_to admin_vendors_path, alert: 'Failed to deactivate vendor.'
    end
  end

  private

  def set_vendor
    @vendor = Vendor.includes(:vendor_products).find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(:name, :company_name, :email, :phone_number, :address, :gst_number, :notes, :status)
  end

  # Builds/replaces this vendor's product + commission selections from the
  # multiselect dropdown and per-product commission inputs submitted by the
  # form. Runs as a single wholesale collection replace (one delete-set +
  # one batch insert), not one query per product.
  def assign_products(vendor)
    selections  = Array(params.dig(:vendor, :product_selections)).reject(&:blank?).uniq
    commissions = params.dig(:vendor, :product_commissions) || {}

    new_products = selections.filter_map do |key|
      category, subcategory = key.split('::', 2)
      next if category.blank? || subcategory.blank?
      next unless Vendor::PRODUCT_TAXONOMY[category]&.include?(subcategory)

      commission = commissions[key].to_f.clamp(0, 100)

      VendorProduct.new(
        product_category: category,
        product_subcategory: subcategory,
        commission_percentage: commission
      )
    end

    vendor.vendor_products = new_products
  end
end
