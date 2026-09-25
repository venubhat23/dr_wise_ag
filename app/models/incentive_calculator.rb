# Incentive ranges (₹ Minimum - Upto) per Segment > Category > Sub-category.
#
# The rows themselves are fixed (DEFAULT_ROWS below, from the business sheet);
# admin can only edit each row's minimum / upto / remarks from
# Admin > Incentive Calculator. Those edits are kept as JSON in SystemSetting
# (key SETTING_KEY), keyed by row id, and merged over the defaults - so no
# table/migration is needed and a row added here later just shows its default.
class IncentiveCalculator
  SETTING_KEY = 'incentive_calculator'.freeze

  # [segment, category, sub_category, minimum, upto]
  DEFAULT_ROWS = [
    ['Insurance', 'Travel', 'Domestic', 100, 5_000],
    ['Insurance', 'Travel', 'International', 500, 10_000],
    ['Insurance', 'General', 'Home', 100, 1_000],
    ['Insurance', 'General', 'Shop Keepers Policy', 100, 2_000],
    ['Insurance', 'General', 'Office Insurance', 100, 2_500],
    ['Insurance', 'General', 'Fire & Burglary', 100, 5_000],
    ['Insurance', 'General', 'Liability Insurance', 100, 1_000],
    ['Insurance', 'General', 'Marine Insurance', 100, 3_000],
    ['Insurance', 'General', 'Workmen Compensation', 100, 3_000],
    ['Insurance', 'Motor', 'Car - Pvt Vehicle', 200, 5_000],
    ['Insurance', 'Motor', 'Taxi - PCV', 500, 7_500],
    ['Insurance', 'Motor', 'Commercial Vehicle', 1_000, 15_000],
    ['Insurance', 'Motor', '2 Wheeler', 50, 2_000],
    ['Insurance', 'Life', 'Term Insurance', 500, 20_000],
    ['Insurance', 'Life', 'ULIPs', 500, 10_000],
    ['Insurance', 'Life', 'Children Plan', 1_000, 5_000],
    ['Insurance', 'Life', 'Retirement Plan', 500, 10_000],
    ['Insurance', 'Life', 'Savings Plan', 500, 10_000],
    ['Insurance', 'Life', 'Investment Plan', 1_000, 10_000],
    ['Insurance', 'Life', 'Endowment / Guaranteed Plan', 1_000, 10_000],
    ['Insurance', 'Life', 'Income / Money Back Plan', 1_000, 10_000],
    ['Insurance', 'Life', 'Whole Life Plan', 1_000, 10_000],
    ['Insurance', 'Health', 'Individual Plan', 250, 2_000],
    ['Insurance', 'Health', 'Family Floater', 500, 5_000],
    ['Insurance', 'Health', 'Senior Citizens Plan', 250, 10_000],
    ['Insurance', 'Health', 'Out Patient Care', 100, 1_000],
    ['Insurance', 'Health', 'Youngsters Plan', 250, 2_500],
    ['Insurance', 'Health', 'Women Care Plan', 250, 10_000],
    ['Insurance', 'Health', 'Critical Illness Cover', 100, 2_500],
    ['Insurance', 'Health', 'Diabetes Safe Cover', 500, 5_000],
    ['Insurance', 'Health', 'Cardiac Care Cover', 1_000, 10_000],
    ['Insurance', 'Health', 'Cancer Care Cover', 500, 5_000],
    ['Insurance', 'Health', 'Top Up Cover', 100, 2_000],
    ['Insurance', 'Health', 'Personal Accident Plan', 50, 5_000],
    ['Insurance', 'Health', 'Family Accident Care', 100, 2_500],
    ['Insurance', 'Health', 'Rural & Farmer Care', 50, 1_000],
    ['Insurance', 'Health', 'Hospital Cash', 50, 500],
    ['Insurance', 'Health', 'Special Care (Autism)', 100, 2_500],
    ['Insurance', 'Health', 'GMC (Group Mediclaim)', 1_000, 10_000],
    ['Investments', 'Mutual Fund', 'SIP', 100, 10_000],
    ['Investments', 'Mutual Fund', 'STP', 100, 1_000],
    ['Investments', 'Mutual Fund', 'SWP', 100, 5_000],
    ['Investments', 'Fixed Deposits', 'FD', 100, 5_000],
    ['Investments', 'Bond', 'Govt / Corporate Bonds', 100, 1_000],
    ['Investments', 'Gold', 'Gold Accumulation Plan', 100, 1_000],
    ['Investments', 'LAS', 'Loan against Security', 100, 2_500],
    ['Investments', 'NPS', 'National Pension Scheme', 100, 500],
    ['Investments', 'Trading', 'Online Trading', 100, 10_000],
    ['Loans', 'Home Loan', 'Home Loan', 5_000, 50_000],
    ['Loans', 'Personal Loan', 'Personal Loan', 500, 2_500],
    ['Loans', 'Mortgage Loan', 'Mortgage Loan', 5_000, 50_000],
    ['Loans', 'Business Loan', 'Business Loan', 1_000, 10_000],
    ['Taxation', 'Tax Planning', 'Tax Planning / IT Filing', 100, 5_000],
    ['Travel', 'Domestic', 'Domestic Travel', 250, 10_000],
    ['Travel', 'International', 'International Travel', 1_000, 25_000]
  ].freeze

  Row = Struct.new(:id, :segment, :category, :sub_category, :minimum, :upto, :remarks, keyword_init: true) do
    def as_api_json
      { id: id, sub_category: sub_category, minimum: minimum, upto: upto, remarks: remarks.presence }
    end
  end

  class << self
    # Stable id per row ("insurance-life-term-insurance") so saved edits stay
    # attached to the right row even if the list order changes.
    def row_id(segment, category, sub_category)
      [segment, category, sub_category].map(&:parameterize).join('-')
    end

    def rows
      overrides = saved_overrides
      DEFAULT_ROWS.map do |segment, category, sub_category, minimum, upto|
        id = row_id(segment, category, sub_category)
        saved = overrides[id] || {}
        Row.new(
          id: id, segment: segment, category: category, sub_category: sub_category,
          minimum: saved.fetch('minimum', minimum), upto: saved.fetch('upto', upto),
          remarks: saved.fetch('remarks', '')
        )
      end
    end

    # { "Insurance" => { "Life" => [Row, ...], ... }, ... } in sheet order.
    def grouped
      rows.group_by(&:segment).transform_values { |seg_rows| seg_rows.group_by(&:category) }
    end

    # Mobile API shape: segments > categories > sub_categories.
    def as_api_json
      grouped.map do |segment, categories|
        {
          segment: segment,
          categories: categories.map do |category, cat_rows|
            {
              category: category,
              minimum: cat_rows.map(&:minimum).min,
              upto: cat_rows.map(&:upto).max,
              sub_categories: cat_rows.map(&:as_api_json)
            }
          end
        }
      end
    end

    # params: { row_id => { minimum:, upto:, remarks: } }. Returns an array of
    # error messages; nothing is saved unless every row is valid.
    def update(params)
      known = rows.index_by(&:id)
      errors = []
      overrides = {}

      params.each do |id, attrs|
        row = known[id]
        next unless row

        minimum = parse_amount(attrs[:minimum] || attrs['minimum'])
        upto    = parse_amount(attrs[:upto] || attrs['upto'])
        label   = "#{row.category} - #{row.sub_category}"

        if minimum.nil? || upto.nil?
          errors << "#{label}: Minimum and Upto must be numbers of 0 or more"
        elsif minimum > upto
          errors << "#{label}: Minimum can't be more than Upto"
        end

        overrides[id] = { 'minimum' => minimum, 'upto' => upto,
                          'remarks' => (attrs[:remarks] || attrs['remarks']).to_s.strip.first(255) }
      end

      return errors if errors.any?

      SystemSetting.set_value(
        SETTING_KEY, saved_overrides.merge(overrides).to_json,
        description: 'Incentive calculator Minimum / Upto / Remarks edited by admin (defaults live in IncentiveCalculator)',
        setting_type: 'json'
      )
      []
    end

    def reset!
      SystemSetting.find_by(key: SETTING_KEY)&.destroy
    end

    private

    def saved_overrides
      JSON.parse(SystemSetting.get_value(SETTING_KEY).presence || '{}')
    rescue JSON::ParserError
      {}
    end

    # Accepts "5,000" / "5000" / 5000; returns an Integer or nil.
    def parse_amount(value)
      cleaned = value.to_s.delete(',').strip
      return nil unless cleaned.match?(/\A\d+\z/)

      cleaned.to_i
    end
  end
end
