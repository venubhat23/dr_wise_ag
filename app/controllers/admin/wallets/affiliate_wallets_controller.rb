class Admin::Wallets::AffiliateWalletsController < Admin::ApplicationController
  include WalletManagement

  private

  def owner_class
    SubAgent
  end

  def owner_scope
    SubAgent.all
  end

  def owner_noun
    'Affiliate'
  end

  def owner_icon
    'bi-people'
  end

  def set_owner
    @owner = SubAgent.find(params[:id])
  end

  def wallet_index_path
    admin_wallets_affiliate_wallets_path
  end

  def wallet_entity_path(owner)
    admin_wallets_affiliate_wallet_path(owner)
  end

  def wallet_add_funds_path(owner)
    add_funds_admin_wallets_affiliate_wallet_path(owner)
  end

  def wallet_remove_funds_path(owner)
    remove_funds_admin_wallets_affiliate_wallet_path(owner)
  end
  helper_method :wallet_entity_path, :wallet_add_funds_path, :wallet_remove_funds_path
end
