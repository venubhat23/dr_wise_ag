class SystemSetting < ApplicationRecord
  validates :key, presence: true, uniqueness: true
  validates :value, presence: true
  validates :setting_type, presence: true

  after_commit :clear_settings_cache

  # All the scalar settings (percentage, pagination, investment amount, ...) are
  # each stored as their own row and were each fetched with a separate
  # find_by(key:) query. On top of that, every "system_config" getter
  # (commissions, terms, company info) re-ran the identical find_by(key:
  # 'system_config') query. That's ~9 round trips per settings page load.
  # Cache the full key => row map for a short time and serve every getter
  # from it instead.
  def self.cached_settings(expires_in: 5.minutes)
    Rails.cache.fetch('system_settings/all', expires_in: expires_in) do
      all.index_by(&:key)
    end
  end

  def self.cached_setting(key)
    cached_settings[key]
  end

  # Class method to get a setting value by key
  def self.get_value(key)
    cached_setting(key)&.value
  end

  # Class method to set a setting value by key
  def self.set_value(key, value, description: nil, setting_type: 'string')
    setting = find_or_initialize_by(key: key)
    setting.value = value
    setting.description = description if description
    setting.setting_type = setting_type
    setting.save!
    setting
  end

  # Get company expenses percentage as float
  def self.company_expenses_percentage
    value = get_value('company_expenses_percentage')
    value ? value.to_f : 2.0
  end

  # Set company expenses percentage
  def self.set_company_expenses_percentage(percentage)
    set_value(
      'company_expenses_percentage',
      percentage.to_s,
      description: 'Company expenses percentage that can be configured by admin',
      setting_type: 'percentage'
    )
  end

  # Get default pagination per page as integer
  def self.default_pagination_per_page
    value = get_value('default_pagination_per_page')
    value ? value.to_i : 10
  end

  # Set default pagination per page
  def self.set_default_pagination_per_page(per_page)
    set_value(
      'default_pagination_per_page',
      per_page.to_s,
      description: 'Default number of records per page for all index pages',
      setting_type: 'integer'
    )
  end

  # Commission methods for new columns

  # Get default main agent commission as float
  def self.default_main_agent_commission
    setting = cached_setting('system_config')
    setting&.default_main_agent_commission || 0.0
  end

  # Get default affiliate commission as float
  def self.default_affiliate_commission
    setting = cached_setting('system_config')
    setting&.default_affiliate_commission || 0.0
  end

  # Get default ambassador commission as float
  def self.default_ambassador_commission
    setting = cached_setting('system_config')
    setting&.default_ambassador_commission || 0.0
  end

  # Get default company expenses as float
  def self.default_company_expenses
    setting = cached_setting('system_config')
    setting&.default_company_expenses || 0.0
  end

  # Update commission values
  def self.update_commission_settings(params)
    # Create a default setting if none exists
    setting = find_by(key: 'system_config') || create!(
      key: 'system_config',
      value: 'system configuration',
      setting_type: 'configuration',
      description: 'System configuration settings'
    )

    setting.update!(
      default_main_agent_commission: params[:default_main_agent_commission],
      default_affiliate_commission: params[:default_affiliate_commission],
      default_ambassador_commission: params[:default_ambassador_commission],
      default_company_expenses: params[:default_company_expenses]
    )
  end

  # Get terms and conditions
  def self.terms_and_conditions
    setting = cached_setting('system_config')
    setting&.terms_and_conditions || ''
  end

  # Set terms and conditions
  def self.set_terms_and_conditions(content)
    setting = find_by(key: 'system_config') || create!(
      key: 'system_config',
      value: 'system configuration',
      setting_type: 'configuration',
      description: 'System configuration settings'
    )

    setting.update!(terms_and_conditions: content)
  end

  # ─── Company Info ────────────────────────────────────────────────────────────

  def self.company_info
    setting = cached_setting('system_config')
    {
      name:          (setting&.has_attribute?('company_name')    ? setting.company_name    : nil) || 'Drwise Admin',
      mobile:        (setting&.has_attribute?('company_phone')   ? setting.company_phone   : nil) || '+918431174477',
      email:         (setting&.has_attribute?('company_email')   ? setting.company_email   : nil) || 'support@dr-wise.in',
      address:       (setting&.has_attribute?('company_address') ? setting.company_address : nil) || '123 Insurance Street, Mumbai, Maharashtra, India',
      website:       get_value('company_website') || 'www.dr-wise.in',
      support_hours: get_value('support_hours')   || 'Monday to Friday: 9:00 AM - 6:00 PM'
    }
  rescue => e
    Rails.logger.error "Failed to load company info: #{e.message}"
    { name: 'Drwise Admin', mobile: '+918431174477', email: 'support@dr-wise.in', address: '123 Insurance Street, Mumbai, Maharashtra, India', website: 'www.dr-wise.in', support_hours: 'Monday to Friday: 9:00 AM - 6:00 PM' }
  end

  def self.update_company_info(params)
    setting = find_by(key: 'system_config') || create!(
      key: 'system_config',
      value: 'system configuration',
      setting_type: 'configuration',
      description: 'System configuration settings'
    )

    attrs = {}
    attrs[:company_name]    = params[:company_name]    if setting.has_attribute?('company_name')
    attrs[:company_phone]   = params[:company_mobile]  if setting.has_attribute?('company_phone')
    attrs[:company_email]   = params[:company_email]   if setting.has_attribute?('company_email')
    attrs[:company_address] = params[:company_address] if setting.has_attribute?('company_address')
    setting.update!(attrs) if attrs.any?

    set_value('company_website', params[:company_website], description: 'Company website URL', setting_type: 'string') if params[:company_website].present?
    set_value('support_hours', params[:support_hours], description: 'Customer support hours', setting_type: 'string') if params[:support_hours].present?
  end

  # ─── Investment Amount ────────────────────────────────────────────────────────

  # Get investment amount
  def self.investment_amount
    setting = cached_setting('system_config')
    (setting&.has_attribute?('investment_amount') ? setting.investment_amount : nil) ||
      get_value('investment_amount')&.to_f || 0.0
  rescue => e
    Rails.logger.error "Failed to load investment amount: #{e.message}"
    0.0
  end

  # Set investment amount
  def self.set_investment_amount(amount)
    setting = find_by(key: 'system_config') || create!(
      key: 'system_config',
      value: 'system configuration',
      setting_type: 'configuration',
      description: 'System configuration settings'
    )

    if setting.has_attribute?('investment_amount')
      setting.update!(investment_amount: amount)
    else
      set_value('investment_amount', amount.to_s, description: 'Investment amount', setting_type: 'decimal')
    end
  end

  private

  def clear_settings_cache
    Rails.cache.delete('system_settings/all')
  end
end
