# AI Upload (beta) for the New Life Insurance form: POST a policy document,
# get back the extracted fields as JSON. Nothing is saved here - the form's
# JavaScript shows a review panel and fills only the fields the admin applies.
class Admin::LifeInsuranceAiExtractsController < Admin::ApplicationController
  # POST /admin/insurance/life/ai_extract  (multipart: document)
  def create
    file = params[:document]
    return render_failure('Please choose a policy document (PDF or image).') unless file.respond_to?(:read)

    type = file.content_type.to_s
    unless type == PolicyDocumentAiExtractor::PDF_TYPE || PolicyDocumentAiExtractor::IMAGE_TYPES.include?(type)
      return render_failure('Only PDF, JPG, PNG or WEBP files are supported.')
    end
    if file.size > PolicyDocumentAiExtractor::MAX_FILE_BYTES
      return render_failure('The file is larger than 20 MB.')
    end

    fields = PolicyDocumentAiExtractor.new(file: file, company_names: life_company_names).call
    render json: { success: true, fields: fields, customer: match_customer(fields), insurance_company_name: match_company(fields['insurance_company_name']) }
  rescue PolicyDocumentAiExtractor::NotConfiguredError => e
    render_failure(e.message, :service_unavailable)
  rescue PolicyDocumentAiExtractor::Error => e
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

  # Same company list the form's dropdown shows.
  def life_company_names
    names = InsuranceCompany.where("name ILIKE ? OR name ILIKE ?", "%life%", "%LIC%").distinct.order(:name).pluck(:name)
    names.presence || LifeInsurance.life_insurance_companies.map { |c| c[:name] || c['name'] }.sort
  rescue StandardError
    []
  end

  # Exact dropdown name for the insurer, or nil (the form then leaves it for the admin).
  def match_company(name)
    return nil if name.blank?

    names = life_company_names
    names.find { |n| n.casecmp?(name) } ||
      names.find { |n| normalize(n) == normalize(name) } ||
      names.find { |n| normalize(n).include?(normalize(name)) || normalize(name).include?(normalize(n)) }
  end

  def normalize(name)
    name.to_s.downcase.gsub(/\b(co|company|ltd|limited|insurance|life|of|india|the)\b|[^a-z0-9]/, '')
  end

  # Existing active client for the proposer: mobile, then email, then exact name.
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
