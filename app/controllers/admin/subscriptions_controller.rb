# Admin overview of yearly subscriptions (see Subscribable): which
# ambassadors / affiliates are active, due for renewal within 30 days,
# expired (locked out of the dashboard / app) or not subscribed at all
# (includes existing / admin-created accounts that never paid).
class Admin::SubscriptionsController < Admin::ApplicationController
  include KycQueueTools

  TYPES = { 'ambassadors' => Distributor, 'affiliates' => SubAgent }.freeze
  TABS  = {
    'active'        => :subscription_active,
    'expiring_soon' => :subscription_expiring_soon,
    'expired'       => :subscription_expired,
    'not_subscribed' => :subscription_not_subscribed
  }.freeze

  # GET /admin/subscriptions?type=ambassadors|affiliates&status=active|expiring_soon|expired|not_subscribed
  def index
    @type  = TYPES.key?(params[:type]) ? params[:type] : 'ambassadors'
    @tab   = TABS.key?(params[:status]) ? params[:status] : 'expiring_soon'
    model  = TYPES[@type]

    @tab_counts = TABS.transform_values { |scope| model.public_send(scope).count }
    @type_counts = TYPES.transform_values { |m| m.subscription_expired.count }

    scope = model.public_send(TABS[@tab])
    return render_kyc_lookup(scope) if params[:lookup].present?

    order = @tab == 'not_subscribed' ? { created_at: :desc } : { subscription_expires_at: (@tab == 'expired' ? :desc : :asc) }
    @records = apply_kyc_search(scope).includes(:subscriptions).order(order)
    @records = @records.page(params[:page]).per(25) if @records.respond_to?(:page)

    @recent_payments = Subscription.where(subscriber_type: model.name)
                                   .includes(:subscriber).order(paid_at: :desc, id: :desc).limit(10)
  end
end
