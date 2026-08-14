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
    cache_gen = Rails.cache.read("vendor_cache_gen") || "0"
    stats = Rails.cache.fetch("vendor_show_stats_#{@vendor.id}_#{cache_gen}", expires_in: 2.minutes) do
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

    @vendor_user = User.find_by(email: @vendor.email) if @vendor.email.present?
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
      generated_password = create_vendor_user_account(@vendor)
      notice = 'Vendor was successfully created.'
      notice += " Login: #{@vendor.email} / #{generated_password}" if generated_password
      redirect_to admin_vendors_path, notice: notice
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/vendors/1
  def update
    @vendor.assign_attributes(vendor_params)

    if @vendor.save
      assign_products(@vendor)
      generated_password = create_vendor_user_account(@vendor)
      notice = 'Vendor was successfully updated.'
      notice += " Login: #{@vendor.email} / #{generated_password}" if generated_password
      redirect_to admin_vendors_path, notice: notice
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

  # Provisions the paired login User for this vendor (mirrors
  # Admin::DistributorsController#create_ambassador_user_account). Matched by
  # email at login time, not a stored FK — same convention as Ambassador.
  # Returns the generated plaintext password (to flash once to the admin), or
  # nil if no account was created (no email, or one already exists).
  def create_vendor_user_account(vendor)
    return unless vendor&.email.present?
    return if User.exists?(email: vendor.email)

    vendor_role = Role.find_by(name: 'vendor') || Role.find_by(name: 'Vendor')
    vendor_user_role = UserRole.find_by(name: 'Vendor')
    password = generate_vendor_password

    name_parts = vendor.name.to_s.split(' ', 2)
    User.create!(
      first_name: name_parts[0].presence || 'Vendor',
      last_name: name_parts[1].presence || 'User',
      email: vendor.email,
      password: password,
      password_confirmation: password,
      mobile: vendor.phone_number,
      user_type: 'vendor',
      role: vendor_role,
      user_role: vendor_user_role,
      status: true,
      original_password: password
    )
    password
  rescue => e
    Rails.logger.error "Failed to create vendor user account for vendor ##{vendor.id}: #{e.message}"
    nil
  end

  def generate_vendor_password
    words = ['Blue', 'Green', 'Red', 'Happy', 'Smart', 'Quick', 'Bright', 'Swift']
    "#{words.sample}#{words.sample}#{(100..999).to_a.sample}"
  end
end
