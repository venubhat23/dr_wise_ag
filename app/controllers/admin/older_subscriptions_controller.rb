# Older (pre-tracking) membership periods for an affiliate (SubAgent) or
# ambassador (Distributor), added from their admin show page. History only -
# never changes subscription status. Also sets member_since.
class Admin::OlderSubscriptionsController < Admin::ApplicationController
  before_action :set_subscriber

  # POST /admin/sub_agents/1/older_subscriptions
  def create
    older = @subscriber.older_subscriptions.new(older_params.merge(created_by: current_user&.email))
    if older.save
      redirect_back_to_owner notice: "Older subscription added (#{period_label(older)})."
    else
      redirect_back_to_owner alert: older.errors.full_messages.to_sentence
    end
  end

  # PATCH /admin/sub_agents/1/older_subscriptions/2
  def update
    older = @subscriber.older_subscriptions.find(params[:id])
    if older.update(older_params)
      redirect_back_to_owner notice: "Older subscription updated (#{period_label(older)})."
    else
      redirect_back_to_owner alert: older.errors.full_messages.to_sentence
    end
  end

  # DELETE /admin/sub_agents/1/older_subscriptions/2
  def destroy
    older = @subscriber.older_subscriptions.find(params[:id])
    older.destroy!
    redirect_back_to_owner notice: "Older subscription #{period_label(older)} removed."
  end

  # PATCH /admin/sub_agents/1/older_subscriptions/member_since
  def member_since
    @subscriber.update_column(:member_since, params[:member_since].presence && Date.parse(params[:member_since]))
    redirect_back_to_owner notice: params[:member_since].present? ? "Member since set to #{@subscriber.member_since.strftime('%d %b %Y')}." : 'Member since cleared (now derived automatically).'
  rescue Date::Error
    redirect_back_to_owner alert: 'Please enter a valid date.'
  end

  private

  def set_subscriber
    @subscriber = params[:sub_agent_id] ? SubAgent.find(params[:sub_agent_id]) : Distributor.find(params[:distributor_id])
  end

  def older_params
    params.permit(:starts_on, :ends_on, :amount, :paid_on, :notes)
  end

  def period_label(older)
    "#{older.starts_on&.strftime('%d %b %Y')} - #{older.ends_on&.strftime('%d %b %Y')}"
  end

  def redirect_back_to_owner(flash_opts)
    path = @subscriber.is_a?(SubAgent) ? admin_sub_agent_path(@subscriber) : admin_distributor_path(@subscriber)
    redirect_to "#{path}#older-subscriptions", flash_opts
  end
end
