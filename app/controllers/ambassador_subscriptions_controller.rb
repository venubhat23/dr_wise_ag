# Yearly subscription page for ambassadors: shows current validity + payment
# history and collects the renewal fee via Razorpay Checkout. When the
# subscription has expired, AmbassadorController redirects every page here.
class AmbassadorSubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_ambassador
  before_action :set_distributor

  layout "devise"

  # GET /ambassador/subscription
  def show
    @amount = @distributor.payment_amount_due
    @subscriptions = @distributor.subscriptions.to_a
  end

  # POST /ambassador/subscription/order (AJAX)
  def create_order
    unless @distributor.subscription_payment_due?
      return render json: { error: "No payment is due right now." }, status: :unprocessable_entity
    end

    order = RazorpayService.create_order(
      amount_rupees: @distributor.payment_amount_due,
      receipt: "ambassador_sub_#{@distributor.id}_#{Time.current.to_i}"
    )
    @distributor.update_column(:razorpay_order_id, order["id"])

    render json: {
      order_id: order["id"],
      amount: order["amount"],
      currency: order["currency"],
      key: RAZORPAY_CONFIG[:key_id],
      name: "Dr WISE",
      description: "Ambassador yearly subscription",
      prefill: { name: @distributor.display_name, email: @distributor.email, contact: @distributor.mobile }
    }
  rescue RazorpayService::Error => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # POST /ambassador/subscription/verify (AJAX)
  def verify
    order_id   = params[:razorpay_order_id]
    payment_id = params[:razorpay_payment_id]
    signature  = params[:razorpay_signature]

    unless order_id.present? && order_id == @distributor.razorpay_order_id &&
           RazorpayService.verify_signature(order_id: order_id, payment_id: payment_id, signature: signature)
      return render json: { error: "Payment verification failed." }, status: :unprocessable_entity
    end

    @distributor.mark_payment_paid!(order_id: order_id, payment_id: payment_id, amount: @distributor.payment_amount_due)
    flash[:notice] = "Payment received. Your subscription is valid till #{@distributor.subscription_expires_at.strftime('%d %b %Y')}."
    render json: { redirect_to: ambassador_dashboard_path, expires_at: @distributor.subscription_expires_at }
  end

  private

  def ensure_ambassador
    redirect_to root_path, alert: "Ambassador access required." unless current_user&.ambassador?
  end

  def set_distributor
    @distributor = Distributor.find_by(email: current_user.email)
    redirect_to root_path, alert: "Ambassador profile not found." if @distributor.nil?
  end
end
