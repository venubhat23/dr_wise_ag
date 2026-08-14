class Vendor < ApplicationRecord
  include PgSearch::Model

  has_many :vendor_products, dependent: :destroy, inverse_of: :vendor
  accepts_nested_attributes_for :vendor_products, allow_destroy: true

  has_many :client_services, dependent: :nullify
  has_many :mutual_funds, dependent: :nullify
  has_many :leads, dependent: :nullify
  has_many :vendor_payouts, dependent: :destroy

  after_commit :bump_vendor_cache_gen
  before_validation :normalize_phone_number

  enum :status, { active: 0, inactive: 1 }

  PRODUCT_TAXONOMY = {
    'Insurance'   => ['Life', 'Health', 'Motor', 'General'],
    'Investments' => ['Mutual Fund', 'FD', 'Other'],
    'Taxation'    => ['ITR', 'Tax Planning'],
    'Loans'       => ['Personal', 'Home', 'Mortgage', 'Business'],
    'Travel'      => ['Domestic', 'International'],
    'Credit Card' => ['Rewards Card', 'Business Card', 'Travel Card']
  }.freeze

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number,
            presence: true,
            format: {
              with: /\A\d{10}\z/,
              message: "must be a valid 10-digit phone number"
            }

  pg_search_scope :search_by_name_company_contact,
                  against: [:name, :company_name, :email, :phone_number, :gst_number],
                  using: { tsearch: { prefix: true } }

  # Vendors who offer this exact product, for populating a filtered vendor
  # dropdown on a product's create/edit form.
  def self.for_product(category, subcategory)
    return none if category.blank? || subcategory.blank?

    active.joins(:vendor_products)
          .where(vendor_products: { product_category: category, product_subcategory: subcategory })
          .distinct
          .order(:name)
  end

  def display_name
    name.presence || company_name.presence || "Vendor ##{id}"
  end

  def products_summary
    vendor_products.map { |vp| "#{vp.product_category} - #{vp.product_subcategory}" }
  end

  private

  # Strips formatting (spaces, dashes, +91 country code) so users can paste
  # numbers like "+91 98765 43210" and still pass the 10-digit validation.
  def normalize_phone_number
    return if phone_number.blank?

    digits = phone_number.gsub(/\D/, '')
    digits = digits.last(10) if digits.length > 10
    self.phone_number = digits
  end

  # Dedicated cache generation for the vendors list/stats cache (see
  # Admin::VendorsController#index) — bumped on every write so a newly
  # created/edited vendor shows up immediately instead of waiting out the TTL.
  def bump_vendor_cache_gen
    VendorCacheGen.bump!
  end
end
