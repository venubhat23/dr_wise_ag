# Admin > Incentive Calculator: the fixed product list from IncentiveCalculator
# with editable Minimum / Upto / Remarks (same data the mobile app reads from
# GET /api/v1/mobile/incentive_calculator).
class Admin::IncentiveCalculatorController < Admin::ApplicationController
  # GET /admin/incentive_calculator
  def index
    @grouped = IncentiveCalculator.grouped
    @editing = params[:edit].present?
  end

  # PATCH /admin/incentive_calculator
  def update
    errors = IncentiveCalculator.update(params.fetch(:rows, {}).to_unsafe_h)

    if errors.empty?
      redirect_to admin_incentive_calculator_index_path, notice: 'Incentive ranges updated.'
    else
      redirect_to admin_incentive_calculator_index_path(edit: 1), alert: errors.first(5).join('. ')
    end
  end

  # POST /admin/incentive_calculator/reset
  def reset
    IncentiveCalculator.reset!
    redirect_to admin_incentive_calculator_index_path, notice: 'Incentive ranges reset to the default sheet values.'
  end
end
