class Api::V1::Mobile::CommissionController < ApplicationController
  # Skip CSRF for API endpoints
  skip_before_action :verify_authenticity_token

  # Before actions
  before_action :authenticate_sub_agent!
  before_action :validate_sub_agent_status

  # GET /api/v1/mobile/commission/breakdown
  def breakdown
    begin
      # Get commission summary for current sub-agent
      commission_summary = calculate_commission_summary
      recent_payouts = get_recent_commission_payouts

      response_data = {
        status: 'success',
        data: {
          commission_summary: commission_summary,
          recent_payouts: recent_payouts
        },
        timestamp: Time.current.iso8601
      }

      render json: response_data, status: :ok

    rescue => e
      Rails.logger.error "Commission breakdown API error: #{e.message}"
      render json: {
        status: 'error',
        message: 'Unable to fetch commission breakdown',
        error: e.message
      }, status: :internal_server_error
    end
  end

  # GET /api/v1/mobile/commission/summary
  def summary
    begin
      summary_data = calculate_commission_summary

      render json: {
        status: 'success',
        data: summary_data,
        timestamp: Time.current.iso8601
      }, status: :ok

    rescue => e
      Rails.logger.error "Commission summary API error: #{e.message}"
      render json: {
        status: 'error',
        message: 'Unable to fetch commission summary',
        error: e.message
      }, status: :internal_server_error
    end
  end

  # GET /api/v1/mobile/commission/history
  def history
    begin
      page = params[:page]&.to_i || 1
      per_page = params[:per_page]&.to_i || 10
      per_page = [per_page, 50].min # Limit to max 50 records per page

      # Get paginated commission history
      payouts = CommissionPayout.where(
        policy_type: ['health', 'life', 'motor', 'other'],
        payout_to: 'sub_agent'
      ).joins(:policy).where(
        "CASE
         WHEN commission_payouts.policy_type = 'health' THEN health_insurances.sub_agent_id = ?
         WHEN commission_payouts.policy_type = 'life' THEN life_insurances.sub_agent_id = ?
         WHEN commission_payouts.policy_type = 'motor' THEN motor_insurances.sub_agent_id = ?
         WHEN commission_payouts.policy_type = 'other' THEN other_insurances.sub_agent_id = ?
         END", current_sub_agent.id, current_sub_agent.id, current_sub_agent.id, current_sub_agent.id
      ).includes(:policy)
       .recent
       .page(page)
       .per(per_page)

      formatted_payouts = payouts.map { |payout| format_payout_data(payout) }

      render json: {
        status: 'success',
        data: {
          payouts: formatted_payouts,
          pagination: {
            current_page: page,
            per_page: per_page,
            total_pages: payouts.total_pages,
            total_count: payouts.total_count,
            has_next_page: page < payouts.total_pages,
            has_prev_page: page > 1
          }
        },
        timestamp: Time.current.iso8601
      }, status: :ok

    rescue => e
      Rails.logger.error "Commission history API error: #{e.message}"
      render json: {
        status: 'error',
        message: 'Unable to fetch commission history',
        error: e.message
      }, status: :internal_server_error
    end
  end

  # GET /api/v1/mobile/commission/stats
  def stats
    begin
      current_year = Date.current.year
      current_month = Date.current.month

      # Monthly stats for current year
      monthly_stats = (1..12).map do |month|
        start_date = Date.new(current_year, month, 1)
        end_date = start_date.end_of_month

        monthly_payouts = get_sub_agent_payouts_for_period(start_date, end_date)

        {
          month: month,
          month_name: Date::MONTHNAMES[month],
          total_earned: monthly_payouts.sum(:payout_amount),
          paid_amount: monthly_payouts.paid.sum(:payout_amount),
          pending_amount: monthly_payouts.pending.sum(:payout_amount),
          processing_amount: monthly_payouts.processing.sum(:payout_amount),
          payout_count: monthly_payouts.count
        }
      end

      # Year-to-date totals
      ytd_start = Date.new(current_year, 1, 1)
      ytd_payouts = get_sub_agent_payouts_for_period(ytd_start, Date.current)

      ytd_stats = {
        total_earned: ytd_payouts.sum(:payout_amount),
        paid_amount: ytd_payouts.paid.sum(:payout_amount),
        pending_amount: ytd_payouts.pending.sum(:payout_amount),
        processing_amount: ytd_payouts.processing.sum(:payout_amount),
        total_policies: ytd_payouts.count
      }

      render json: {
        status: 'success',
        data: {
          monthly_stats: monthly_stats,
          ytd_stats: ytd_stats,
          year: current_year
        },
        timestamp: Time.current.iso8601
      }, status: :ok

    rescue => e
      Rails.logger.error "Commission stats API error: #{e.message}"
      render json: {
        status: 'error',
        message: 'Unable to fetch commission stats',
        error: e.message
      }, status: :internal_server_error
    end
  end

  private

  def authenticate_sub_agent!
    # Extract token from Authorization header
    token = request.headers['Authorization']&.split(' ')&.last

    unless token
      render json: { status: 'error', message: 'Authorization token required' }, status: :unauthorized
      return
    end

    # Decode token and find sub-agent (simplified - implement proper JWT logic)
    begin
      # This is a simplified version - implement proper JWT decode logic
      decoded_token = JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })
      sub_agent_id = decoded_token[0]['sub_agent_id']

      @current_sub_agent = SubAgent.find_by(id: sub_agent_id)

      unless @current_sub_agent
        render json: { status: 'error', message: 'Invalid token or sub-agent not found' }, status: :unauthorized
        return
      end

    rescue JWT::DecodeError => e
      render json: { status: 'error', message: 'Invalid token format' }, status: :unauthorized
      return
    rescue => e
      render json: { status: 'error', message: 'Authentication failed' }, status: :unauthorized
      return
    end
  end

  def current_sub_agent
    @current_sub_agent
  end

  def validate_sub_agent_status
    unless current_sub_agent&.truly_active?
      render json: {
        status: 'error',
        message: 'Account is inactive or deactivated'
      }, status: :forbidden
    end
  end

  def calculate_commission_summary
    # Get all commission payouts for current sub-agent
    all_payouts = get_all_sub_agent_payouts

    total_earned = all_payouts.sum(:payout_amount)
    paid_amount = all_payouts.paid.sum(:payout_amount)
    pending_amount = all_payouts.pending.sum(:payout_amount)
    processing_amount = all_payouts.processing.sum(:payout_amount)

    {
      commission_earned: format_currency(total_earned),
      commission_earned_raw: total_earned,
      total_earned: format_currency(paid_amount),
      total_earned_raw: paid_amount,
      paid: format_currency(paid_amount),
      paid_raw: paid_amount,
      pending: format_currency(pending_amount),
      pending_raw: pending_amount,
      processing: format_currency(processing_amount),
      processing_raw: processing_amount,
      total_policies: all_payouts.count,
      active_policies: all_payouts.where.not(status: 'cancelled').count
    }
  end

  def get_recent_commission_payouts(limit = 7)
    recent_payouts = get_all_sub_agent_payouts
                      .recent
                      .limit(limit)
                      .includes(:policy)

    recent_payouts.map { |payout| format_payout_data(payout) }
  end

  def get_all_sub_agent_payouts
    CommissionPayout.where(
      policy_type: ['health', 'life', 'motor', 'other'],
      payout_to: 'sub_agent'
    ).joins(
      "LEFT JOIN health_insurances ON commission_payouts.policy_type = 'health' AND commission_payouts.policy_id = health_insurances.id
       LEFT JOIN life_insurances ON commission_payouts.policy_type = 'life' AND commission_payouts.policy_id = life_insurances.id
       LEFT JOIN motor_insurances ON commission_payouts.policy_type = 'motor' AND commission_payouts.policy_id = motor_insurances.id
       LEFT JOIN other_insurances ON commission_payouts.policy_type = 'other' AND commission_payouts.policy_id = other_insurances.id"
    ).where(
      "COALESCE(health_insurances.sub_agent_id, life_insurances.sub_agent_id, motor_insurances.sub_agent_id, other_insurances.sub_agent_id) = ?",
      current_sub_agent.id
    )
  end

  def get_sub_agent_payouts_for_period(start_date, end_date)
    get_all_sub_agent_payouts.where(payout_date: start_date..end_date)
  end

  def format_payout_data(payout)
    policy = payout.policy
    customer = policy&.customer

    {
      id: payout.id,
      policy_number: payout.policy_number,
      policy_type: format_policy_type(payout.policy_type),
      customer_name: customer&.display_name || 'Unknown Customer',
      commission_amount: format_currency(payout.payout_amount),
      commission_amount_raw: payout.payout_amount,
      tds_amount: format_currency(payout.tds_amount),
      tds_amount_raw: payout.tds_amount,
      net_amount: format_currency(payout.net_amount),
      net_amount_raw: payout.net_amount,
      commission_percentage: payout.payout_percentage,
      status: payout.status.titleize,
      status_raw: payout.status,
      payout_date: payout.payout_date&.strftime("%d %b, %Y"),
      payout_date_raw: payout.payout_date&.iso8601,
      created_date: payout.created_at&.strftime("%d %b, %Y"),
      created_date_raw: payout.created_at&.iso8601,
      payment_mode: payout.payment_mode,
      transaction_id: payout.transaction_id,
      reference_number: payout.reference_number
    }
  end

  def format_policy_type(policy_type)
    case policy_type.downcase
    when 'health'
      'Health Insurance'
    when 'life'
      'Life Insurance'
    when 'motor'
      'Motor Insurance'
    when 'other'
      'Other Insurance'
    else
      policy_type.titleize
    end
  end

  def format_currency(amount)
    return '₹0' if amount.nil? || amount.zero?

    # Convert to Indian currency format
    formatted = amount.to_i.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    "₹#{formatted}"
  end
end