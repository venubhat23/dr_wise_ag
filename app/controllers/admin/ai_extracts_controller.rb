# AI Upload (beta) for the product creation forms: POST a document, get back
# the extracted fields as JSON. Nothing is saved here - the form's JavaScript
# (admin/shared/_ai_upload) shows a review table and fills only the fields the
# admin applies.
class Admin::AiExtractsController < Admin::ApplicationController
  # POST /admin/ai_extract/:product  (multipart: document, field_options, company_options, context)
  def create
    return render_failure('AI Upload is not available for this form.', :not_found) unless AiDocumentProfiles.fetch(params[:product])

    file = params[:document]
    return render_failure('Please choose a document (PDF or image).') unless file.respond_to?(:read)

    type = file.content_type.to_s
    unless type == AiDocumentExtractor::PDF_TYPE || AiDocumentExtractor::IMAGE_TYPES.include?(type)
      return render_failure('Only PDF, JPG, PNG or WEBP files are supported.')
    end
    return render_failure('The file is larger than 20 MB.') if file.size > AiDocumentExtractor::MAX_FILE_BYTES

    fields = AiDocumentExtractor.new(
      file: file, product: params[:product], context: params[:context],
      field_options: parse_json(params[:field_options], {}), company_options: parse_json(params[:company_options], [])
    ).call
    render json: { success: true, fields: fields, customer: match_customer(fields) }
  rescue AiDocumentExtractor::NotConfiguredError => e
    render_failure(e.message, :service_unavailable)
  rescue AiDocumentExtractor::Error => e
    render_failure(e.message)
  rescue Anthropic::Errors::RateLimitError
    render_failure('The AI service is busy right now. Please try again in a minute.', :too_many_requests)
  rescue Anthropic::Errors::BadRequestError => e
    Rails.logger.warn "[AI Upload] bad request: #{e.message}"
    render_failure('The AI could not process this file. Try a clearer PDF or photo.')
  rescue Anthropic::Errors::APIStatusError, Anthropic::Errors::APIConnectionError => e
    Rails.logger.error "[AI Upload] #{e.class}: #{e.message}"
    render_failure('The AI service is unavailable right now. Please fill the form manually or try again.', :bad_gateway)
  end

  private

  def render_failure(message, status = :unprocessable_entity)
    render json: { success: false, error: message }, status: status
  end

  def parse_json(value, fallback)
    parsed = value.present? ? JSON.parse(value) : fallback
    parsed.is_a?(fallback.class) ? parsed : fallback
  rescue JSON::ParserError
    fallback
  end

  # Existing active client for the document's holder: mobile, then email, then name.
  def match_customer(fields)
    scope = Customer.active
    mobile = fields['proposer_mobile'].to_s.gsub(/\D/, '').last(10)
    customer = (mobile.length == 10 && scope.where("regexp_replace(mobile, '\\D', '', 'g') LIKE ?", "%#{mobile}").first) ||
               (fields['proposer_email'].present? && scope.where('LOWER(email) = ?', fields['proposer_email'].downcase.strip).first) ||
               match_customer_by_name(scope, fields['proposer_name'].presence || fields['insured_name'])
    customer && { id: customer.id, name: customer.display_name }
  end

  def match_customer_by_name(scope, name)
    return nil if name.blank?

    parts = name.strip.split(/\s+/)
    candidates = scope.where('LOWER(first_name) = ?', parts.first.downcase).to_a
    candidates.find { |c| c.display_name.to_s.squish.casecmp?(name.squish) } ||
      (candidates.size == 1 && parts.size > 1 && candidates.first.display_name.to_s.downcase.include?(parts.last.downcase) ? candidates.first : nil)
  end
end
