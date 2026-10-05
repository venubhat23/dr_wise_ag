# AI Upload (beta): reads a life insurance policy document (PDF or photo) with
# Claude and returns the fields the admin "New Life Insurance" form needs.
#
# Structured outputs (output_config.format) guarantee the reply is JSON that
# matches SCHEMA, so the form never gets half-parsed text. Fields the document
# doesn't show come back null and are left untouched on the form.
#
# Needs ENV["ANTHROPIC_API_KEY"]. Without it `configured?` is false and the
# button explains that instead of failing.
class PolicyDocumentAiExtractor
  class Error < StandardError; end
  class NotConfiguredError < Error; end

  MODEL = :"claude-opus-5-5"
  MAX_FILE_BYTES = 20.megabytes
  PDF_TYPE = "application/pdf"
  IMAGE_TYPES = %w[image/jpeg image/png image/webp image/gif].freeze

  nullable_string = { type: %w[string null] }
  nullable_number = { type: %w[number null] }
  nullable_integer = { type: %w[integer null] }
  # Dates as YYYY-MM-DD (what <input type="date"> takes); null when absent.
  nullable_date = { type: %w[string null], description: "YYYY-MM-DD" }

  SCHEMA = {
    type: "object",
    additionalProperties: false,
    required: %w[policy_number insurance_company_name plan_name payment_mode
                 policy_booking_date policy_start_date policy_end_date risk_start_date
                 policy_term premium_payment_term sum_insured net_premium gst_percentage total_premium
                 proposer_name proposer_mobile proposer_email insured_name insured_age
                 nominees bank_name account_number ifsc_code account_holder_name notes],
    properties: {
      policy_number: nullable_string,
      insurance_company_name: { type: %w[string null], description: "Insurer name; use the exact name from the known-companies list when one matches" },
      plan_name: nullable_string,
      payment_mode: { type: %w[string null], enum: [*LifeInsurance::PAYMENT_MODES, nil], description: "Premium payment frequency" },
      policy_booking_date: nullable_date,
      policy_start_date: nullable_date,
      policy_end_date: nullable_date,
      risk_start_date: nullable_date,
      policy_term: nullable_integer.merge(description: "Policy term in years"),
      premium_payment_term: nullable_integer.merge(description: "Premium paying term in years"),
      sum_insured: nullable_number.merge(description: "Sum assured in rupees, as a plain number"),
      net_premium: nullable_number.merge(description: "Premium before GST, per installment, in rupees"),
      gst_percentage: nullable_number.merge(description: "GST rate applied to the first-year premium, e.g. 4.5 or 18"),
      total_premium: nullable_number.merge(description: "Premium including GST, per installment, in rupees"),
      proposer_name: nullable_string.merge(description: "Policyholder / proposer full name"),
      proposer_mobile: nullable_string,
      proposer_email: nullable_string,
      insured_name: nullable_string.merge(description: "Life assured full name"),
      insured_age: nullable_integer,
      nominees: {
        type: "array",
        items: {
          type: "object",
          additionalProperties: false,
          required: %w[name relationship age share_percentage],
          properties: {
            name: { type: "string" },
            relationship: { type: %w[string null], enum: %w[spouse son daughter father mother brother sister other] + [nil] },
            age: nullable_integer,
            share_percentage: nullable_number
          }
        }
      },
      bank_name: nullable_string,
      account_number: nullable_string,
      ifsc_code: nullable_string,
      account_holder_name: nullable_string,
      notes: nullable_string.merge(description: "Anything important that has no field above (riders, bonus info), max 300 characters")
    }
  }.freeze

  def self.configured?
    ENV["ANTHROPIC_API_KEY"].present?
  end

  def initialize(file:, company_names: [])
    @file = file
    @company_names = company_names
  end

  # Returns the extracted fields as a Hash with string keys.
  def call
    raise NotConfiguredError, "AI Upload is not configured (ANTHROPIC_API_KEY is missing)." unless self.class.configured?

    message = client.beta.messages.create(
      model: MODEL,
      max_tokens: 8000,
      output_config: { effort: :medium, format_: { type: :json_schema, schema: SCHEMA } },
      # If the model declines, the API retries on its default fallback model
      # inside the same call.
      betas: [:"server-side-fallback-2026-07-01"],
      fallbacks: :default,
      system_: system_prompt,
      messages: [{ role: "user", content: [file_block, { type: "text", text: "Extract the policy details from this document." }] }]
    )

    raise Error, "The AI could not read this document." if message.stop_reason == :refusal
    raise Error, "The document was too long to read completely." if message.stop_reason == :max_tokens

    text = message.content.find { |block| block.type == :text }&.text
    raise Error, "The AI returned no details." if text.blank?

    JSON.parse(text)
  rescue JSON::ParserError
    raise Error, "The AI reply could not be read. Please try again."
  end

  private

  def client
    Anthropic::Client.new(api_key: ENV["ANTHROPIC_API_KEY"], timeout: 120)
  end

  def system_prompt
    <<~PROMPT
      You read Indian life insurance policy documents (policy schedules, proposal forms,
      premium receipts) and extract the fields for an insurance agency's records.

      - Copy values exactly as printed; never guess. Use null for anything the document
        does not state.
      - Amounts are rupees as plain numbers (no commas, no symbols). "90 lakhs" is 9000000.
      - Dates are YYYY-MM-DD. Indian documents write dates day-first (05/04/2024 is 5 April 2024).
      - net_premium and total_premium are per installment for the stated payment mode.
      - The proposer (policyholder) can differ from the life assured (insured).
      - Known insurance companies in this system: #{@company_names.presence&.join('; ') || 'none listed'}.
    PROMPT
  end

  def file_block
    data = Base64.strict_encode64(@file.read)
    type = @file.content_type.to_s
    if type == PDF_TYPE
      { type: "document", source: { type: "base64", media_type: PDF_TYPE, data: data } }
    else
      { type: "image", source: { type: "base64", media_type: type, data: data } }
    end
  end
end
