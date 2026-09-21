module LeadProductsHelper
  # [[label, value], ...] for the main product filter, in the same order and
  # spelling as Vendor::PRODUCT_TAXONOMY.
  def lead_product_category_options
    Lead::LEAD_PRODUCT_TO_VENDOR_PRODUCT
      .map { |(category, _sub), (category_label, _sub_label)| [category_label, category] }
      .uniq
  end

  def lead_product_category_label(lead)
    Lead::LEAD_PRODUCT_TO_VENDOR_PRODUCT.dig([lead.product_category, lead.product_subcategory], 0) ||
      lead.product_category&.humanize || 'N/A'
  end

  def lead_product_subcategory_label(lead)
    Lead::LEAD_PRODUCT_TO_VENDOR_PRODUCT.dig([lead.product_category, lead.product_subcategory], 1) ||
      lead.product_subcategory&.humanize
  end

  # The admin list page for this lead's product (same pages as the sidebar).
  # nil when the product has no service page (e.g. legacy insurance travel/other).
  def lead_service_path(lead)
    category = lead.product_category
    sub = lead.product_subcategory
    return nil if category.blank? || sub.blank?

    if category == 'insurance'
      case sub
      when 'life'    then admin_life_insurances_path
      when 'health'  then admin_health_insurances_path
      when 'motor'   then admin_motor_insurances_path
      when 'general' then admin_other_insurances_path
      end
    elsif category == 'investments' && sub == 'mutual_fund'
      admin_mutual_funds_path
    else
      service_type = "#{category}_#{sub}"
      admin_client_services_path(service_type: service_type) if ClientService::SERVICE_TYPES.key?(service_type)
    end
  end

  # Main product badge plus a sub product badge that links to the service page.
  def lead_product_badges(lead, category_class: 'bg-info text-white', sub_class: 'bg-light text-dark border')
    sub_label = lead_product_subcategory_label(lead)
    badges = [content_tag(:span, lead_product_category_label(lead), class: "badge #{category_class}")]

    if sub_label.present?
      path = lead_service_path(lead)
      badges << if path
        link_to sub_label, path, class: "badge #{sub_class} text-decoration-none",
                title: "Open #{lead_product_category_label(lead)} / #{sub_label}"
      else
        content_tag(:span, sub_label, class: "badge #{sub_class}")
      end
    end

    safe_join(badges, ' ')
  end
end
