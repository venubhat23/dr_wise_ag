module Admin
  module Reports
    class SessionsController < ApplicationController
      before_action :authenticate_user!

      def index
        # Set timezone to India
        Time.zone = 'Asia/Kolkata'

        # Active users (sessions within last 30 minutes)
        @active_users = Ahoy::Visit.where("started_at > ?", 30.minutes.ago).count

        # Today's sessions (India time)
        @today_sessions = Ahoy::Visit.where(started_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count

        # This week's sessions
        @week_sessions = Ahoy::Visit.where(started_at: 1.week.ago..Time.zone.now).count

        # This month's sessions
        @month_sessions = Ahoy::Visit.where(started_at: 1.month.ago..Time.zone.now).count

        # Sessions over time (last 30 days)
        @sessions_over_time = Ahoy::Visit
          .where(started_at: 30.days.ago..Time.zone.now)
          .group_by_day(:started_at, time_zone: 'Asia/Kolkata')
          .count

        # Device breakdown
        @device_breakdown = Ahoy::Visit
          .where(started_at: 30.days.ago..Time.zone.now)
          .group(:device_type)
          .count

        # Browser breakdown
        @browser_breakdown = Ahoy::Visit
          .where(started_at: 30.days.ago..Time.zone.now)
          .group(:browser)
          .count

        # Operating System breakdown
        @os_breakdown = Ahoy::Visit
          .where(started_at: 30.days.ago..Time.zone.now)
          .group(:os)
          .count

        # Top pages (most visited)
        @top_pages = Ahoy::Event
          .where(name: ["Viewed page", "$view"])
          .where(time: 30.days.ago..Time.zone.now)
          .group("properties->>'page'")
          .count
          .sort_by(&:last)
          .reverse
          .first(10) rescue []

        # Sessions by country
        @sessions_by_country = Ahoy::Visit
          .where(started_at: 7.days.ago..Time.zone.now)
          .where.not(country: nil)
          .group(:country)
          .count rescue {}

        # Recent sessions
        @recent_sessions = Ahoy::Visit
          .includes(:user)
          .order(started_at: :desc)
          .limit(20) rescue []

        # User sessions (for logged in users)
        if params[:user_id].present?
          @user = User.find(params[:user_id])
          @user_sessions = Ahoy::Visit.where(user_id: @user.id).order(started_at: :desc)
        end

        # Hourly distribution (last 24 hours)
        @hourly_distribution = Ahoy::Visit
          .where(started_at: 24.hours.ago..Time.zone.now)
          .group_by_hour(:started_at, time_zone: 'Asia/Kolkata')
          .count rescue {}

        # Average session duration
        sessions_with_events = Ahoy::Visit
          .joins(:events)
          .where(started_at: 30.days.ago..Time.zone.now)
          .group("ahoy_visits.id")
          .pluck(Arel.sql("ahoy_visits.id, MAX(ahoy_events.time) - ahoy_visits.started_at as duration")) rescue []

        if sessions_with_events.any?
          durations = sessions_with_events.map { |s| s[1].to_i }.compact.select { |d| d > 0 }
          @avg_session_duration = durations.any? ? (durations.sum / durations.size.to_f).round : 0
        else
          @avg_session_duration = 0
        end

        # Bounce rate calculation
        total_visits = Ahoy::Visit.where(started_at: 30.days.ago..Time.zone.now).count rescue 0
        if total_visits > 0
          single_page_visits = Ahoy::Visit
            .joins(:events)
            .where(started_at: 30.days.ago..Time.zone.now)
            .group("ahoy_visits.id")
            .having("COUNT(ahoy_events.id) = 1")
            .count.keys.count rescue 0
          @bounce_rate = ((single_page_visits.to_f / total_visits) * 100).round(2)
        else
          @bounce_rate = 0
        end

        # Referrer sources
        @referrer_sources = Ahoy::Visit
          .where(started_at: 7.days.ago..Time.zone.now)
          .where.not(referrer: nil)
          .group(:referrer)
          .count
          .sort_by(&:last)
          .reverse
          .first(10) rescue []
      end

      # API endpoint for real-time data
      def realtime_data
        Time.zone = 'Asia/Kolkata'

        data = {
          active_users: Ahoy::Visit.where("started_at > ?", 30.minutes.ago).count,
          today_sessions: Ahoy::Visit.where(started_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count,
          current_time: Time.zone.now.strftime("%B %d, %Y %I:%M:%S %p IST"),
          recent_sessions: Ahoy::Visit.includes(:user)
                            .order(started_at: :desc)
                            .limit(5)
                            .map do |session|
            {
              user: session.user ? "#{session.user.first_name} #{session.user.last_name}".strip.presence || session.user.email : "Guest",
              started_at: session.started_at.in_time_zone('Asia/Kolkata').strftime("%I:%M %p"),
              device: session.device_type || 'Unknown',
              country: session.country || 'Unknown'
            }
          end
        }

        respond_to do |format|
          format.json { render json: data }
        end
      end
    end
  end
end