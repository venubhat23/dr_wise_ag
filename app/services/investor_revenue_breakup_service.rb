# Revenue breakup for investors, monthly and yearly (Indian financial year,
# Apr–Mar). A period's investor share (investor commission payouts created in
# that period, paid + pending) ÷ total shares = per-share amount; each investor
# gets shares × per-share. Pass an investor to get only that investor's rows.
#
# Shares are the current holdings, so past periods are split by today's share
# count (same as the existing monthly breakup).
class InvestorRevenueBreakupService
  MONTHS = 12
  YEARS  = 5

  def initialize(investor: nil)
    @investor = investor
  end

  def call
    holders      = Investor.where('number_of_shares > 0').order(number_of_shares: :desc).to_a
    total_shares = holders.sum(&:number_of_shares)
    rows_for     = @investor ? holders.select { |inv| inv.id == @investor.id } : holders

    pool = monthly_pool
    monthly = (0...MONTHS).map do |i|
      month = (Date.current - i.months).beginning_of_month
      build_period(pool, [month.strftime('%Y-%m')], total_shares, rows_for,
                   key: "m#{month.strftime('%Y-%m')}", label: month.strftime('%B %Y'),
                   short: month.strftime('%b'), current: i.zero?)
    end.reverse

    current_fy = fy_start_year(Date.current)
    first_fy   = pool.keys.map { |(m, _)| fy_start_year(Date.strptime(m, '%Y-%m')) }.min || current_fy
    first_fy   = [first_fy, current_fy - YEARS + 1].max
    yearly = (first_fy..current_fy).map do |fy|
      months = (0..11).map { |i| (Date.new(fy, 4, 1) + i.months).strftime('%Y-%m') }
      period = build_period(pool, months, total_shares, rows_for,
                            key: "y#{fy}", label: "FY #{fy}-#{(fy + 1).to_s.last(2)}",
                            short: "FY#{(fy + 1).to_s.last(2)}", current: fy == current_fy)
      # Month-by-month detail within the year (future months left out)
      period[:months] = months.select { |m| m <= Date.current.strftime('%Y-%m') }.map do |m|
        total = pool.sum { |(pm, _), amt| pm == m ? amt.to_f : 0 }
        { label: Date.strptime(m, '%Y-%m').strftime('%b %Y'), total: total,
          per_share: total_shares > 0 ? total / total_shares : 0 }
      end
      period
    end

    {
      monthly: monthly,
      yearly: yearly,
      total_shares: total_shares,
      holders_count: holders.size,
      default_month: default_key(monthly),
      default_year: yearly.last[:key]
    }
  end

  private

  # { ['YYYY-MM', status] => amount } for all investor payouts, one query.
  def monthly_pool
    tz = Time.zone.tzinfo.identifier
    month_sql = "to_char(commission_payouts.created_at AT TIME ZONE 'UTC' AT TIME ZONE '#{tz}', 'YYYY-MM')"
    CommissionPayout.where(payout_to: 'investor').group(Arel.sql(month_sql), :status).sum(:payout_amount)
  end

  def build_period(pool, months, total_shares, rows_for, **attrs)
    paid  = pool.sum { |(m, status), amt| months.include?(m) && status == 'paid' ? amt.to_f : 0 }
    total = pool.sum { |(m, _), amt| months.include?(m) ? amt.to_f : 0 }
    per_share = total_shares > 0 ? total / total_shares : 0
    attrs.merge(
      total: total, paid: paid, pending: total - paid, per_share: per_share,
      rows: rows_for.map { |inv| { investor: inv, shares: inv.number_of_shares, amount: inv.number_of_shares * per_share } }
    )
  end

  def fy_start_year(date)
    date.month >= 4 ? date.year : date.year - 1
  end

  # Last complete period, or the current one if the last had nothing.
  def default_key(periods)
    previous = periods[-2]
    (previous && previous[:total].positive? ? previous : periods.last)[:key]
  end
end
