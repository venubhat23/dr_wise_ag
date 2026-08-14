class ClientService < ApplicationRecord
  belongs_to :customer
  belongs_to :sub_agent, class_name: 'SubAgent', optional: true
  belongs_to :distributor, optional: true
  belongs_to :vendor, optional: true

  STATUSES = %w[pending in_progress completed cancelled].freeze

  # Vendor-facing stage names for the same STATUSES values above — the
  # underlying column values are unchanged, only how they're displayed and
  # how transitions between them are gated.
  STATUS_LABELS = {
    'pending'     => 'Lead Generated',
    'in_progress' => 'Consultation',
    'completed'   => 'Lead Closed Successfully',
    'cancelled'   => 'Lead Cancelled'
  }.freeze

  # Which stages a record can move to next, from its current stage.
  STATUS_TRANSITIONS = {
    'pending'     => %w[in_progress cancelled],
    'in_progress' => %w[completed cancelled],
    'completed'   => [],
    'cancelled'   => []
  }.freeze

  # Maps each service_type to the [Vendor::PRODUCT_TAXONOMY category, subcategory]
  # pair it corresponds to, so the vendor dropdown can be filtered to only
  # vendors who actually offer this exact product.
  SERVICE_TYPE_TO_VENDOR_PRODUCT = {
    'taxation_itr'              => ['Taxation', 'ITR'],
    'taxation_tax_planning'     => ['Taxation', 'Tax Planning'],
    'loans_personal'            => ['Loans', 'Personal'],
    'loans_home'                => ['Loans', 'Home'],
    'loans_mortgage'            => ['Loans', 'Mortgage'],
    'loans_business'            => ['Loans', 'Business'],
    'travel_domestic'           => ['Travel', 'Domestic'],
    'travel_international'      => ['Travel', 'International'],
    'credit_card_rewards'       => ['Credit Card', 'Rewards Card'],
    'credit_card_business'      => ['Credit Card', 'Business Card'],
    'credit_card_travel'        => ['Credit Card', 'Travel Card'],
    'investments_mutual_fund'   => ['Investments', 'Mutual Fund'],
    'investments_fd'            => ['Investments', 'FD'],
    'investments_other'         => ['Investments', 'Other']
  }.freeze

  SERVICE_TYPES = {
    'taxation_itr'              => 'ITR Filing',
    'taxation_tax_planning'     => 'Tax Planning',
    'loans_personal'            => 'Personal Loan',
    'loans_home'                => 'Home Loan',
    'loans_mortgage'            => 'Mortgage Loan',
    'loans_business'            => 'Business Loan',
    'travel_domestic'           => 'Domestic Travel',
    'travel_international'      => 'International Travel',
    'credit_card_rewards'       => 'Rewards Card',
    'credit_card_business'      => 'Business Card',
    'credit_card_travel'        => 'Travel Card',
    'investments_mutual_fund'   => 'Mutual Fund',
    'investments_fd'            => 'Fixed Deposit (FD)',
    'investments_other'         => 'Other Investment'
  }.freeze

  CATEGORY_LABELS = {
    'taxation'     => 'Taxation',
    'loans'        => 'Loans',
    'travel'       => 'Travel',
    'credit_card'  => 'Credit Card',
    'investments'  => 'Investments'
  }.freeze

  CATEGORY_ICONS = {
    'taxation'    => 'bi-calculator',
    'loans'       => 'bi-cash-stack',
    'travel'      => 'bi-airplane',
    'credit_card' => 'bi-credit-card',
    'investments' => 'bi-graph-up'
  }.freeze

  TYPES_BY_CATEGORY = {
    'taxation'    => %w[taxation_itr taxation_tax_planning],
    'loans'       => %w[loans_personal loans_home loans_mortgage loans_business],
    'travel'      => %w[travel_domestic travel_international],
    'credit_card' => %w[credit_card_rewards credit_card_business credit_card_travel],
    'investments' => %w[investments_mutual_fund investments_fd investments_other]
  }.freeze

  validates :customer_id, presence: true
  validates :service_type, presence: true, inclusion: { in: SERVICE_TYPES.keys }
  validates :service_category, presence: true, inclusion: { in: CATEGORY_LABELS.keys }
  validates :status, inclusion: { in: STATUSES }

  before_validation :set_category_from_type
  before_save :calculate_vendor_commission
  before_save :calculate_commission_structure
  before_update :update_status_timestamp, if: :status_changed?
  after_update :create_vendor_payout_on_completion,
               if: -> { vendor_id.present? && saved_change_to_status? && status == 'completed' }
  after_commit :bump_vendor_cache_gen, if: -> { vendor_id.present? }

  scope :by_type,     ->(t) { where(service_type: t) }
  scope :by_category, ->(c) { where(service_category: c) }

  def service_type_label
    SERVICE_TYPES[service_type] || service_type.humanize
  end

  def category_label
    CATEGORY_LABELS[service_category] || service_category.humanize
  end

  def status_display_name
    STATUS_LABELS[status] || status.humanize
  end

  def status_badge_class
    case status
    when 'pending'     then 'bg-secondary'
    when 'in_progress' then 'bg-info'
    when 'completed'   then 'bg-success'
    when 'cancelled'   then 'bg-danger'
    else 'bg-light text-dark'
    end
  end

  # Stages this record can move to next from its current status, for
  # rendering a "Move To" control the same way Lead does.
  def next_status_options
    STATUS_TRANSITIONS[status] || []
  end

  # Translates this record's service_type to the vendor-product taxonomy
  # pair used to look up the vendor's configured commission percentage.
  def vendor_product_key
    SERVICE_TYPE_TO_VENDOR_PRODUCT[service_type]
  end

  # The VendorProduct matching this service's vendor + service_type, if any —
  # its commission_percentage is what the vendor pays DrWise, and the base
  # the internal Main Agent/Affiliate/Ambassador/Investor/Company split is
  # calculated against (same role each product's net_premium plays for
  # insurance).
  def matched_vendor_product
    return nil unless vendor_id.present?

    category, subcategory = vendor_product_key
    return nil unless category && subcategory

    vendor.vendor_products.find_by(product_category: category, product_subcategory: subcategory)
  end

  private

  def update_status_timestamp
    self.status_updated_at = Time.current
  end

  def calculate_vendor_commission
    vendor_product = matched_vendor_product

    if vendor_product
      self.vendor_commission_percentage = vendor_product.commission_percentage.to_f
      self.vendor_commission_amount = (amount.to_f * vendor_commission_percentage.to_f / 100.0).round(2)
    else
      self.vendor_commission_percentage = 0
      self.vendor_commission_amount = 0
    end
  end

  # Splits DrWise's vendor_commission_amount (not the raw service amount)
  # across Main Agent/Affiliate/Ambassador/Investor/Company — same
  # independent-percentage-of-base pattern HealthInsurance uses against
  # net_premium. The form's JS mirrors this for a live preview; this is the
  # authoritative calculation run on every save.
  def calculate_commission_structure
    base = vendor_commission_amount.to_f

    self.main_agent_commission_percentage ||= 0
    self.commission_amount = (base * main_agent_commission_percentage.to_f / 100.0).round(2)
    self.tds_percentage ||= 0
    self.tds_amount = (commission_amount.to_f * tds_percentage.to_f / 100.0).round(2)
    self.after_tds_value = (commission_amount.to_f - tds_amount.to_f).round(2)

    self.sub_agent_commission_percentage ||= 0
    self.sub_agent_commission_amount = (base * sub_agent_commission_percentage.to_f / 100.0).round(2)
    self.sub_agent_tds_percentage ||= 0
    self.sub_agent_tds_amount = (sub_agent_commission_amount.to_f * sub_agent_tds_percentage.to_f / 100.0).round(2)
    self.sub_agent_after_tds_value = (sub_agent_commission_amount.to_f - sub_agent_tds_amount.to_f).round(2)

    self.distributor_commission_percentage ||= 0
    self.distributor_commission_amount = (base * distributor_commission_percentage.to_f / 100.0).round(2)
    self.distributor_tds_percentage ||= 0
    self.distributor_tds_amount = (distributor_commission_amount.to_f * distributor_tds_percentage.to_f / 100.0).round(2)
    self.distributor_after_tds_value = (distributor_commission_amount.to_f - distributor_tds_amount.to_f).round(2)

    self.investor_commission_percentage ||= 0
    self.investor_commission_amount = (base * investor_commission_percentage.to_f / 100.0).round(2)

    self.company_expenses_percentage ||= 0
    self.company_expenses_amount = (base * company_expenses_percentage.to_f / 100.0).round(2)

    self.total_distribution_percentage = (
      sub_agent_commission_percentage.to_f +
      distributor_commission_percentage.to_f +
      investor_commission_percentage.to_f
    ).round(2)

    self.profit_percentage = (
      main_agent_commission_percentage.to_f - total_distribution_percentage.to_f - company_expenses_percentage.to_f
    ).round(2)
    self.profit_amount = (base * profit_percentage.to_f / 100.0).round(2)
  end

  def create_vendor_payout_on_completion
    return if VendorPayout.exists?(client_service_id: id)

    vendor_product = matched_vendor_product
    unless vendor_product
      Rails.logger.warn "ClientService ##{id}: completed with vendor_id=#{vendor_id} but no matching VendorProduct for #{service_type}, skipping VendorPayout"
      return
    end

    VendorPayout.create!(
      vendor: vendor,
      client_service: self,
      lead_value: amount.to_f,
      commission_percentage: vendor_product.commission_percentage.to_f,
      commission_amount: vendor_commission_amount.to_f
    )
  rescue => e
    Rails.logger.error "Failed to create VendorPayout for client_service ##{id}: #{e.message}"
  end

  def bump_vendor_cache_gen
    VendorCacheGen.bump!
  end

  def set_category_from_type
    return if service_type.blank?
    self.service_category = service_type.split('_').first == 'credit' ? 'credit_card' : service_type.split('_').first
    # handle credit_card prefix
    TYPES_BY_CATEGORY.each do |cat, types|
      self.service_category = cat if types.include?(service_type)
    end
  end
end
