class Admin::Reports::SessionReportsController < Admin::Reports::BaseController
  def index
    # Note: This assumes you have some kind of session tracking
    # You may need to adjust based on your actual session tracking implementation

    @sessions = gather_session_data

    # Apply filters
    @sessions = filter_sessions(@sessions)

    # Statistics
    @statistics = calculate_session_statistics(@sessions)

    # Paginate
    @sessions = Kaminari.paginate_array(@sessions).page(params[:page]).per(50)
  end

  def export
    redirect_to admin_reports_session_reports_path(format: :csv)
  end

  private

  def gather_session_data
    sessions = []

    # Aggregate user login data if you have a sessions table
    if defined?(UserSession)
      UserSession.includes(:user).each do |session|
        sessions << format_session_data(session)
      end
    else
      # Fallback: Use user sign_in data or create mock data for demonstration
      User.where(user_type: ['admin', 'agent']).each do |user|
        sessions << {
          id: user.id,
          user_name: user.full_name || user.email,
          user_email: user.email,
          user_type: user.user_type,
          last_sign_in_at: user.last_sign_in_at || user.created_at,
          sign_in_count: user.sign_in_count || 0,
          current_sign_in_ip: user.current_sign_in_ip || 'Unknown',
          session_duration: calculate_estimated_duration(user),
          total_logins_today: get_today_login_count(user),
          total_logins_this_week: get_week_login_count(user),
          status: user.status? ? 'active' : 'inactive'
        }
      end
    end

    sessions
  end

  def format_session_data(session)
    {
      id: session.id,
      user_name: session.user&.full_name || session.user&.email || 'Unknown',
      user_email: session.user&.email,
      user_type: session.user&.user_type || 'unknown',
      started_at: session.created_at,
      ended_at: session.ended_at,
      duration_minutes: session.ended_at ? ((session.ended_at - session.created_at) / 60).round : nil,
      ip_address: session.ip_address,
      user_agent: session.user_agent,
      pages_visited: session.pages_visited || 0,
      actions_performed: session.actions_count || 0,
      status: session.ended_at ? 'ended' : 'active'
    }
  end

  def calculate_estimated_duration(user)
    # Estimate based on activity patterns
    if user.last_sign_in_at
      # Simple estimation: assume 30 minutes average session
      30
    else
      0
    end
  end

  def get_today_login_count(user)
    # This would need actual session tracking
    user.sign_in_count > 0 ? 1 : 0
  end

  def get_week_login_count(user)
    # This would need actual session tracking
    user.sign_in_count || 0
  end

  def filter_sessions(sessions)
    # Filter by user type
    sessions = sessions.select { |s| s[:user_type] == params[:user_type] } if params[:user_type].present?

    # Filter by status
    sessions = sessions.select { |s| s[:status] == params[:status] } if params[:status].present?

    # Filter by date range
    if params[:start_date].present?
      start_date = params[:start_date].to_date
      sessions = sessions.select { |s| s[:last_sign_in_at] && s[:last_sign_in_at].to_date >= start_date }
    end

    if params[:end_date].present?
      end_date = params[:end_date].to_date
      sessions = sessions.select { |s| s[:last_sign_in_at] && s[:last_sign_in_at].to_date <= end_date }
    end

    # Search filter
    if params[:search].present?
      search_term = params[:search].downcase
      sessions = sessions.select do |s|
        s[:user_name]&.downcase&.include?(search_term) ||
        s[:user_email]&.downcase&.include?(search_term)
      end
    end

    sessions
  end

  def calculate_session_statistics(sessions)
    {
      total_sessions: sessions.count,
      active_sessions: sessions.count { |s| s[:status] == 'active' },
      by_user_type: sessions.group_by { |s| s[:user_type] }.transform_values(&:count),
      average_duration: sessions.map { |s| s[:session_duration] || 0 }.sum / [sessions.count, 1].max,
      peak_hours: calculate_peak_hours(sessions),
      daily_sessions: calculate_daily_sessions(sessions),
      top_users: sessions.group_by { |s| s[:user_name] }
                        .transform_values(&:count)
                        .sort_by { |k, v| -v }
                        .first(10)
                        .to_h
    }
  end

  def calculate_peak_hours(sessions)
    hours = sessions.filter_map { |s| s[:last_sign_in_at]&.hour }
    hours.group_by(&:itself).transform_values(&:count).sort_by { |k, v| -v }.to_h
  end

  def calculate_daily_sessions(sessions)
    sessions.group_by { |s| s[:last_sign_in_at]&.to_date }.transform_values(&:count)
  end
end