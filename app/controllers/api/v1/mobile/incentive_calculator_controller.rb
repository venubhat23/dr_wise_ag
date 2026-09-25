# Incentive ranges (₹ Minimum - Upto) per Segment > Category > Sub-category,
# as edited in Admin > Incentive Calculator (see IncentiveCalculator).
#
#   GET /api/v1/mobile/incentive_calculator
class Api::V1::Mobile::IncentiveCalculatorController < Api::V1::Mobile::BaseController
  before_action :authenticate_token!

  def index
    render_success({ currency: 'INR', segments: IncentiveCalculator.as_api_json })
  end

  private

  # Any logged-in app user (affiliate, ambassador, agent, customer) may read it.
  def authenticate_token!
    token = request.headers['Authorization']&.split(' ')&.last
    return render_error('Authorization token is required', :unauthorized) if token.blank?

    JWT.decode(token, Rails.application.secret_key_base)
  rescue JWT::DecodeError
    render_error('Invalid authorization token', :unauthorized)
  end
end
