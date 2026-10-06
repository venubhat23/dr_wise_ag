# Per-product field maps for AI Upload (beta). One entry per product
# creation form: what to ask Claude for (schema type) and where it goes on the
# form (CSS selector). AiDocumentExtractor builds the JSON schema from these;
# admin/shared/_ai_upload.html.erb fills the form from the same list, in order.
#
# Field keys:
#   type:   :string :number :integer :date :select :rows - :select takes its
#           allowed values from the form's own <select> options at upload time
#   target: CSS selector of the form control
#   kind:   how the browser fills it (default from type) - :customer (matched
#           client id), :company (insurer, matched against the dropdown when
#           applied), :sum_text ("10 lakhs" into a text box + raw number into
#           `hidden`), :upper, :append (added to a notes box)
#   money:  show as rupees in the review table
#   info:   shown in review only, never written (e.g. a total the form computes)
#   hint:   extra description for Claude
#   rows:   { add: add-row button, row: row selector, fields: [...] } - each
#           row field's target is relative to the row
module AiDocumentProfiles
  RELATIONSHIPS = %w[self spouse son daughter father mother brother sister other].freeze

  NOMINEE_FIELDS = [
    { key: 'name', label: 'Name', type: :string, target: '[name$="[nominee_name]"]' },
    { key: 'relationship', label: 'Relationship', type: :enum, values: RELATIONSHIPS - ['self'], target: '[name$="[relationship]"]' },
    { key: 'age', label: 'Age', type: :integer, target: '[name$="[age]"]' },
    { key: 'share_percentage', label: 'Share %', type: :number, target: '[name$="[share_percentage]"]' }
  ].freeze

  def self.common_policy_hints
    <<~HINTS
      - Amounts are rupees as plain numbers (no commas or symbols). "90 lakhs" is 9000000.
      - Dates are YYYY-MM-DD. Indian documents write dates day-first (05/04/2024 is 5 April 2024).
      - Premiums are per installment for the stated payment mode. net_premium excludes GST.
      - The proposer (policyholder) can differ from the insured person.
    HINTS
  end

  PROFILES = {
    'life' => {
      label: 'Life Insurance',
      document: 'an Indian life insurance policy document (policy schedule, proposal form or premium receipt)',
      fields: [
        { key: 'customer', label: 'Client', kind: :customer, target: '#customer_select' },
        { key: 'policy_number', label: 'Policy Number', type: :string, target: '[name="life_insurance[policy_number]"]' },
        { key: 'insurance_company_name', label: 'Insurance Company', type: :string, kind: :company, target: '#life_insurance_insurance_company_name' },
        { key: 'plan_name', label: 'Plan Name', type: :string, target: '[name="life_insurance[plan_name]"]' },
        { key: 'policy_type', label: 'Policy Type', type: :select, target: '[name="life_insurance[policy_type]"]' },
        { key: 'payment_mode', label: 'Payment Mode', type: :select, target: '#payment_mode_select' },
        { key: 'insured_name', label: 'Insured Name', type: :string, target: '[name="life_insurance[insured_name]"]', hint: 'Life assured full name' },
        { key: 'policy_booking_date', label: 'Booking Date', type: :date, target: '[name="life_insurance[policy_booking_date]"]' },
        { key: 'policy_start_date', label: 'Start Date', type: :date, target: '#start_date' },
        { key: 'policy_end_date', label: 'End Date', type: :date, target: '#end_date' },
        { key: 'risk_start_date', label: 'Risk Start Date', type: :date, target: '[name="life_insurance[risk_start_date]"]' },
        { key: 'policy_term', label: 'Policy Term (years)', type: :integer, target: '[name="life_insurance[policy_term]"]' },
        { key: 'premium_payment_term', label: 'Premium Paying Term (years)', type: :integer, target: '[name="life_insurance[premium_payment_term]"]' },
        { key: 'sum_insured', label: 'Sum Insured', type: :number, money: true, kind: :sum_text, target: '#sum_insured_text_input', hidden: '[name="life_insurance[sum_insured]"]', hint: 'Sum assured' },
        { key: 'gst_percentage', label: 'First Year GST %', type: :number, target: '#first_year_gst', hint: 'GST rate on the first-year premium, e.g. 4.5 or 18' },
        { key: 'net_premium', label: 'Net Premium', type: :number, money: true, target: '#net_premium' },
        { key: 'total_premium', label: 'Total Premium', type: :number, money: true, info: 'calculated by the form' },
        { key: 'nominees', label: 'Nominees', type: :rows, rows: { add: '#nominees-section button[onclick="addNewNominee()"]', row: '.nominee-row', fields: NOMINEE_FIELDS } },
        { key: 'bank_name', label: 'Bank Name', type: :string, target: '[name="life_insurance[bank_name]"]' },
        { key: 'account_number', label: 'Account Number', type: :string, target: '[name="life_insurance[account_number]"]' },
        { key: 'ifsc_code', label: 'IFSC Code', type: :string, kind: :upper, target: '[name="life_insurance[ifsc_code]"]' },
        { key: 'account_holder_name', label: 'Account Holder', type: :string, target: '[name="life_insurance[account_holder_name]"]' },
        { key: 'notes', label: 'Notes', type: :string, kind: :append, target: '[name="life_insurance[extra_note]"]', hint: 'Riders, bonus or anything important without a field above; max 300 characters' }
      ]
    },

    'health' => {
      label: 'Health Insurance',
      document: 'an Indian health insurance policy document (policy schedule, proposal form or premium receipt)',
      fields: [
        { key: 'customer', label: 'Client', kind: :customer, target: '#customer_select' },
        { key: 'policy_number', label: 'Policy Number', type: :string, target: '[name="health_insurance[policy_number]"]' },
        { key: 'insurance_company_name', label: 'Insurance Company', type: :string, kind: :company, target: '#health_insurance_insurance_company_name' },
        { key: 'plan_name', label: 'Plan Name', type: :string, target: '[name="health_insurance[plan_name]"]' },
        { key: 'policy_type', label: 'Policy Type', type: :select, target: '#policy_type_select' },
        { key: 'insurance_type', label: 'Insurance Type', type: :select, target: '#insurance_type_select', hint: 'Individual, family floater or group cover' },
        { key: 'payment_mode', label: 'Payment Mode', type: :select, target: '#payment_mode_select' },
        { key: 'policy_booking_date', label: 'Booking Date', type: :date, target: '[name="health_insurance[policy_booking_date]"]' },
        { key: 'policy_start_date', label: 'Start Date', type: :date, target: '#start_date' },
        { key: 'policy_end_date', label: 'End Date', type: :date, target: '#end_date' },
        { key: 'policy_term', label: 'Policy Term (years)', type: :integer, target: '[name="health_insurance[policy_term]"]' },
        { key: 'sum_insured', label: 'Sum Insured', type: :number, money: true, kind: :sum_text, target: '#sum_insured_text_input', hidden: '[name="health_insurance[sum_insured]"]' },
        { key: 'gst_percentage', label: 'GST %', type: :number, target: '#gst_percentage' },
        { key: 'net_premium', label: 'Net Premium', type: :number, money: true, target: '#net_premium' },
        { key: 'total_premium', label: 'Total Premium', type: :number, money: true, info: 'calculated by the form' },
        { key: 'members', label: 'Insured Members', type: :rows, rows: { add: '#add_family_member', row: '.family-member-row', fields: [
          { key: 'name', label: 'Name', type: :string, target: '[name$="[member_name]"]' },
          { key: 'age', label: 'Age', type: :integer, target: '[name$="[age]"]' },
          { key: 'relationship', label: 'Relationship', type: :enum, values: RELATIONSHIPS, target: '[name$="[relationship]"]', hint: 'Relationship to the proposer' },
          { key: 'sum_insured', label: 'Sum Insured', type: :number, target: '[name$="[sum_insured]"]' }
        ] } },
        { key: 'nominees', label: 'Nominees', type: :rows, rows: { add: '#add_nominee', row: '.nominee-row', fields: NOMINEE_FIELDS } }
      ]
    },

    'motor' => {
      label: 'Motor Insurance',
      document: 'an Indian motor (car / two-wheeler / commercial vehicle) insurance policy document',
      hints: "- net_premium is the own-damage / net premium excluding third-party (TP) premium and GST; tp_premium is the third-party premium.\n- vehicle_idv is the insured declared value of the vehicle; cng_idv is the CNG/LPG kit IDV if any.",
      fields: [
        { key: 'customer', label: 'Client', kind: :customer, target: '#customer_select' },
        { key: 'registration_number', label: 'Registration Number', type: :string, kind: :upper, target: '[name="motor_insurance[registration_number]"]' },
        { key: 'vehicle_type', label: 'Vehicle Type', type: :select, target: '#vehicle_type_select', hint: 'New vehicle or old (used) vehicle' },
        { key: 'insurance_company_name', label: 'Insurance Company', type: :string, kind: :company, target: '#motor_insurance_insurance_company_name' },
        { key: 'insurance_type', label: 'Insurance Type', type: :select, target: '#insurance_type_select' },
        { key: 'class_of_vehicle', label: 'Class of Vehicle', type: :select, target: '#class_of_vehicle_select' },
        { key: 'policy_type', label: 'Policy Type', type: :select, target: '#policy_type_select' },
        { key: 'policy_number', label: 'Policy Number', type: :string, target: '[name="motor_insurance[policy_number]"]' },
        { key: 'policy_booking_date', label: 'Booking Date', type: :date, target: '[name="motor_insurance[policy_booking_date]"]' },
        { key: 'policy_start_date', label: 'Start Date', type: :date, target: '#policy_start_date' },
        { key: 'policy_end_date', label: 'End Date', type: :date, target: '#policy_end_date' },
        { key: 'payment_mode', label: 'Payment Mode', type: :select, target: '#payment_mode_select' },
        { key: 'gst_percentage', label: 'GST %', type: :number, target: '#gst_percentage' },
        { key: 'net_premium', label: 'Net Premium', type: :number, money: true, target: '#net_premium' },
        { key: 'tp_premium', label: 'TP Premium', type: :number, money: true, target: '#tp_premium' },
        { key: 'total_premium', label: 'Total Premium', type: :number, money: true, info: 'calculated by the form' },
        { key: 'vehicle_idv', label: 'Vehicle IDV', type: :number, money: true, target: '#vehicle_idv' },
        { key: 'cng_idv', label: 'CNG IDV', type: :number, money: true, target: '#cng_idv' },
        { key: 'make', label: 'Make', type: :string, target: '[name="motor_insurance[make]"]' },
        { key: 'model', label: 'Model', type: :string, target: '[name="motor_insurance[model]"]' },
        { key: 'variant', label: 'Variant', type: :string, target: '[name="motor_insurance[variant]"]' },
        { key: 'mfy', label: 'Manufacturing Year', type: :integer, target: '[name="motor_insurance[mfy]"]' },
        { key: 'engine_number', label: 'Engine Number', type: :string, kind: :upper, target: '[name="motor_insurance[engine_number]"]' },
        { key: 'chassis_number', label: 'Chassis Number', type: :string, kind: :upper, target: '[name="motor_insurance[chassis_number]"]' },
        { key: 'financier', label: 'Financier', type: :string, target: '[name="motor_insurance[financier]"]', hint: 'Hypothecation / loan provider' },
        { key: 'nominees', label: 'Nominees', type: :rows, rows: { add: 'button[onclick="addNewNominee()"]', row: '.nominee-row', fields: NOMINEE_FIELDS } },
        { key: 'notes', label: 'Notes', type: :string, kind: :append, target: '[name="motor_insurance[extra_note]"]', hint: 'Add-on covers (zero dep, RSA...) or anything important without a field above; max 300 characters' }
      ]
    },

    'general' => {
      label: 'General Insurance',
      document: 'an Indian general insurance policy document (travel, home, personal accident, property, cyber, marine, etc.)',
      fields: [
        { key: 'customer', label: 'Client', kind: :customer, target: '#customer_select' },
        { key: 'insurance_type', label: 'Insurance Type', type: :select, target: '[name="other_insurance[insurance_type]"]' },
        { key: 'insurance_company_name', label: 'Insurance Company', type: :string, kind: :company, target: '#other_insurance_insurance_company_name' },
        { key: 'policy_type', label: 'Policy Type', type: :select, target: '#policy_type_select' },
        { key: 'policy_number', label: 'Policy Number', type: :string, target: '[name="other_insurance[policy_number]"]' },
        { key: 'plan_name', label: 'Plan Name', type: :string, target: '[name="other_insurance[plan_name]"]' },
        { key: 'payment_mode', label: 'Payment Mode', type: :select, target: '#payment_mode_select' },
        { key: 'policy_booking_date', label: 'Booking Date', type: :date, target: '[name="other_insurance[policy_booking_date]"]' },
        { key: 'policy_start_date', label: 'Start Date', type: :date, target: '#start_date' },
        { key: 'policy_end_date', label: 'End Date', type: :date, target: '#end_date' },
        { key: 'policy_term', label: 'Policy Term (years)', type: :integer, target: '[name="other_insurance[policy_term]"]' },
        { key: 'sum_insured', label: 'Sum Insured', type: :number, money: true, target: '[name="other_insurance[sum_insured]"]' },
        { key: 'gst_percentage', label: 'GST %', type: :number, target: '#gst_percentage_field' },
        { key: 'net_premium', label: 'Net Premium', type: :number, money: true, target: '#net_premium_field' },
        { key: 'total_premium', label: 'Total Premium', type: :number, money: true, info: 'calculated by the form' },
        { key: 'claim_process', label: 'Claim Process', type: :select, target: '#claim_process_select' },
        { key: 'nominees', label: 'Nominees', type: :rows, rows: { add: '#add_nominee', row: '.nominee-row', fields: NOMINEE_FIELDS } }
      ]
    },

    'mutual_fund' => {
      label: 'Mutual Fund',
      document: 'an Indian mutual fund document (account statement, transaction confirmation or SIP registration)',
      hints: '- amount is the investment / SIP amount in rupees.',
      fields: [
        { key: 'customer', label: 'Client', kind: :customer, target: '#mf_customer_select', hint: 'Investor / first holder' },
        { key: 'fund_name', label: 'Fund Name', type: :string, target: '[name="mutual_fund[fund_name]"]', hint: 'Scheme name' },
        { key: 'folio_number', label: 'Folio Number', type: :string, target: '[name="mutual_fund[folio_number]"]' },
        { key: 'plan_name', label: 'Plan', type: :string, target: '[name="mutual_fund[plan_name]"]', hint: 'e.g. Direct Growth, Regular IDCW' },
        { key: 'amount', label: 'Amount', type: :number, money: true, target: '#mf_amount' },
        { key: 'start_date', label: 'Start Date', type: :date, target: '[name="mutual_fund[start_date]"]', hint: 'Investment or SIP start date' },
        { key: 'maturity_date', label: 'Maturity / End Date', type: :date, target: '[name="mutual_fund[maturity_date]"]' }
      ]
    },

    'client_service' => {
      label: 'Service',
      document: 'a financial product document (loan sanction letter, fixed deposit receipt, tax filing acknowledgement, travel booking, credit card welcome letter, etc.)',
      hints: '- amount is the main amount of the record: loan amount, deposit amount, fee paid, booking value or card limit.',
      fields: [
        { key: 'customer', label: 'Client', kind: :customer, target: '#cs_customer_select' },
        { key: 'amount', label: 'Amount', type: :number, money: true, target: '#cs_amount' },
        { key: 'start_date', label: 'Start Date', type: :date, target: '[name="client_service[start_date]"]', hint: 'Sanction, deposit, filing, travel or issue date' },
        { key: 'reference_number', label: 'Reference Number', type: :string, target: '[name="client_service[reference_number]"]', hint: 'Loan account, FD number, acknowledgement number, booking or card reference' },
        { key: 'notes', label: 'Notes', type: :string, kind: :append, target: '[name="client_service[notes]"]', hint: 'Lender / bank, tenure, interest rate, or other key details; max 300 characters' }
      ]
    }
  }.freeze

  def self.fetch(product)
    PROFILES[product.to_s]
  end

  # Field list for the browser (selectors, kinds, labels).
  def self.client_config(product)
    profile = fetch(product)
    return nil unless profile

    { product: product.to_s, label: profile[:label], fields: profile[:fields] }
  end
end
