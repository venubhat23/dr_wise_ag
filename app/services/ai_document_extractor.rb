# AI Upload (beta): reads a product document (PDF or photo) with Claude and
# returns the fields of one product creation form - see AiDocumentProfiles.
#
# Structured outputs (output_config.format) guarantee the reply is JSON that
# matches the schema built from the profile, so the form never gets
# half-parsed text. Fields the document doesn't show come back null and are
# left alone on the form. Dropdown fields are limited to the options the
# form actually offers (sent by the browser as `field_options`).
#
# Uses Claude when ENV["ANTHROPIC_API_KEY"] is set, otherwise Google Gemini
# (free tier) with GEMINI_API_KEY - hardcoded on purpose, same convention as
# OcrService::OCR_SPACE_API_KEY (not read from ENV).
require "net/http"

class AiDocumentExtractor
  class Error < StandardError; end
  class NotConfiguredError < Error; end

  MODEL = :"claude-opus-5-5"
  GEMINI_MODEL = "gemini-flash-latest"
  GEMINI_API_KEY = "AQ.Ab8RN6Jsct6qbsWFpJxRVDYhCMvGGFF27dannJMt5oI73_kpjw"
  GEMINI_ENDPOINT = "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent"
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
    anthropic? || gemini_api_key.present?
  end

  def self.anthropic?
    ENV["ANTHROPIC_API_KEY"].present?
  end

  def self.gemini_api_key
    GEMINI_API_KEY
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
    raise NotConfiguredError, "AI Upload is not configured (no ANTHROPIC_API_KEY or GEMINI_API_KEY)." unless self.class.configured?
    return call_gemini unless self.class.anthropic?

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

  # Same schema, prompt and file as the Claude path, via the Gemini REST API.
  def call_gemini
    uri = URI(format(GEMINI_ENDPOINT, GEMINI_MODEL))
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["x-goog-api-key"] = self.class.gemini_api_key
    request.body = {
      systemInstruction: { parts: [{ text: system_prompt }] },
      contents: [{ role: "user", parts: [
        { inline_data: { mime_type: @file.content_type.to_s, data: Base64.strict_encode64(@file.read) } },
        { text: "Extract the details from this document." }
      ] }],
      generationConfig: { responseMimeType: "application/json", responseJsonSchema: schema, temperature: 0 }
    }.to_json

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 10, read_timeout: 120) { |http| http.request(request) }
    body = JSON.parse(response.body) rescue {}
    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.error "[AI Upload] Gemini #{response.code}: #{body.dig('error', 'message') || response.body.to_s.first(300)}"
      raise Error, "The AI service is busy right now. Please try again in a minute." if response.code == "429"
      raise Error, "The AI could not process this file. Try a clearer PDF or photo." if response.code == "400"
      raise Error, "The AI service is unavailable right now. Please fill the form manually or try again."
    end

    candidate = body.dig("candidates", 0)
    raise Error, "The AI could not read this document." if candidate.nil? || candidate["finishReason"].in?(%w[SAFETY RECITATION PROHIBITED_CONTENT])
    raise Error, "The document was too long to read completely." if candidate["finishReason"] == "MAX_TOKENS"

    text = Array(candidate.dig("content", "parts")).map { |part| part["text"] }.join
    raise Error, "The AI returned no details." if text.blank?

    JSON.parse(text)
  rescue Net::OpenTimeout, Net::ReadTimeout, SocketError, Errno::ECONNREFUSED => e
    Rails.logger.error "[AI Upload] Gemini #{e.class}: #{e.message}"
    raise Error, "The AI service is unavailable right now. Please fill the form manually or try again."
  rescue JSON::ParserError
    raise Error, "The AI reply could not be read. Please try again."
  end

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
