# Yearly membership for self-registered ambassadors (Distributor) and
# affiliates (SubAgent). Each successful Razorpay payment of the registration
# fee (`payment_amount_due`, set in Settings > Registration Fees) buys
# SUBSCRIPTION_PERIOD. Once `subscription_expires_at` passes, the owner must
# renew before using the ambassador dashboard / mobile app.
#
# Only owners who have paid at least once are tracked - admin-created
# accounts and fee-free sign-ups (fee = 0) are never blocked.
module Subscribable
  extend ActiveSupport::Concern

  SUBSCRIPTION_PERIOD = 1.year
  # Renew button / reminder banner shows up this many days before expiry.
  RENEWAL_WINDOW_DAYS = 30

  included do
    has_many :subscriptions, -> { recent_first }, as: :subscriber, dependent: :destroy

    # Admin Subscriptions page tabs.
    scope :subscription_active,        -> { where("#{table_name}.subscription_expires_at > ?", Time.current) }
    scope :subscription_expiring_soon, -> { where(subscription_expires_at: Time.current..RENEWAL_WINDOW_DAYS.days.from_now) }
    scope :subscription_expired,       -> { where("#{table_name}.subscription_expires_at <= ?", Time.current) }
    scope :subscription_unpaid,        -> { where(self_registered: true, payment_paid: false) }
  end

  def subscription_tracked?
    payment_paid? && subscription_expires_at.present?
  end

  def subscription_expired?
    subscription_tracked? && subscription_expires_at <= Time.current
  end

  def subscription_active?
    subscription_tracked? && !subscription_expired?
  end

  # Expired AND there is a fee to collect. With a fee of 0 we have nothing to
  # charge, so we never lock anyone out.
  def renewal_required?
    subscription_expired? && payment_amount_due > 0
  end

  def subscription_days_left
    return nil unless subscription_tracked?
    [(subscription_expires_at.to_date - Date.current).to_i, 0].max
  end

  def renewal_window_open?
    subscription_tracked? && subscription_days_left <= RENEWAL_WINDOW_DAYS
  end

  # Anything collectable right now: first-time registration fee, an expired
  # subscription, or an early renewal inside the renewal window.
  def subscription_payment_due?
    payment_required? || renewal_required? || (renewal_window_open? && payment_amount_due > 0)
  end

  def subscription_payment_kind
    payment_paid? ? "renewal" : "registration"
  end

  def subscription_status
    if !subscription_tracked? then payment_required? ? "unpaid" : "not_applicable"
    elsif subscription_expired? then "expired"
    elsif renewal_window_open? then "expiring_soon"
    else "active"
    end
  end

  # Records a successful Razorpay payment. Early renewals extend from the
  # current expiry so no paid days are lost; otherwise the year starts now.
  def mark_payment_paid!(order_id:, payment_id:, amount:)
    transaction do
      lock!
      # Same Razorpay payment verified twice (double-submit / retry) - no-op.
      return if subscriptions.exists?(razorpay_payment_id: payment_id)

      kind   = subscription_payment_kind
      now    = Time.current
      starts = subscription_active? ? subscription_expires_at : now
      expires = starts + SUBSCRIPTION_PERIOD

      subscriptions.create!(
        kind: kind, amount: amount, starts_at: starts, expires_at: expires, paid_at: now,
        razorpay_order_id: order_id, razorpay_payment_id: payment_id
      )

      # update_columns: the money is already collected, so an unrelated
      # validation (e.g. name still blank pre-KYC) must never block recording it.
      update_columns(
        updated_at: now,
        payment_paid: true,
        payment_paid_at: now,
        payment_amount: amount,
        razorpay_order_id: order_id,
        razorpay_payment_id: payment_id,
        subscription_expires_at: expires
      )
    end
  end

  # Shape shared by the mobile login/profile/subscription endpoints.
  def subscription_summary
    {
      status: subscription_status,
      active: subscription_active?,
      expired: subscription_expired?,
      renewal_required: renewal_required?,
      payment_due: subscription_payment_due?,
      payment_kind: subscription_payment_kind,
      amount_due: payment_amount_due.to_f,
      started_at: (subscriptions.detect(&:active?) || subscriptions.first)&.starts_at,
      expires_at: subscription_expires_at,
      next_renewal_date: subscription_expires_at&.to_date,
      days_left: subscription_days_left,
      renewal_window_days: RENEWAL_WINDOW_DAYS
    }
  end
end
