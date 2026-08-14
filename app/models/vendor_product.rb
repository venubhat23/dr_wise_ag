class VendorProduct < ApplicationRecord
  belongs_to :vendor, inverse_of: :vendor_products

  after_commit :bump_vendor_cache_gen

  validates :product_category, presence: true, inclusion: { in: Vendor::PRODUCT_TAXONOMY.keys }
  validates :product_subcategory, presence: true,
            uniqueness: { scope: [:vendor_id, :product_category], message: "is already assigned to this vendor" }
  validates :commission_percentage,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
            allow_nil: true
  validate :subcategory_belongs_to_category

  def product_label
    "#{product_category} - #{product_subcategory}"
  end

  private

  def subcategory_belongs_to_category
    return if product_category.blank? || product_subcategory.blank?

    valid_subcategories = Vendor::PRODUCT_TAXONOMY[product_category] || []
    unless valid_subcategories.include?(product_subcategory)
      errors.add(:product_subcategory, "is not a valid subcategory for #{product_category}")
    end
  end

  def bump_vendor_cache_gen
    VendorCacheGen.bump!
  end
end
