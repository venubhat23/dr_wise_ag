class Api::V1::Mobile::KycController < Api::V1::Mobile::BaseController
  before_action :authenticate_pending_sub_agent!

  BANK_DOCUMENT_TYPES = ['Bank Statement', 'Bank Passbook'].freeze

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
  # Accepts aadhaar_file, pan_file, and/or bank_file (multipart). Aadhaar and
  # PAN are required before kyc_status can move to "submitted"; bank_file is
  # always optional and never gates submission. Any of the three can be sent
  # alone to fill in a still-missing document, or resent after a rejection.
  def upload_documents
    if params[:aadhaar_file].blank? && params[:pan_file].blank? && params[:bank_file].blank?
      return render_error('Please attach an aadhaar_file, pan_file, and/or bank_file', :unprocessable_entity)
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

    if params[:bank_file].present?
      document = create_document(bank_document_type_param, params[:bank_file])
      return render_error('Failed to upload bank document', :unprocessable_entity) unless document
      uploaded << document
    end

    submit_kyc_if_complete

    aadhaar_masked = uploaded.any? { |d| d.document_type == 'Aadhaar Card' && d.ocr_extracted_data.to_h['aadhaar_number'].blank? }

    render_success({
      kyc_status: @sub_agent.kyc_status,
      aadhaar_number_needs_manual_entry: aadhaar_masked,
      documents: uploaded.map { |doc| document_response(doc) }
    }, aadhaar_masked ? 'Documents uploaded. Aadhaar number is masked on this card - please enter the full 12-digit number.' : 'Documents uploaded successfully')
  end

  # PATCH /api/v1/mobile/kyc/details
  # Lets the app submit the (optionally user-corrected) OCR-extracted fields
  # as the affiliate's actual profile data, instead of the user re-typing
  # name/DOB/address/PAN/Aadhaar by hand after Upload KYC Documents.
  #
  # Also accepts the KYC files in the same multipart/form-data request, so the
  # app can submit everything in one call (all optional, any subset works):
  #   aadhaar_file             -> SubAgentDocument "Aadhaar Card" (OCR'd)
  #   pan_file                 -> SubAgentDocument "Pancard" (OCR'd)
  #   photo / profile_photo    -> SubAgentDocument "Profile Image" (no OCR)
  #   bank_file                -> SubAgentDocument "Bank Statement" or
  #                               "Bank Passbook" per bank_document_type
  #                               (default "Bank Passbook"; OCR'd)
  # Files are only stored once the details themselves pass validation, so a
  # rejected request never leaves orphan documents behind.
  def update_details
    permitted = params.permit(:first_name, :middle_name, :last_name, :birth_date,
                               :gender, :address, :city, :state, :pan_no, :aadhaar_no,
                               :bank_name, :account_no, :ifsc_code, :account_holder_name,
                               :account_type, :upi_id)

    @sub_agent.assign_attributes(permitted)
    unless @sub_agent.valid?
      return render_error(@sub_agent.errors.full_messages.join(', '), :unprocessable_entity)
    end

    uploaded = {}
    {
      aadhaar_file: ['Aadhaar Card', 'Aadhaar document'],
      pan_file: ['Pancard', 'PAN document'],
      bank_file: [bank_document_type_param, 'bank document']
    }.each do |param_key, (document_type, label)|
      next if params[param_key].blank?

      document = create_document(document_type, params[param_key])
      return render_error("Failed to upload #{label}", :unprocessable_entity) unless document
      uploaded[param_key] = document
    end

    photo = params[:photo] || params[:profile_photo]
    if photo.present?
      photo_document = create_photo_document(photo)
      return render_error('Failed to upload photo', :unprocessable_entity) unless photo_document
      uploaded[:photo] = photo_document
    end
    photo_document = uploaded[:photo]

    if @sub_agent.save
      mark_kyc_submitted!

      render_success({
        first_name: @sub_agent.first_name,
        middle_name: @sub_agent.middle_name,
        last_name: @sub_agent.last_name,
        birth_date: @sub_agent.birth_date,
        gender: @sub_agent.gender,
        address: @sub_agent.address,
        city: @sub_agent.city,
        state: @sub_agent.state,
        pan_no: @sub_agent.pan_no,
        aadhaar_no: @sub_agent.aadhaar_no,
        bank_name: @sub_agent.bank_name,
        account_no: @sub_agent.account_no,
        ifsc_code: @sub_agent.ifsc_code,
        account_holder_name: @sub_agent.account_holder_name,
        account_type: @sub_agent.account_type,
        upi_id: @sub_agent.upi_id,
        photo_url: photo_document&.r2_public_url || @sub_agent.r2_profile_image_url,
        documents: uploaded.values.map { |doc| document_response(doc) },
        kyc_status: @sub_agent.kyc_status,
        kyc_submitted_at: @sub_agent.kyc_submitted_at,
        kyc_reviewed_at: @sub_agent.kyc_reviewed_at,
        kyc_rejection_reason: @sub_agent.kyc_rejection_reason
      }, 'KYC details updated successfully')
    else
      render_error(@sub_agent.errors.full_messages.join(', '), :unprocessable_entity)
    end
  end

  # GET /api/v1/mobile/kyc/payment/status
  # Lets the app decide on open/resume whether to show the registration-fee
  # payment screen (SystemSetting.affiliate_registration_fee; 0 = no fee).
  def payment_status
    render_success({
      payment_required: @sub_agent.payment_required?,
      payment_paid: @sub_agent.payment_paid,
      amount_due: @sub_agent.payment_amount_due
    })
  end

  # POST /api/v1/mobile/kyc/payment/order
  # Creates a Razorpay order for the affiliate registration fee. The app hands
  # order_id/key/amount straight to Razorpay's native Checkout SDK.
  def create_payment_order
    unless @sub_agent.payment_required?
      return render_error('Payment not required', :unprocessable_entity)
    end

    order = RazorpayService.create_order(
      amount_rupees: @sub_agent.payment_amount_due,
      receipt: "affiliate_kyc_#{@sub_agent.id}_#{Time.current.to_i}"
    )
    @sub_agent.update_column(:razorpay_order_id, order['id'])

    render_success({
      order_id: order['id'],
      amount: order['amount'],
      currency: order['currency'],
      key: RAZORPAY_CONFIG[:key_id],
      name: 'Dr WISE',
      description: 'Affiliate registration fee',
      prefill: { name: @sub_agent.display_name, email: @sub_agent.email, contact: @sub_agent.mobile }
    }, 'Payment order created')
  rescue RazorpayService::Error => e
    render_error("Unable to create payment order: #{e.message}", :unprocessable_entity)
  end

  # POST /api/v1/mobile/kyc/payment/verify
  # Verifies the signature Razorpay's Checkout SDK returns on successful
  # payment (same three values as the web ambassador flow's callback), then
  # marks the fee as paid. Does not block kyc_status - payment is tracked and
  # surfaced to the admin, not a hard gate on submission/approval.
  def verify_payment
    order_id   = params[:razorpay_order_id]
    payment_id = params[:razorpay_payment_id]
    signature  = params[:razorpay_signature]

    unless order_id.present? && order_id == @sub_agent.razorpay_order_id &&
           RazorpayService.verify_signature(order_id: order_id, payment_id: payment_id, signature: signature)
      return render_error('Payment verification failed', :unprocessable_entity)
    end

    @sub_agent.mark_payment_paid!(order_id: order_id, payment_id: payment_id, amount: @sub_agent.payment_amount_due)

    render_success({
      payment_paid: true,
      payment_paid_at: @sub_agent.payment_paid_at,
      kyc_status: @sub_agent.kyc_status
    }, 'Payment verified successfully')
  end

  private

  # From upload_documents: only move into the admin KYC queue once both required
  # documents are present.
  def submit_kyc_if_complete
    mark_kyc_submitted! if @sub_agent.kyc_documents_complete?
  end

  # Moves the affiliate into the admin KYC queue (kyc_status: submitted). This is
  # the app's explicit "submit" action on the details screen, so it fires as soon
  # as the affiliate has entered their profile data - the document images are not
  # required and can still be uploaded (or re-uploaded after a rejection)
  # afterwards. Skips agents already submitted or approved so re-saving details
  # doesn't reset kyc_submitted_at or re-send the notification.
  def mark_kyc_submitted!
    return if @sub_agent.kyc_submitted? || @sub_agent.kyc_approved?

    @sub_agent.update!(
      kyc_status: :submitted,
      kyc_submitted_at: Time.current,
      kyc_rejection_reason: nil
    )
    SendKycStatusEmailJob.perform_later(sub_agent_id: @sub_agent.id, event: 'submitted')
  end

  def bank_document_type_param
    type = params[:bank_document_type].to_s
    BANK_DOCUMENT_TYPES.include?(type) ? type : 'Bank Passbook'
  end

  def create_document(document_type, file)
    document = @sub_agent.sub_agent_documents.build(document_type: document_type)
    return nil unless document.upload_to_r2(file)

    document.run_ocr!(file)
    document
  end

  # A selfie/profile photo isn't an ID document, so unlike create_document
  # this skips OCR (mirrors the web ambassador KYC wizard's photo step).
  def create_photo_document(file)
    document = @sub_agent.sub_agent_documents.build(document_type: 'Profile Image')
    document.upload_to_r2(file) ? document : nil
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
      id_number: extracted['aadhaar_number'] || extracted['aadhaar_number_masked'] || extracted['pan_number'],
      # True when an Aadhaar card was read but its number is masked (e-Aadhaar
      # prints only the last 4 digits), so the app must ask the user to type
      # the full 12-digit number into aadhaar_no on the details step.
      aadhaar_number_needs_manual_entry: doc.document_type == 'Aadhaar Card' &&
                                         extracted['aadhaar_number'].blank?,
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
    known_roles = %w[customer client agent sub_agent]
    return render_error('Invalid user role', :unauthorized) unless known_roles.include?(decoded_token['role'])

    @sub_agent = SubAgent.find_by(id: decoded_token['user_id'])
    render_error('Sub-agent not found', :unauthorized) unless @sub_agent
  rescue JWT::DecodeError
    render_error('Invalid authorization token', :unauthorized)
  end
end
