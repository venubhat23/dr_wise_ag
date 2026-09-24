# Yearly subscription for affiliates (SubAgent, token role 'sub_agent') and
# ambassadors (Distributor, token role 'ambassador'). Each successful Razorpay
# payment buys 1 year (see Subscribable). When `renewal_required` is true the
# app should show only the renewal payment screen.
#
#   GET  /api/v1/mobile/subscription          current status + next renewal date
#   GET  /api/v1/mobile/subscription/history  every paid year
#   POST /api/v1/mobile/subscription/order    create Razorpay order (renewal or first payment)
#   POST /api/v1/mobile/subscription/verify   verify Checkout signature, extend by 1 year
class Api::V1::Mobile::SubscriptionController < Api::V1::Mobile::BaseController
  before_action :authenticate_subscriber!

  def show
    render_success({ subscription: @owner.subscription_summary })
  end

  def history
    render_success({
      subscription: @owner.subscription_summary,
      history: @owner.subscriptions.map(&:as_api_json)
    })
  end

  def create_order
    unless @owner.subscription_payment_due?
      return render_error('No subscription payment is due right now', :unprocessable_entity)
    end

    order = RazorpayService.create_order(
      amount_rupees: @owner.payment_amount_due,
      receipt: "#{receipt_prefix}_sub_#{@owner.id}_#{Time.current.to_i}"
    )
    @owner.update_column(:razorpay_order_id, order['id'])

    render_success({
      order_id: order['id'],
      amount: order['amount'],
      currency: order['currency'],
      key: RAZORPAY_CONFIG[:key_id],
      name: 'Dr WISE',
      description: "#{role_label} #{@owner.subscription_payment_kind == 'renewal' ? 'yearly renewal' : 'registration fee'}",
      payment_kind: @owner.subscription_payment_kind,
      prefill: { name: @owner.display_name, email: @owner.email, contact: @owner.mobile }
    }, 'Payment order created')
  rescue RazorpayService::Error => e
    render_error("Unable to create payment order: #{e.message}", :unprocessable_entity)
  end

  def verify
    order_id   = params[:razorpay_order_id]
    payment_id = params[:razorpay_payment_id]
    signature  = params[:razorpay_signature]

    unless order_id.present? && order_id == @owner.razorpay_order_id &&
           RazorpayService.verify_signature(order_id: order_id, payment_id: payment_id, signature: signature)
      return render_error('Payment verification failed', :unprocessable_entity)
    end

    @owner.mark_payment_paid!(order_id: order_id, payment_id: payment_id, amount: @owner.payment_amount_due)

    render_success({ subscription: @owner.reload.subscription_summary },
                   "Payment verified. Subscription valid till #{@owner.subscription_expires_at.strftime('%d %b %Y')}")
  end

  private

  def role_label
    @owner.is_a?(SubAgent) ? 'Affiliate' : 'Ambassador'
  end

  def receipt_prefix
    @owner.is_a?(SubAgent) ? 'affiliate' : 'ambassador'
  end

  # Same owner resolution as WalletController - an expired or not-yet-approved
  # account must still reach these endpoints to pay.
  def authenticate_subscriber!
    token = request.headers['Authorization']&.split(' ')&.last
    return render_error('Authorization token is required', :unauthorized) if token.blank?

    decoded_token = JWT.decode(token, Rails.application.secret_key_base)[0]

    case decoded_token['role']
    when 'sub_agent'
      @owner = SubAgent.find_by(id: decoded_token['user_id'])
      render_error('Affiliate account not found', :unauthorized) unless @owner
    when 'ambassador'
      user = User.find_by(id: decoded_token['user_id'])
      @owner = user && Distributor.find_by(email: user.email)
      render_error('Ambassador profile not found', :unauthorized) unless @owner
    else
      render_error('Ambassador or affiliate access required', :unauthorized)
    end
  rescue JWT::DecodeError
    render_error('Invalid authorization token', :unauthorized)
  end
end
