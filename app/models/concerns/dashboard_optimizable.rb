module DashboardOptimizable
  extend ActiveSupport::Concern

  included do
    after_commit :clear_dashboard_cache

    # Common scopes for all insurance models
    scope :with_customer, -> { includes(:customer) }
    scope :recent, ->(limit = 10) { order(created_at: :desc).limit(limit) }
    scope :in_date_range, ->(start_date, end_date) { where(created_at: start_date..end_date) }
    scope :expiring_soon, ->(days = 30) { where('policy_end_date BETWEEN ? AND ?', Date.current, Date.current + days.days) }
    scope :expired, -> { where('policy_end_date < ?', Date.current) }
    scope :active, -> { where('policy_end_date >= ?', Date.current) }
    scope :by_policy_type, ->(type) { where(policy_type: type) }

    # Optimized sum methods
    def self.sum_premium_in_range(start_date, end_date)
      where(created_at: start_date..end_date).sum(:total_premium) || 0
    end

    def self.sum_insured_in_range(start_date, end_date)
      where(created_at: start_date..end_date).sum(:sum_insured) || 0
    end

    # Batch loading for dashboard
    def self.dashboard_stats
      {
        total_count: count,
        total_premium: sum(:total_premium) || 0,
        total_sum_insured: sum(:sum_insured) || 0,
        active_count: active.count,
        expired_count: expired.count,
        expiring_soon_count: expiring_soon.count
      }
    end

    # Optimized recent policies with customer preload
    def self.recent_with_customer(limit = 10)
      includes(:customer)
        .order(created_at: :desc)
        .limit(limit)
        .select(:id, :policy_number, :total_premium, :created_at, :customer_id)
    end
  end

  # Throttled: this runs after_commit on every single insurance write, and
  # dashboard_cache_gen is global (shared across all users/date ranges), so an
  # unconditional bump here effectively disabled the 5-minute dashboard/analytics
  # cache TTL on any actively-used system - every write anywhere forced every
  # other user's next request back onto the slow uncached path. Capping bumps to
  # once per 30s keeps the cache reasonably fresh while letting it actually serve
  # hits between writes.
  def clear_dashboard_cache
    last_bump = Rails.cache.read("dashboard_cache_gen_bumped_at")
    return if last_bump && last_bump > 30.seconds.ago

    Rails.cache.write("dashboard_cache_gen", SecureRandom.hex(4))
    Rails.cache.write("dashboard_cache_gen_bumped_at", Time.current)
  rescue => e
    Rails.logger.warn "Failed to clear dashboard cache: #{e.message}"
  end

  class_methods do
    # Class method for getting renewal counts efficiently
    def renewal_due_between(start_date, end_date)
      where('policy_end_date BETWEEN ? AND ?', start_date, end_date).count
    end

    # Efficient counting by status
    def count_by_status
      group(:status).count
    end

    # Precompiled query for dashboard metrics
    def dashboard_metrics
      connection.select_all(
        sanitize_sql_array([
          "SELECT
            COUNT(*) as total_count,
            COUNT(CASE WHEN policy_end_date >= ? THEN 1 END) as active_count,
            COUNT(CASE WHEN policy_end_date < ? THEN 1 END) as expired_count,
            COUNT(CASE WHEN policy_end_date BETWEEN ? AND ? THEN 1 END) as expiring_soon_count,
            COALESCE(SUM(total_premium), 0) as total_premium,
            COALESCE(SUM(sum_insured), 0) as total_sum_insured
          FROM #{table_name}",
          Date.current,
          Date.current,
          Date.current,
          Date.current + 30.days
        ])
      ).first
    end
  end
end