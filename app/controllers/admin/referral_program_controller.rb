class Admin::ReferralProgramController < Admin::ApplicationController
  include ConfigurablePagination

  SIGNUP_BONUS = AffiliateReferralService::SIGNUP_BONUS

  # GET /admin/referral_program
  def index
    @total_ambassadors = Distributor.count
    @total_affiliates  = SubAgent.count
    @via_referral      = SubAgent.where.not(referred_by_code: nil).count
    @bonuses_paid      = SubAgent.where.not(referral_bonus_credited_at: nil).count
    @bonus_amount_paid = WalletTransaction.where('description LIKE ?', 'Referral signup bonus%').sum(:amount)

    # Per-ambassador rollups (single grouped query each)
    direct_counts   = SubAgent.where.not(distributor_id: nil).group(:distributor_id).count
    assigned_counts = DistributorAssignment.group(:distributor_id).count
    @affiliate_counts = direct_counts.merge(assigned_counts) { |_k, a, b| [a, b].max }
    @referral_counts  = SubAgent.where.not(referred_by_code: nil).where.not(distributor_id: nil)
                                .group(:distributor_id).count
    @bonus_counts     = SubAgent.where.not(referral_bonus_credited_at: nil).where.not(distributor_id: nil)
                                .group(:distributor_id).count

    scope = Distributor.all
    scope = scope.search_by_name_mobile_email(params[:search].strip) if params[:search].to_s.strip.length >= 3
    @total_filtered = scope.count
    @ambassadors = paginate_records(scope.order(created_at: :desc), @total_filtered)

    # Latest referral signups feed
    @recent_signups = SubAgent.where.not(referred_by_code: nil)
                              .order(created_at: :desc)
                              .limit(8)
    @recent_ambassadors = Distributor.where(id: @recent_signups.map(&:distributor_id).compact.uniq)
                                     .index_by(&:id)
  end

  # GET /admin/referral_program/:id  (one ambassador's tree)
  def show
    @ambassador = Distributor.find(params[:id])

    affiliate_ids = (@ambassador.sub_agents.ids + @ambassador.assigned_sub_agents.ids).uniq
    @affiliates = SubAgent.where(id: affiliate_ids)
                          .left_joins(:wallet)
                          .order(created_at: :desc)

    @wallets_by_owner = Wallet.where(owner_type: 'SubAgent', owner_id: affiliate_ids).index_by(&:owner_id)

    @via_ambassador_code = @affiliates.count { |a| a.referred_by_kind == 'ambassador' }
    @via_affiliate_code  = @affiliates.count { |a| a.referred_by_kind == 'affiliate' }
    @via_no_code         = @affiliates.count { |a| a.referred_by_code.blank? }
    @bonuses_paid        = @affiliates.count(&:referral_bonus_credited?)
    @bonus_amount        = @bonuses_paid * SIGNUP_BONUS

    # Map affiliate-code referrals to the referring affiliate for the tree labels
    referrer_codes = @affiliates.filter_map { |a| a.referred_by_code if a.referred_by_kind == 'affiliate' }
    @referrers_by_code = SubAgent.where('UPPER(referral_code) IN (?)', referrer_codes.map(&:upcase))
                                 .index_by { |s| s.referral_code.upcase } if referrer_codes.any?
    @referrers_by_code ||= {}
  end
end
