## Shared behaviour for the Affiliate / Ambassador wallet admin screens.
#
# The including controller must implement:
#   owner_class          -> the AR model (SubAgent / Distributor)
#   owner_scope          -> base relation to list
#   owner_noun           -> label, e.g. "Affiliate"
#   owner_icon           -> bootstrap icon class for headers
#   wallet_index_path    -> path to the listing page
#   wallet_entity_path(owner)      -> path to a single wallet
#   wallet_add_funds_path(owner)   -> POST path to add funds
#   wallet_remove_funds_path(owner)-> POST path to remove funds
module WalletManagement
  extend ActiveSupport::Concern

  included do
    include ConfigurablePagination
    before_action :set_owner, only: [:show, :add_funds, :remove_funds]
    before_action :build_wallet_config
  end

  def index
    scope = owner_scope

    if params[:search].to_s.strip.length >= 3
      scope = scope.search_by_name_mobile_email(params[:search].strip)
    end

    case params[:status]
    when 'active'   then scope = scope.active
    when 'inactive' then scope = scope.inactive
    end

    @total_filtered_count = scope.count
    @owners = paginate_records(scope.order(created_at: :desc), @total_filtered_count)

    @wallets_by_owner = Wallet
                        .where(owner_type: owner_class.name, owner_id: @owners.map(&:id))
                        .index_by(&:owner_id)

    totals = Wallet.where(owner_type: owner_class.name)
    @total_wallets     = totals.count
    @total_balance     = totals.sum(:balance)
    @wallets_with_funds = totals.where('balance > 0').count
  end

  def show
    @wallet = @owner.wallet!
    @transactions = paginate_records(@wallet.wallet_transactions.recent_first)
  end

  def add_funds
    apply_wallet_change(:credit)
  end

  def remove_funds
    apply_wallet_change(:debit)
  end

  private

  def apply_wallet_change(direction)
    wallet = @owner.wallet!
    amount = params[:amount].to_s.gsub(/[,\s]/, '').to_d
    note   = params[:description].to_s.strip

    begin
      if direction == :credit
        wallet.credit!(amount, description: note, performed_by: current_user&.email)
        flash[:notice] = "#{helpers.indian_currency(amount)} added to #{@owner.display_name}'s wallet."
      else
        wallet.debit!(amount, description: note, performed_by: current_user&.email)
        flash[:notice] = "#{helpers.indian_currency(amount)} removed from #{@owner.display_name}'s wallet."
      end
    rescue ArgumentError, ActiveRecord::RecordInvalid => e
      flash[:alert] = e.message
    end

    redirect_to wallet_entity_path(@owner)
  end

  def build_wallet_config
    @wallet_config = {
      noun: owner_noun,
      icon: owner_icon,
      index_path: wallet_index_path
    }
  end
end
