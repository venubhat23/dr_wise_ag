class Admin::Wallets::AmbassadorWalletsController < Admin::ApplicationController
  include WalletManagement

  private

  def owner_class
    Distributor
  end

  def owner_scope
    Distributor.all
  end

  def owner_noun
    'Ambassador'
  end

  def owner_icon
    'bi-diagram-3'
  end

  def set_owner
    @owner = Distributor.find(params[:id])
  end

  def wallet_index_path
    admin_wallets_ambassador_wallets_path
  end

  def wallet_entity_path(owner)
    admin_wallets_ambassador_wallet_path(owner)
  end

  def wallet_add_funds_path(owner)
    add_funds_admin_wallets_ambassador_wallet_path(owner)
  end

  def wallet_remove_funds_path(owner)
    remove_funds_admin_wallets_ambassador_wallet_path(owner)
  end
  helper_method :wallet_entity_path, :wallet_add_funds_path, :wallet_remove_funds_path
end
