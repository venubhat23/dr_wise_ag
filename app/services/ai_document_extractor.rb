# AI Upload (beta): reads a product document (PDF or photo) with Claude and
# returns the fields of one product creation form - see AiDocumentProfiles.
#
# Structured outputs (output_config.format) guarantee the reply is JSON that
# matches the schema built from the profile, so the form never gets
# half-parsed text. Fields the document doesn't show come back null and are
# left alone on the form. Dropdown fields are limited to the options the
# form actually offers (sent by the browser as `field_options`).
#
# Needs ENV["ANTHROPIC_API_KEY"]; without it `configured?` is false and the
# endpoint says so instead of failing.
class AiDocumentExtractor
  class Error < StandardError; end
  class NotConfiguredError < Error; end

  MODEL = :"claude-opus-5-5"
  MAX_FILE_BYTES = 20.megabytes
  PDF_TYPE = "application/pdf"
  IMAGE_TYPES = %w[image/jpeg image/png image/webp image/gif].freeze
  MAX_OPTIONS = 300 # per dropdown, keeps the schema/prompt small

  # Always asked for, so the server can match an existing client.
  CLIENT_PROPERTIES = {
    "proposer_name" => { type: %w[string null], description: "Policyholder / customer / account holder full name" },
    "proposer_mobile" => { type: %w[string null] },
    "proposer_email" => { type: %w[string null] }
  }.freeze

  def self.configured?
    ENV["ANTHROPIC_API_KEY"].present?
  end

  # field_options: { "payment_mode" => ["Yearly", ...] } from the form's <select>s
  # company_options: insurer names currently in the form's dropdown (may be empty)
  # context: extra words about the record, e.g. "Home Loan"
  def initialize(file:, product:, field_options: {}, company_options: [], context: nil)
    @file = file
    @profile = AiDocumentProfiles.fetch(product) or raise Error, "AI Upload is not available for this form."
    @field_options = field_options.to_h.transform_values { |v| Array(v).map(&:to_s).reject(&:blank?).uniq.first(MAX_OPTIONS) }
    @company_options = Array(company_options).map(&:to_s).reject(&:blank?).uniq.first(MAX_OPTIONS)
    @context = context.to_s.strip.first(100).presence
  end

  # Returns the extracted fields as a Hash with string keys.
  def call
    raise NotConfiguredError, "AI Upload is not configured (ANTHROPIC_API_KEY is missing)." unless self.class.configured?

    message = client.beta.messages.create(
      model: MODEL,
      max_tokens: 8000,
      output_config: { effort: :medium, format_: { type: :json_schema, schema: schema } },
      # If the model declines, the API retries on its default fallback model
      # inside the same call.
      betas: [:"server-side-fallback-2026-07-01"],
      fallbacks: :default,
      system_: system_prompt,
      messages: [{ role: "user", content: [file_block, { type: "text", text: "Extract the details from this document." }] }]
    )

    raise Error, "The AI could not read this document." if message.stop_reason == :refusal
    raise Error, "The document was too long to read completely." if message.stop_reason == :max_tokens

    text = message.content.find { |block| block.type == :text }&.text
    raise Error, "The AI returned no details." if text.blank?

    JSON.parse(text)
  rescue JSON::ParserError
    raise Error, "The AI reply could not be read. Please try again."
  end

  def schema
    properties = CLIENT_PROPERTIES.dup
    @profile[:fields].each do |field|
      next if field[:kind] == :customer

      properties[field[:key]] = property_for(field, @field_options[field[:key]])
    end
    object_schema(properties)
  end

  private

  def object_schema(properties)
    { type: "object", additionalProperties: false, required: properties.keys, properties: properties }
  end

  def property_for(field, options = nil)
    prop =
      case field[:type]
      when :number then { type: %w[number null] }
      when :integer then { type: %w[integer null] }
      when :date then { type: %w[string null], description: "YYYY-MM-DD" }
      when :enum then { type: %w[string null], enum: field[:values] + [nil] }
      when :select then options.present? ? { type: %w[string null], enum: options + [nil] } : { type: %w[string null] }
      when :rows
        items = field[:rows][:fields].to_h { |f| [f[:key], property_for(f)] }
        { type: "array", items: object_schema(items) }
      else { type: %w[string null] }
      end
    description = [field[:label], field[:hint]].compact.join(" - ")
    prop[:description] = [description, prop[:description]].compact.join(". ") if description.present? && field[:type] != :rows
    prop[:description] = description if field[:type] == :rows
    prop
  end

  def client
    Anthropic::Client.new(api_key: ENV["ANTHROPIC_API_KEY"], timeout: 120)
  end

  def system_prompt
    companies = @company_options.presence || []
    <<~PROMPT
      You read #{@profile[:document]} and extract the fields for an Indian insurance and
      financial-services agency's records#{" (record type: #{@context})" if @context}.

      - Copy values exactly as printed; never guess. Use null for anything the document does not state.
      #{AiDocumentProfiles.common_policy_hints.strip}
      #{@profile[:hints]}
      #{"- Known insurance companies in this system (use the exact name when one matches): #{companies.join('; ')}" if companies.any?}
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
