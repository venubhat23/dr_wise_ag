class DashboardCacheWarmerJob < ApplicationJob
  queue_as :default

  def perform
    # Preload dashboard cache
    Rails.logger.info "[DashboardCache] Starting cache warming at #{Time.current}"

    start_time = Time.current
    stats = DashboardUltraFastService.preload_cache!

    duration = Time.current - start_time
    Rails.logger.info "[DashboardCache] Cache warmed successfully in #{duration.round(2)} seconds"

    # Schedule next run in 5 minutes
    DashboardCacheWarmerJob.set(wait: 5.minutes).perform_later

    stats
  rescue => e
    Rails.logger.error "[DashboardCache] Cache warming failed: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")

    # Retry in 1 minute if failed
    DashboardCacheWarmerJob.set(wait: 1.minute).perform_later
  end
end