class Api::V1::Mobile::KycController < Api::V1::Mobile::BaseController
  before_action :authenticate_pending_sub_agent!

  # GET /api/v1/mobile/kyc/status
  def status
    documents = @sub_agent.sub_agent_documents.where(document_type: ['Aadhaar Card', 'Pancard'])

    render_success({
      kyc_status: @sub_agent.kyc_status,
      kyc_submitted_at: @sub_agent.kyc_submitted_at,
      kyc_reviewed_at: @sub_agent.kyc_reviewed_at,
      kyc_rejection_reason: @sub_agent.kyc_rejection_reason,
      documents: documents.map { |doc| document_response(doc) }
    })
  end

  # POST /api/v1/mobile/kyc/documents
  # Accepts aadhaar_file and/or pan_file (multipart). Both are required
  # before kyc_status can move to "submitted"; either can be sent alone to
  # fill in a still-missing document, or resent after a rejection.
  def upload_documents
    if params[:aadhaar_file].blank? && params[:pan_file].blank?
      return render_error('Please attach an aadhaar_file and/or pan_file', :unprocessable_entity)
    end

    uploaded = []

    if params[:aadhaar_file].present?
      document = create_document('Aadhaar Card', params[:aadhaar_file])
      return render_error('Failed to upload Aadhaar document', :unprocessable_entity) unless document
      uploaded << document
    end

    if params[:pan_file].present?
      document = create_document('Pancard', params[:pan_file])
      return render_error('Failed to upload PAN document', :unprocessable_entity) unless document
      uploaded << document
    end

    if @sub_agent.kyc_documents_complete?
      @sub_agent.update!(
        kyc_status: :submitted,
        kyc_submitted_at: Time.current,
        kyc_rejection_reason: nil
      )
      SendKycStatusEmailJob.perform_later(sub_agent_id: @sub_agent.id, event: 'submitted')
    end

    render_success({
      kyc_status: @sub_agent.kyc_status,
      documents: uploaded.map { |doc| document_response(doc) }
    }, 'Documents uploaded successfully')
  end

  private

  def create_document(document_type, file)
    document = @sub_agent.sub_agent_documents.build(document_type: document_type)
    return nil unless document.upload_to_r2(file)

    document.run_ocr!(file)
    document
  end

  def document_response(doc)
    extracted = doc.ocr_extracted_data || {}

    {
      id: doc.id,
      document_type: doc.document_type,
      document_url: doc.document_url,
      ocr_status: doc.ocr_status,
      # Flattened for convenience - same values also live in ocr_extracted_data.
      name: extracted['name'],
      dob: extracted['dob'],
      id_number: extracted['aadhaar_number'] || extracted['pan_number'],
      ocr_text: doc.ocr_text,
      ocr_extracted_data: extracted,
      created_at: doc.created_at
    }
  end

  # Like Api::V1::Mobile::BaseController#authenticate_customer!, but does NOT
  # require the sub_agent to be active - a pending/rejected affiliate must
  # still be able to check status and (re)upload KYC documents.
  def authenticate_pending_sub_agent!
    token = request.headers['Authorization']&.split(' ')&.last

    if token.blank?
      return render_error('Authorization token is required', :unauthorized)
    end

    decoded_token = JWT.decode(token, Rails.application.secret_key_base)[0]
    return render_error('Invalid user role', :unauthorized) unless decoded_token['role'] == 'sub_agent'

    @sub_agent = SubAgent.find_by(id: decoded_token['user_id'])
    render_error('Sub-agent not found', :unauthorized) unless @sub_agent
  rescue JWT::DecodeError
    render_error('Invalid authorization token', :unauthorized)
  end
end
