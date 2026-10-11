# AI Upload fallback without an AI model: reads the document's text - straight
# from the PDF with Ghostscript when it has a text layer (all pages, no size
# limit), else with OCR.space (OcrService, table mode: scans and photos, first
# 3 pages) - and pulls fields out with label rules - "Policy
# Number: 123", "Make<TAB>HYUNDAI", a date range on an "effective from ... to"
# line, a registration-number pattern, and so on.
#
# Returns the same Hash shape as AiDocumentExtractor#call (every key of the
# profile, nil when not found), so the form's review screen works unchanged.
# Rules are deliberately strict: a field is left blank rather than guessed, and
# the admin reviews everything before it is applied.
require "open3"

class OcrDocumentExtractor
  Error = AiDocumentExtractor::Error

  PDF_TEXT_PAGES = 15 # schedules sit up front; later pages are policy wording

  DATE_NUM = %r{\b(\d{1,2})[-/.](\d{1,2})[-/.](\d{4})\b}
  DATE_ISO = /\b(\d{4})-(\d{2})-(\d{2})\b/
  DATE_WORD = /\b(\d{1,2})(?:st|nd|rd|th)?[-\s\/,]*([A-Za-z]{3,9})[-\s\/,.]*(\d{4})\b/
  NUMBER = /(?<![\d\/-])(\d{1,3}(?:,\d{2,3})+(?:\.\d+)?|\d+(?:\.\d+)?)(?![\d\/]|-\d)/
  MOBILE = /(?<!\d)(?:\+?91[\s-]?|0)?([6-9]\d{9})(?!\d)/
  EMAIL = /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/
  REG_NUMBER = /\b([A-Z]{2}[\s-]?\d{1,2}[\s-]?[A-Z]{0,3}[\s-]?\d{4}|\d{2}[\s-]?BH[\s-]?\d{4}[\s-]?[A-Z]{1,2})\b/
  VIN = /\b(?=[A-HJ-NPR-Z0-9]*[A-Z])(?=[A-HJ-NPR-Z0-9]*\d)([A-HJ-NPR-Z0-9]{17})\b/
  EMPTY_VALUE = /\A(?:na|n\/a|nil|none|null|-+|\.+|not applicable)\z/i
  TITLE = /\A(?:mr|mrs|ms|miss|dr|shri|smt|kum|m\/s)\.?\s+/i
  SERVICE_EMAIL = /\A(?:omb|bimalokpal|care|customer|support|service|help|info|contact|grievance|no-?reply|claims?|admin)/i

  RELATIONSHIP_WORDS = {
    'wife' => 'spouse', 'husband' => 'spouse', 'spouse' => 'spouse', 'son' => 'son', 'daughter' => 'daughter',
    'father' => 'father', 'mother' => 'mother', 'brother' => 'brother', 'sister' => 'sister', 'self' => 'self'
  }.freeze

  MOTOR_ADDONS = {
    'Zero Depreciation' => /zero\s*dep|nil\s*dep/i, 'Roadside Assistance' => /\bRSA\b|road\s*side\s*assist/i,
    'Consumables' => /consumable/i, 'Key Replacement' => /key\s*(replacement|protect)/i,
    'Engine Protect' => /engine\s*(protect|secure|guard)/i, 'Return to Invoice' => /return\s*to\s*invoice|\bRTI\b/i,
    'NCB Protect' => /ncb\s*protect/i, 'Tyre Protect' => /tyre\s*(protect|secure|cover)/i,
    'Personal Belongings' => /personal\s*belongings|loss\s*of\s*personal/i
  }.freeze

  # field key => label patterns, best first. A pattern matches the end of a
  # cell ("...Make") or a "label: value" cell; `exclude` skips cells that
  # contain the label but mean something else (previous policy number, ...).
  LABELS = {
    'policy_number' => { labels: [/Policy\s*(?:No|Number|#)\.?/i, /Certificate\s*(?:No|Number)\.?/i], exclude: /previous|prev\b|old|expir|proposal/i },
    'plan_name' => { labels: [/Plan\s*Name/i, /Product\s*Name/i, /Policy\s*Name/i, /Name\s+of\s+(?:the\s+)?(?:Plan|Product)/i, /\APlan/i, /\AProduct/i, /\APolicy/i] },
    'insured_name' => { labels: [/\ALife\s+(?:Insured|Assured)/i, /Name\s+of\s+(?:the\s+)?Life\s+Assured/i, /Life\s+Assured(?:'s)?\s*(?:Name)?/i, /Insured(?:'s)?\s*Name/i, /Name\s+of\s+(?:the\s+)?Insured/i] },
    'proposer_name' => { labels: [/\A(?:Proposer|Policy\s*holder)/i, /(?:Proposer|Policy\s*holder|Customer|Insured|Investor|Applicant|Borrower|Account\s*holder|Unit\s*holder|First\s+Holder|Client)(?:'s)?\s*Name/i,
                                  /Name\s+of\s+(?:the\s+)?(?:Proposer|Policy\s*holder|Insured|Investor|Applicant|Borrower)/i, /Sole\s*\/?\s*First\s+Holder/i, /\AName/i],
                         exclude: /nominee|agent|intermediary|broker|bank|branch|office|company|insurer|scheme|plan|product|fund|assured|appointee/i },
    'proposer_email' => { labels: [/E-?\s?mail(?:\s*(?:Id|Address))?/i] },
    'proposer_mobile' => { labels: [/Mobile(?:\s*(?:No|Number))?/i, /Phone(?:\s*(?:No|Number))?/i, /\bCell/i, /Contact\s*(?:No|Number)/i] },
    'policy_booking_date' => { labels: [/(?:Booking|Receipt|Proposal)\s*(?:(?:No|Number)\.?\s*(?:&|and)\s*)?Date/i, /Date\s+of\s+(?:Booking|Receipt|Proposal)/i,
                                        /(?:Issue|Issuance)\s+Date/i, /Date\s+of\s+(?:Issue|Issuance)(?:\s+of\s+(?:the\s+)?Policy)?/i] },
    'policy_start_date' => { labels: [/(?:Policy\s+)?(?:Start|Commencement|Inception|Effective)\s+Date/i, /Date\s+of\s+Commencement(?:\s+of\s+(?:the\s+)?(?:Policy|Risk))?/i, /(?:Valid|Period)\s+From/i, /From\s+Date/i, /Risk\s+Start\s+Date/i] },
    'policy_end_date' => { labels: [/(?:Policy\s+)?(?:Expiry|End|Maturity)\s+Date/i, /Date\s+of\s+(?:Expiry|Maturity)/i, /Valid\s+(?:Till|Upto|Up\s+to|To)/i, /To\s+Date/i], exclude: /previous|prev\b/i },
    'risk_start_date' => { labels: [/Risk\s+(?:Commencement|Start)\s+Date/i, /Date\s+of\s+(?:Risk\s+)?Commencement/i] },
    'policy_term' => { labels: [/Policy\s+Term/i, /Benefit\s+Term/i, /Term\s*\(?\s*(?:in\s+)?Years?\)?/i, /Policy\s+Period\s*\(?\s*(?:in\s+)?Years?\)?/i] },
    'premium_payment_term' => { labels: [/Premium\s+Pay(?:ing|ment)\s+Term/i, /\bPPT/i] },
    'payment_mode' => { labels: [/(?:Premium\s+)?Payment\s+(?:Mode|Frequency)/i, /Premium\s+(?:Mode|Frequency)/i, /Mode\s+of\s+(?:Premium|Payment)/i, /Frequency/i] },
    'sum_insured' => { labels: [/(?:Basic\s+)?Sum\s+(?:Insured|Assured)/i, /Cover(?:age)?\s+Amount/i, /Amount\s+of\s+Cover/i] },
    'net_premium' => { labels: [/Net\s+Premium/i, /Premium\s*\(?\s*(?:excl|excluding|before|without|w\/o)\.?\s*(?:of\s+)?(?:GST|tax)[^)]*\)?/i,
                                /Taxable\s+(?:Value|Premium|Amount)/i, /Total\s+Premium\s+(?:before|excl\w*)\s+(?:GST|tax)/i, /Basic\s+Premium/i, /\b(?:Annuali[sz]ed|Annual|Installment|Instalment|Modal)\s+Premium/i, /\APremium/i] },
    'total_premium' => { labels: [/Total\s+Amount(?:\s+Payable)?/i, /Amount\s+Payable/i, /Total\s+Premium(?!\s+(?:before|excl))/i, /Gross\s+Premium/i, /Premium\s+Payable/i, /Total\s+Payable/i, /Amount\s+Paid/i, /Final\s+Premium/i] },
    'gst_amount' => { labels: [/\A(?:Total\s+)?GST(?:\s+Amount)?/i, /Goods\s+(?:and|&)\s+Services?\s+Tax/i, /\bIGST/i] },
    'gst_percentage' => { labels: [/GST\s*(?:%|Rate|Percentage)/i] },
    # motor
    'registration_number' => { labels: [/Regn?\.?\s*(?:No|Number|Mark)\.?/i, /Registration\s*(?:No|Number|Mark)\.?/i, /Vehicle\s*(?:No|Number)\.?/i], exclude: /date|authority|place/i },
    'registration_date' => { labels: [/Regn?\.?\s*Date/i, /Registration\s+Date/i, /Date\s+of\s+Registration/i] },
    'engine_number' => { labels: [/Engine\s*(?:or\s*M\/c\s*)?(?:No|Number)\.?/i, /Motor\s*(?:No|Number)\.?/i] },
    'chassis_number' => { labels: [/Chassis\s*(?:No|Number)?\.?/i, /\bVIN/i] },
    'make' => { labels: [/\bMake/i, /Manufacturer/i] },
    'model' => { labels: [/\bModel/i] },
    'variant' => { labels: [/\bVariant/i, /Sub[-\s]?Model/i] },
    'mfy' => { labels: [/Year\s+of\s+(?:Mfg|Manufactur\w*)\.?/i, /(?:Mfg|Manufacturing)\.?\s*Year/i, /\bYOM/i] },
    'vehicle_idv' => { labels: [/Total\s+IDV/i, /Vehicle\s+IDV/i, /IDV\s+of\s+(?:the\s+)?Vehicle/i, /Insured(?:'s)?\s+Declared\s+Value/i, /\AIDV/i], exclude: /trailer|sidecar|cng|lpg|accessor/i },
    'cng_idv' => { labels: [/(?:CNG|LPG)[^\t]{0,20}IDV/i, /IDV[^\t]{0,20}(?:CNG|LPG)/i] },
    'tp_premium' => { labels: [/(?:Total|Net)\s+(?:TP|Liability|Third\s+Party|Act)\s+(?:Premium|Liability\s+Premium)/i, /Total\s+Liability\s+Premium/i, /\A(?:TP|Liability|Third\s+Party)\s+Premium(?:\s*\(B\))?/i] },
    'od_premium' => { labels: [/(?:Total|Net)\s+(?:OD|Own\s+Damage)\s+Premium/i, /\A(?:OD|Own\s+Damage)\s+Premium(?:\s*\(A\))?/i] },
    'financier' => { labels: [/Financier(?:'s)?\s*(?:Name)?/i, /Hypothecat\w*(?:\s+(?:to|with))?/i, /Hire\s+Purchase(?:\s+with)?/i, /Financed\s+By/i, /Lease\s+Agreement\s+with/i] },
    # mutual fund / client service
    'fund_name' => { labels: [/Scheme\s*Name/i, /Fund\s*Name/i, /\AScheme/i] },
    'folio_number' => { labels: [/Folio\s*(?:No|Number)?\.?/i] },
    'mf_plan' => { labels: [/\APlan/i, /\AOption/i, /Plan\s*\/\s*Option/i] },
    'mf_amount' => { labels: [/(?:Investment|SIP|Instal+ment|Purchase)\s+Amount/i, /Amount\s+(?:Invested|Paid)/i, /\AAmount/i, /Gross\s+Amount/i] },
    'mf_start_date' => { labels: [/SIP\s+Start\s+Date/i, /Start\s+Date/i, /(?:Allotment|Transaction|Investment|Purchase)\s+Date/i, /Date\s+of\s+(?:Allotment|Investment|Purchase)/i, /NAV\s+Date/i] },
    'mf_end_date' => { labels: [/(?:SIP\s+)?(?:End|Maturity)\s+Date/i, /Lock-?in\s+(?:Up\s*to|Till|Period\s+Ends?)/i] },
    'cs_amount' => { labels: [/(?:Loan|Sanction(?:ed)?|Deposit|Principal|Fee|Booking|Credit|Card|Fare)\s+(?:Amount|Limit|Value)/i, /Amount\s+(?:Sanctioned|Paid|Deposited|Financed)/i, /Total\s+(?:Amount|Fare)/i, /\AAmount/i] },
    'cs_start_date' => { labels: [/(?:Sanction|Deposit|Filing|Travel|Journey|Issue|Booking|Value|Disbursement|Opening|Acknowledg(?:e)?ment)\s+Date/i,
                                  /Date\s+of\s+(?:Sanction|Deposit|Filing|Issue|Travel|Journey|Booking|Opening)/i, /\ADate/i] },
    'reference_number' => { labels: [/(?:Loan\s+Account|Account|FD|Deposit|Receipt|Acknowledg(?:e)?ment|Booking|Application|Card|Reference|Ref)\.?\s*(?:No|Number|#)\.?/i, /\bPNR/i] },
    'bank_name' => { labels: [/Bank\s*Name/i, /Name\s+of\s+(?:the\s+)?Bank/i] },
    'account_number' => { labels: [/(?:Bank\s+)?(?:Account|A\/c)\s*(?:No|Number)\.?/i] },
    'account_holder_name' => { labels: [/Account\s*Holder(?:'s)?\s*(?:Name)?/i] },
    'interest_rate' => { labels: [/(?:Rate\s+of\s+Interest|Interest\s+Rate|ROI)/i] },
    'tenure' => { labels: [/Tenure/i, /(?:Loan|Deposit)\s+Period/i] }
  }.freeze

  def initialize(file:, product:, field_options: {}, company_options: [], context: nil)
    @file = file
    @product = product.to_s
    @profile = AiDocumentProfiles.fetch(@product) or raise Error, "AI Upload is not available for this form."
    @field_options = field_options.to_h
    @company_options = Array(company_options).map(&:to_s).reject(&:blank?)
    @context = context.to_s
  end

  def call
    text = pdf_text || OcrService.extract_text(@file, table: true)
    raise Error, "No text could be read from this document. Try a clearer PDF or photo." if text.strip.length < 20

    @rows = text.each_line.map { |line| line.split("\t").map { |cell| clean(cell) }.reject(&:blank?) }.reject(&:empty?)
    @text = @rows.map { |cells| cells.join(' ') }.join("\n")
    @found = {}

    result = { 'proposer_name' => proposer_name, 'proposer_mobile' => mobile, 'proposer_email' => email }
    @profile[:fields].each do |field|
      next if field[:kind] == :customer

      result[field[:key]] = field[:type] == :rows ? [] : nil
    end

    send("extract_#{@product}", result)
    result.each_key { |key| result[key] = nil if result[key].is_a?(String) && result[key].blank? }
    result
  rescue OcrService::ExtractionError, OcrService::ConfigurationError => e
    Rails.logger.warn "[AI Upload] OCR failed: #{e.message}"
    raise Error, "Could not read this document: #{e.message}"
  end

  private

  # Text layer of a digital PDF via Ghostscript, with column gaps (2+ spaces)
  # turned into tabs so it reads like OCR.space table output. nil for scans,
  # images, or if Ghostscript isn't available.
  def pdf_text
    io = @file.respond_to?(:tempfile) ? @file.tempfile : @file
    path = io.respond_to?(:path) ? io.path : nil
    return nil unless path && File.binread(path, 5) == "%PDF-"

    out, _err, status = Open3.capture3('gs', '-q', '-dNOPAUSE', '-dBATCH', '-dSAFER', '-sDEVICE=txtwrite',
                                 '-dFirstPage=1', "-dLastPage=#{PDF_TEXT_PAGES}", '-sOutputFile=-', path)
    return nil unless status.success?

    text = out.force_encoding('UTF-8').scrub('').gsub(/[^\S\n]{2,}/, "\t")
    text if text.scan(/[A-Za-z]{3,}/).size >= 40
  rescue Errno::ENOENT, IOError => e
    Rails.logger.warn "[AI Upload] pdf text: #{e.message}"
    nil
  end

  # ---- per product --------------------------------------------------------

  def extract_motor(r)
    r['policy_number'] = policy_number
    r['insurance_company_name'] = company
    r['registration_number'] = registration_number
    r['engine_number'] = token(value('engine_number', :string), 5..25)
    r['chassis_number'] = token(value('chassis_number', :string), 6..25) || @text[VIN, 1]
    r['make'] = short(value('make', :string))
    r['model'] = short(value('model', :string))
    r['variant'] = short(value('variant', :string))
    r['mfy'] = year(value('mfy', :integer))
    r['vehicle_idv'] = value('vehicle_idv', :money)
    r['cng_idv'] = value('cng_idv', :money)
    r['financier'] = short(value('financier', :string))
    dates_into(r)

    od, tp = od_tp_premiums
    taxable = value('net_premium', :money)
    r['tp_premium'] = tp
    r['net_premium'] = od || (taxable - tp if taxable && tp && taxable > tp) || (taxable unless tp)
    r['total_premium'] = value('total_premium', :money)
    r['gst_percentage'] = gst_percentage(r['net_premium'].to_f + r['tp_premium'].to_f, r['total_premium'])

    r['class_of_vehicle'] = option('class_of_vehicle', scan: true)
    r['insurance_type'] = option('insurance_type', motor_insurance_type)
    r['vehicle_type'] = option('vehicle_type', old_vehicle? ? /old|used|existing|rollover/i : /\Anew/i)
    r['policy_type'] = option('policy_type', motor_policy_type(r['insurance_company_name']))
    r['payment_mode'] = payment_mode(r)
    r['nominees'] = nominees
    addons = MOTOR_ADDONS.select { |_, pattern| @text.match?(pattern) }.keys
    r['notes'] = "Add-ons: #{addons.join(', ')}" if addons.any?
  end

  def extract_health(r)
    insurance_common(r)
    r['insurance_type'] = option('insurance_type', scan: true)
    r['members'] = []
  end

  def extract_life(r)
    insurance_common(r)
    r['insured_name'] = person(value('insured_name', :string))
    r['risk_start_date'] = value('risk_start_date', :date)
    r['premium_payment_term'] = value('premium_payment_term', :integer)&.then { |n| n if n.between?(1, 99) }
    r['bank_name'] = short(value('bank_name', :string))
    r['account_number'] = token(value('account_number', :string), 6..20)&.then { |n| n if n.match?(/\A\d+\z/) }
    r['ifsc_code'] = @text[/\b([A-Z]{4}0[A-Z0-9]{6})\b/, 1]
    r['account_holder_name'] = person(value('account_holder_name', :string))
  end

  def extract_general(r)
    insurance_common(r)
    r['insurance_type'] = option('insurance_type', @context.presence) || option('insurance_type', scan: true)
    r['claim_process'] = option('claim_process', scan: true)
  end

  def extract_mutual_fund(r)
    r['fund_name'] = short(value('fund_name', :string), 120)
    r['folio_number'] = token(value('folio_number', :string), 4..25, slash: true)
    r['plan_name'] = short(value('mf_plan', :string))
    r['amount'] = value('mf_amount', :money)
    r['start_date'] = value('mf_start_date', :date)
    r['maturity_date'] = value('mf_end_date', :date)
  end

  def extract_client_service(r)
    r['amount'] = value('cs_amount', :money)
    r['start_date'] = value('cs_start_date', :date)
    r['reference_number'] = token(value('reference_number', :string), 4..30, slash: true)
    notes = []
    notes << "Interest: #{short(value('interest_rate', :string), 40)}" if value('interest_rate', :string)
    notes << "Tenure: #{short(value('tenure', :string), 40)}" if value('tenure', :string)
    r['notes'] = notes.join('; ').first(300).presence
  end

  # Fields shared by the health / life / general policy forms.
  def insurance_common(r)
    r['policy_number'] = policy_number
    r['insurance_company_name'] = company
    r['plan_name'] = short(value('plan_name', :string), 120)
    dates_into(r)
    r['sum_insured'] = value('sum_insured', :money)
    r['net_premium'] = value('net_premium', :money)
    r['total_premium'] = value('total_premium', :money)
    r['gst_percentage'] = gst_percentage(r['net_premium'], r['total_premium'])
    r['policy_term'] = value('policy_term', :integer)&.then { |n| n if n.between?(1, 99) } || term_from_dates(r)
    r['policy_type'] = option('policy_type', previous_policy? ? /renew|roll|port/i : nil)
    r['payment_mode'] = payment_mode(r)
    r['nominees'] = nominees
  end

  # ---- label lookup -------------------------------------------------------

  # First value of the given type found next to one of the field's labels:
  # "Label: value" in one cell, the next cell on the row, or the line below.
  def value(key, type)
    return @found[[key, type]] if @found.key?([key, type])

    @found[[key, type]] = labeled_candidates(key).lazy.filter_map { |candidate| coerce(candidate, type) }.first
  end

  # Every raw value printed next to the field's labels, best label first.
  def labeled_candidates(key)
    spec = LABELS.fetch(key)
    Enumerator.new do |out|
      spec[:labels].each do |label|
        @rows.each_with_index do |cells, row|
          cells.each_with_index do |cell, i|
            next if spec[:exclude] && cell.match?(spec[:exclude])

            candidates_for(cell, label, cells, i, row).each { |candidate| out << candidate }
          end
        end
      end
    end
  end

  # A label may end with a unit or a fragment wrapped onto the next line:
  # "Sum Assured (Rs.)", "Premium Payment Term (in", "Date of Commencement of".
  LABEL_TAIL = /(?:\s*\(\s*[\w.₹%]{0,10}(?:\s+[\w.]{1,8})?\s*\)?)?(?:\s+(?:of|as|on|for|in|with))?\s*[:.\-–*]*/.source
  INLINE_LABELS = Hash.new { |h, label| h[label] = /\A.{0,40}?#{label.source}\s*[:\-–=]+\s*(.+)\z/i }
  TRAILING_LABELS = Hash.new { |h, label| h[label] = /#{label.source}#{LABEL_TAIL}\z/i }

  def candidates_for(cell, label, cells, index, row)
    # A lone lowercase word is a word of a sentence, not a label (OCR noise can
    # put lowercase junk before a real label: "ariad Make").
    return [] unless cell.match?(label) && !cell.match?(/\A[a-z]\S*\z/) && !prose?(cells)

    if (m = cell.match(INLINE_LABELS[label]))
      [m[1]]
    elsif cell.length <= 60 && cell.match?(TRAILING_LABELS[label])
      # The cell to the right, else the line below - skipping cells that are
      # themselves another "Label: value" (a neighbouring column).
      [cells[index + 1], @rows[row + 1]&.first, @rows[row + 2]&.first].compact.reject { |c| c.match?(/[A-Za-z]{3,}[A-Za-z .]*:\s*\S/) }
    else
      []
    end
  end

  # Justified paragraphs come out as many short cells, mostly lowercase words.
  def prose?(cells)
    cells.size >= 4 && cells.count { |c| c.match?(/\A[a-z]/) } >= 2
  end

  def coerce(raw, type)
    raw = raw.to_s.strip
    return nil if raw.empty? || raw.match?(EMPTY_VALUE)

    case type
    when :date then date(raw)
    when :money then money(raw)
    when :integer then raw[/\A\D{0,3}(\d{1,4})\b/, 1]&.to_i
    when :string then raw.match?(/\A[a-z]|[:,;]\z|\A\d{1,3}\.\s/) || raw.length > 150 ? nil : raw
    end
  end

  # ---- typed parsing ------------------------------------------------------

  def date(raw)
    if (m = raw.match(DATE_ISO))
      build_date(m[1], m[2], m[3])
    elsif (m = raw.match(DATE_NUM))
      build_date(m[3], m[2], m[1]) # Indian documents are day-first
    elsif (m = raw.match(DATE_WORD))
      month = Date::ABBR_MONTHNAMES.index(m[2][0, 3].capitalize)
      build_date(m[3], month, m[1]) if month
    end
  end

  def build_date(year, month, day)
    Date.new(year.to_i, month.to_i, day.to_i).then { |d| d.iso8601 if d.year.between?(1950, 2100) }
  rescue ArgumentError
    nil
  end

  def all_dates(line)
    found = []
    rest = line
    while (d = first_date_with_offset(rest))
      found << d[0]
      rest = rest[d[1]..]
    end
    found
  end

  def first_date_with_offset(line)
    [DATE_ISO, DATE_NUM, DATE_WORD].filter_map { |re| (m = line.match(re)) && [m, m.begin(0)] }
                                   .sort_by(&:last)
                                   .each { |m, _| (d = date(m[0])) and return [d, m.end(0)] }
    nil
  end

  def money(raw)
    return nil if raw.match?(/\A\s*\d{1,2}[-\/.]\d{1,2}[-\/.]\d{2,4}/)

    m = raw.match(/#{NUMBER.source}\s*(lakhs?|lacs?|crores?|cr\b)?/i) or return nil
    amount = m[1].delete(',').to_f
    amount *= 100_000 if m[2].to_s.match?(/\Al/i)
    amount *= 10_000_000 if m[2].to_s.match?(/\Ac/i)
    return nil unless amount.positive?

    (amount % 1).zero? ? amount.to_i : amount.round(2)
  end

  def token(raw, length, slash: false)
    pattern = slash ? %r{[A-Z0-9][A-Z0-9/\-]*[A-Z0-9]}i : /[A-Z0-9][A-Z0-9\-]*[A-Z0-9]/i
    raw.to_s.scan(pattern).find { |t| length.cover?(t.length) && t.match?(/\d/) }&.upcase
  end

  def short(raw, max = 60)
    s = raw.to_s.strip.sub(/\A[:\-.]+\s*/, '')
    s.present? && s.length <= max && !s.match?(EMPTY_VALUE) ? s : nil
  end

  def year(n)
    n if n && n.between?(1980, Date.current.year + 1)
  end

  def person(raw)
    name = raw.to_s.sub(TITLE, '').split(/\s{2,}|,|\(|\bS\/o\b|\bD\/o\b|\bW\/o\b/i).first.to_s.strip
    name if name.match?(/\A[A-Za-z][A-Za-z .']{1,60}\z/) && !name.match?(/\b(?:gender|age|relationship|date|birth|name|address|nominee|same person)\b/i)
  end

  # ---- specific fields ----------------------------------------------------

  def policy_number
    raw = value('policy_number', :string).to_s
    raw = raw.delete(' ') if raw.match?(/\A\d{2,6}(?: \d{2,6}){2,}\z/) # "2999 2000 1234 5678"
    token(raw, 5..40, slash: true)
  end

  def proposer_name
    person(value('proposer_name', :string))
  end

  def mobile
    labeled_candidates('proposer_mobile').lazy.filter_map { |c| c[MOBILE, 1] }.first || @text[MOBILE, 1]
  end

  def email
    customer = ->(e) { !e.split('@').first.match?(SERVICE_EMAIL) }
    labeled = value('proposer_email', :string).to_s.scan(EMAIL).find(&customer)
    labeled || @text.scan(EMAIL).find(&customer)
  end

  def registration_number
    labeled = value('registration_number', :string).to_s.upcase[REG_NUMBER, 1]
    (labeled || @text.upcase[REG_NUMBER, 1])&.gsub(/\s+/, '-')
  end

  # Insurer: an option from the form's dropdown whose name appears in the text,
  # else the first "... Insurance Company Ltd" style name printed.
  def company
    normalized = normalize(@text)
    from_options = @company_options.filter_map do |name|
      core = normalize(name.gsub(/\b(?:co|company|ltd|limited|pvt|private|the|of|india)\b\.?/i, ' '))
      [name, core.length] if core.length >= 4 && " #{normalized} ".include?(" #{core} ")
    end.max_by(&:last)&.first
    from_options || @text[/\b((?:[A-Z][A-Za-z&.]*\s+){1,5}(?:General\s+|Life\s+|Health\s+)?(?:Insurance|Assurance)\s+(?:Co(?:mpany)?\.?\s+)?(?:Ltd|Limited)\.?)/, 1]&.strip
  end

  def dates_into(r)
    start_date, end_date = policy_period
    r['policy_start_date'] = start_date || value('policy_start_date', :date)
    r['policy_end_date'] = end_date || value('policy_end_date', :date)
    r['policy_booking_date'] = value('policy_booking_date', :date) if r.key?('policy_booking_date')
  end

  # "Period of insurance: 19-01-2025 to 18-01-2026" / "Effective from ... on
  # 19-01-2025 ... to midnight of 18-01-2026": two dates on one period line.
  def policy_period
    @text.each_line do |line|
      next unless line.match?(/period|effective|valid|cover|insurance\s+from|from\b.*\bto\b/i)
      next if line.match?(/previous|prev\b|expiry\s+date\s+of\s+previous/i)

      found = all_dates(line)
      next unless found.size >= 2

      start_date, end_date = found.first, found.last
      return [start_date, end_date] if end_date > start_date
    end
    nil
  end

  # Motor premium schedules print OD and TP breakups side by side, each ending
  # in its own "Total" - read those columns, else use labelled totals.
  def od_tp_premiums
    od = value('od_premium', :money)
    tp = value('tp_premium', :money)
    return [od, tp] if od && tp

    header = @rows.index { |cells| cells.count { |c| c.match?(/(?:\bOD\b|Own\s+Damage|\bTP\b|Liability|Third\s+Party).*Premium/i) } == 2 }
    return [od, tp] unless header

    totals = { od: nil, tp: nil }
    @rows[(header + 1)..(header + 15)].to_a.each do |cells|
      pairs = cells.each_slice(2).to_a
      pairs.each_with_index do |(label, amount), column|
        next unless label.match?(/\A(?:Net\s+)?Total\b/i) && (number = money(amount.to_s))

        side = pairs.size > 1 ? (column.zero? ? :od : :tp) : (totals[:od] ? :tp : :od)
        totals[side] ||= number
      end
      break if totals.values.all?
    end
    [od || totals[:od], tp || totals[:tp]]
  end

  def gst_percentage(net, total)
    explicit = value('gst_percentage', :string).to_s[/(\d+(?:\.\d+)?)\s*%?/, 1]&.to_f
    return explicit if explicit&.between?(0.1, 28)

    gst = value('gst_amount', :money)
    gst ||= (total - net if total && net.to_f.positive? && total > net)
    return nil unless gst && net.to_f.positive?

    rate = gst.to_f / net * 100
    [18, 12, 5, 4.5, 2.25].find { |known| (rate - known).abs <= 0.5 }
  end

  def term_from_dates(r)
    return nil unless r['policy_start_date'] && r['policy_end_date']

    days = (Date.parse(r['policy_end_date']) - Date.parse(r['policy_start_date'])).to_i
    (days / 365.0).round if days >= 360 && (days % 365 <= 5 || days % 365 >= 360)
  end

  def payment_mode(r)
    labeled = value('payment_mode', :string)
    synonyms = { /annual|yearly|\bp\.?a\.?\b/i => /\A(?:annual|yearly)/i, /half|semi/i => /half|semi/i,
                 /quarter/i => /quarter/i, /month/i => /month/i, /single|one[\s-]?time/i => /single|one/i }
    if labeled
      synonyms.each { |said, opt| return option('payment_mode', opt) if labeled.match?(said) }
    end
    option('payment_mode', /\A(?:annual|yearly)/i) if term_from_dates(r) == 1 && @product.in?(%w[motor health general])
  end

  def motor_insurance_type
    return /third|\btp\b|liability/i if @text.match?(/liability\s+only|third\s+party\s+only|\bTP\s+only|Act\s+only/i)
    return /own\s*damage|\bod\b|standalone/i if @text.match?(/stand\s*alone\s+OD|own\s+damage\s+only|\bOD\s+only/i)

    /comprehensive|package|bundled/i if @text.match?(/package|comprehensive|bundled/i)
  end

  def old_vehicle?
    reg_date = value('registration_date', :date)
    reg_date ? Date.parse(reg_date) < Date.current - 1.year : previous_policy?
  end

  # Previous policy with another insurer = Rollover, same insurer = Renewal.
  def motor_policy_type(company)
    return /\Anew/i unless previous_policy?

    previous = @rows.find { |cells| cells.any? { |c| c.match?(/Previous\s+(?:Policy|Insurer)|Prev\.?\s+Policy/i) } }.to_a.join(' ')
    insurer_word = normalize(company).split.first
    insurer_word && normalize(previous).include?(insurer_word) ? /renew/i : /roll/i
  end

  def previous_policy?
    @rows.any? do |cells|
      cells.each_with_index.any? do |cell, i|
        cell.match?(/Previous\s+Policy|Prev\.?\s+Policy|Previous\s+Insurer/i) &&
          (cells[i + 1] || cell.split(/[:\-]/, 2)[1]).to_s.then { |v| v.match?(/\d{4,}|[A-Za-z]{3,}/) && !v.strip.match?(EMPTY_VALUE) }
      end
    end
  end

  # "Nominee: BABITHA, Spouse" / "Nominee Name: X  Relationship: Wife  Age: 45",
  # or a nominee table: a row starting "Name<TAB>Wife<TAB>...<TAB>32<TAB>100".
  def nominees
    (inline_nominees + table_nominees).uniq { |n| n['name'].downcase }.first(4)
  end

  def table_nominees
    header = @rows.index { |cells| cells.any? { |c| c.match?(/Nominee/i) } } or return []
    @rows[(header + 1)..(header + 12)].to_a.filter_map do |cells|
      relation = RELATIONSHIP_WORDS[cells[1].to_s.downcase] or next
      name = person(cells[0]) or next
      numbers = cells[2..].to_a.flat_map(&:split).select { |t| t.match?(/\A\d{1,3}\z/) }.map(&:to_i)
      age = numbers.find { |n| n.between?(0, 110) }
      share = numbers[numbers.index(age).to_i + 1] if age
      { 'name' => name, 'relationship' => relation == 'self' ? nil : relation, 'age' => age, 'share_percentage' => (share if share&.between?(1, 100)) }
    end
  end

  def inline_nominees
    @text.each_line.filter_map do |line|
      m = line.match(/Nominee(?:'s)?\s*(?:Name)?\s*[:\-]\s*([A-Za-z][A-Za-z .]{1,50}?)\s*(?:,|\(|Relation(?:ship)?\s*(?:with\s+\w+)?\s*[:\-]?|\z|\t|\s{2})\s*([A-Za-z]+)?/i) or next
      name = person(m[1]) or next
      relation = RELATIONSHIP_WORDS[m[2].to_s.downcase] ||
                 RELATIONSHIP_WORDS[line[/Relation(?:ship)?[^:]*[:\-]\s*([A-Za-z]+)/i, 1].to_s.downcase]
      age = line[/Age\s*[:\-]?\s*(\d{1,3})/i, 1]&.to_i
      { 'name' => name, 'relationship' => relation == 'self' ? nil : relation, 'age' => age, 'share_percentage' => nil }
    end
  end

  # Value of the form's <select> for `key`: the option matching `pattern`, or
  # with scan: the longest option whose words are printed in the document.
  def option(key, pattern = nil, scan: false)
    options = Array(@field_options[key]).map(&:to_s).reject(&:blank?)
    return nil if options.empty?

    if pattern.is_a?(Regexp)
      options.find { |o| o.match?(pattern) }
    elsif pattern.is_a?(String)
      wanted = normalize(pattern)
      options.find { |o| normalize(o) == wanted } || options.find { |o| normalize(o).include?(wanted) || wanted.include?(normalize(o)) }
    elsif scan
      text = " #{normalize(@text)} "
      options.select { |o| normalize(o).length >= 4 && text.include?(" #{normalize(o)} ") }.max_by(&:length)
    end
  end

  def normalize(s)
    s.to_s.downcase.gsub(/[^a-z0-9]+/, ' ').strip
  end

  def clean(cell)
    # Drops Devanagari (bilingual schedules print Hindi beside each label).
    cell.to_s.gsub(/[\u0900-\u097F]+/, ' ').squeeze(' ').strip.sub(/\A[·•*₹|]+\s*/, '').strip
  end
end
