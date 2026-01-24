module Admin
  module Reports
    class SessionsController < ApplicationController
      before_action :authenticate_user!

      def index
        # Set timezone to India
        Time.zone = 'Asia/Kolkata'

        # Handle date range filter
        @date_range = params[:date_range] || '30_days'

        date_from = case @date_range
                    when '7_days'
                      7.days.ago
                    when '30_days'
                      30.days.ago
                    when '3_months'
                      3.months.ago
                    when '6_months'
                      6.months.ago
                    when '1_year'
                      1.year.ago
                    else
                      30.days.ago
                    end

        # Simple login session statistics - only basic counts
        @total_logins = Ahoy::Visit.where(started_at: date_from..Time.zone.now).count
        @unique_users = Ahoy::Visit.where(started_at: date_from..Time.zone.now).distinct.count(:user_id)
        @today_logins = Ahoy::Visit.where(started_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count

        # Recent login events (simplified list)
        @recent_logins = Ahoy::Visit
          .includes(:user)
          .where(started_at: date_from..Time.zone.now)
          .order(started_at: :desc)
          .limit(50)

        # Logins by user type
        @logins_by_role = Ahoy::Visit
                          .joins(:user)
                          .where(started_at: date_from..Time.zone.now)
                          .group('users.user_type')
                          .count

        # Handle JSON requests for unique users modal
        respond_to do |format|
          format.html
          format.json do
            if params[:unique_users] == 'true'
              unique_users_data = Ahoy::Visit
                .joins(:user)
                .where(started_at: date_from..Time.zone.now)
                .group(:user_id)
                .includes(:user)
                .map do |visit|
                  user = visit.user
                  session_count = Ahoy::Visit.where(user_id: user.id, started_at: date_from..Time.zone.now).count
                  last_login = Ahoy::Visit.where(user_id: user.id).order(started_at: :desc).first&.started_at

                  role_color = case user.user_type
                              when 'admin' then 'danger'
                              when 'agent' then 'primary'
                              when 'customer' then 'success'
                              when 'sub_agent' then 'info'
                              else 'secondary'
                              end

                  {
                    name: "#{user.first_name} #{user.last_name}".strip.presence || user.email,
                    email: user.email,
                    role: user.user_type.humanize,
                    role_color: role_color,
                    session_count: session_count,
                    last_login: last_login ? last_login.in_time_zone('Asia/Kolkata').strftime('%b %d, %Y %I:%M %p') : 'Never'
                  }
                end.uniq { |u| u[:email] }.sort_by { |u| -u[:session_count] }

              render json: { unique_users: unique_users_data }
            end
          end
        end
      end

      # API endpoint for real-time data
      def realtime_data
        Time.zone = 'Asia/Kolkata'

        data = {
          today_logins: Ahoy::Visit.where(started_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count,
          current_time: Time.zone.now.strftime("%B %d, %Y %I:%M:%S %p IST"),
          recent_logins: Ahoy::Visit.includes(:user)
                         .order(started_at: :desc)
                         .limit(5)
                         .map do |visit|
            {
              user: visit.user ? "#{visit.user.first_name} #{visit.user.last_name}".strip.presence || visit.user.email : "Guest",
              logged_in_at: visit.started_at.in_time_zone('Asia/Kolkata').strftime("%I:%M %p")
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