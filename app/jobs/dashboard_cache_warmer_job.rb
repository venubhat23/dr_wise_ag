class DashboardCacheWarmerJob < ApplicationJob
  queue_as :default

  def perform
    # Preload dashboard cache for common date ranges
    Rails.logger.info "[DashboardCache] Starting cache warming at #{Time.current}"

    start_time = Time.current
    current_year = Date.current.year

    # Warm up cache for common filters
    # NOTE: `N.months.ago` returns a Time, not a Date — must call .to_date so
    # every range here is a plain Date, matching both what the controller
    # produces for real user filters (Date.parse / Date.new, never Time) and
    # what Date arithmetic in calculate_growth_metrics_for_period expects.
    # Mixing Date and Time there raises TypeError: expected numeric.
    filters_to_warm = [
      # Current year
      [Date.new(current_year, 1, 1), Date.new(current_year, 12, 31)],
      # Current month
      [Date.current.beginning_of_month, Date.current.end_of_month],
      # Last month
      [1.month.ago.to_date.beginning_of_month, 1.month.ago.to_date.end_of_month],
      # Last 3 months
      [3.months.ago.to_date.beginning_of_month, Date.current.end_of_month]
    ]

    dashboard_controller = DashboardController.new
    cache_gen = Rails.cache.read("dashboard_cache_gen") || "0"

    filters_to_warm.each do |start_date, end_date|
      # Must match the cache key format in DashboardController#load_dashboard_data
      # exactly (including the _v7 suffix) or this warms a key nobody reads.
      cache_key = "dashboard_data_#{cache_gen}_#{start_date}_#{end_date}_v7"

      unless Rails.cache.exist?(cache_key)
        Rails.logger.info "[DashboardCache] Warming cache for #{start_date} to #{end_date}"
        Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          dashboard_controller.send(:get_filtered_dashboard_data, start_date, end_date)
        end
      end
    rescue => e
      # One bad range must not abort the whole job — filter-independent
      # warming below still needs to run regardless.
      Rails.logger.error "[DashboardCache] Failed warming #{start_date}..#{end_date}: #{e.message}"
    end

    # Warm up filter-independent data — must match the _v4 suffix used in
    # DashboardController#load_dashboard_data.
    filter_independent_cache_key = "dashboard_filter_independent_#{Date.current}_v4"
    unless Rails.cache.exist?(filter_independent_cache_key)
      Rails.logger.info "[DashboardCache] Warming filter-independent cache"
      Rails.cache.fetch(filter_independent_cache_key, expires_in: 4.minutes) do
        dashboard_controller.send(:load_filter_independent_data)
      end
    end

    # Warm the Admin::Analytics page too — it reuses the same cache_gen and
    # the same common date ranges, and its cold path is just as expensive
    # (~100 queries) as the dashboard's.
    analytics_controller = Admin::AnalyticsController.new

    filters_to_warm.each do |start_date, end_date|
      # Must match the cache key format in Admin::AnalyticsController#load_filtered_analytics_data
      # exactly (including the _v2 suffix) or this warms a key nobody reads.
      cache_key = "analytics_filtered_data_#{cache_gen}_#{start_date}_#{end_date}_v2"

      unless Rails.cache.exist?(cache_key)
        Rails.logger.info "[DashboardCache] Warming analytics cache for #{start_date} to #{end_date}"
        Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          analytics_controller.send(:get_filtered_analytics_data, start_date, end_date)
        end
      end
    rescue => e
      Rails.logger.error "[DashboardCache] Failed warming analytics #{start_date}..#{end_date}: #{e.message}"
    end

    # Analytics' period-independent data (investors, agent performance/commission,
    # customer retention) — must match the _v1 suffix used in
    # Admin::AnalyticsController#load_filtered_analytics_data.
    analytics_independent_cache_key = "analytics_period_independent_data_#{cache_gen}_v1"
    unless Rails.cache.exist?(analytics_independent_cache_key)
      Rails.logger.info "[DashboardCache] Warming analytics period-independent cache"
      Rails.cache.fetch(analytics_independent_cache_key, expires_in: 5.minutes) do
        analytics_controller.send(:get_period_independent_analytics_data)
      end
    end

    duration = Time.current - start_time
    Rails.logger.info "[DashboardCache] Cache warmed successfully in #{duration.round(2)} seconds"

    # Recurring cadence is handled by config/recurring.yml (dashboard_cache_warmer)
    { success: true, duration: duration }
  rescue => e
    Rails.logger.error "[DashboardCache] Cache warming failed: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end
end