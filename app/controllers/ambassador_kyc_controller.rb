# Web KYC wizard for self-registered ambassadors. An ambassador can log in the
# moment they register, but AmbassadorController blocks the dashboard until KYC
# is approved and sends them here.
#
# Steps (kyc_step tracks the furthest one completed):
#   1 Documents - upload Aadhaar + PAN, "Validate" runs OCR (#ocr)
#   2 Personal  - confirm / correct the OCR-extracted name, DOB, PAN, address
#   3 Bank      - upload a statement/passbook (OCR pre-fills), confirm account no + IFSC
#   4 Photo     - upload a photo, then Submit for admin review
#
# Uses the same OcrService / OCR.space provider as the mobile affiliate KYC flow.
class AmbassadorKycController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_ambassador
  before_action :set_distributor

  layout "devise"

  LAST_STEP = 4

  # GET /ambassador/kyc
  def show
    return redirect_to ambassador_dashboard_path, notice: "Your KYC is already approved." if @distributor.kyc_approved?

    @submitted = @distributor.kyc_submitted?
    @rejected  = @distributor.kyc_rejected?
    @max_step  = [@distributor.kyc_step + 1, LAST_STEP].min
    @step      = params[:step].to_i.clamp(1, @max_step)
    @review    = params[:review].present? && @distributor.kyc_step >= LAST_STEP
    @prefill   = (session[:kyc_ocr] || {}).merge(id_ocr_prefill) { |_k, old, new| old.presence || new }
    @missing   = @distributor.kyc_missing_items
  end

  # POST /ambassador/kyc/ocr  (AJAX) - upload one document, run OCR, return the
  # extracted fields so the wizard can show them for confirmation.
  def ocr
    doc_type = params[:document_type].to_s
    file     = params[:file]

    unless DistributorDocument::KYC_OCR_TYPES.include?(doc_type)
      return render json: { error: "Unknown document type." }, status: :unprocessable_entity
    end
    if file.blank?
      return render json: { error: "Please choose a file to upload." }, status: :unprocessable_entity
    end

    doc = @distributor.distributor_documents.build(document_type: doc_type, document_file: file)
    unless doc.save
      return render json: { error: doc.errors.full_messages.to_sentence.presence || "Upload failed." },
                    status: :unprocessable_entity
    end

    doc.run_ocr!(file)

    render json: {
      document_id: doc.id,
      filename: doc.document_name,
      document_url: doc.document_url,
      ocr_status: doc.ocr_status,
      ocr_error: doc.ocr_error,
      extracted: doc.ocr_extracted_data || {}
    }
  end

  # POST /ambassador/kyc/documents - leave the Documents step once both IDs are up.
  def documents
    unless @distributor.kyc_document("Aadhaar Card") && @distributor.kyc_document("Pancard")
      return redirect_to ambassador_kyc_path(step: 1),
                         alert: "Please upload and validate both your Aadhaar and PAN card."
    end

    session[:kyc_ocr] = id_ocr_prefill
    advance_step_to(1)
    redirect_to ambassador_kyc_path(step: 2)
  end

  # PATCH /ambassador/kyc/personal
  def personal
    if @distributor.update(personal_params)
      advance_step_to(2)
      redirect_to ambassador_kyc_path(step: 3)
    else
      rerender_step(2)
    end
  end

  # PATCH /ambassador/kyc/bank
  def bank
    if @distributor.kyc_bank_document.nil?
      @distributor.assign_attributes(bank_params)
      @distributor.errors.add(:base, "Please upload and validate a bank passbook or statement.")
      return rerender_step(3)
    end

    if @distributor.update(bank_params)
      advance_step_to(3)
      redirect_to ambassador_kyc_path(step: 4)
    else
      rerender_step(3)
    end
  end

  # PATCH /ambassador/kyc/photo
  def photo
    if params[:photo_file].present?
      doc = @distributor.distributor_documents.build(document_type: "Profile Photo", document_file: params[:photo_file])
      unless doc.save
        return redirect_to ambassador_kyc_path(step: 4),
                           alert: doc.errors.full_messages.to_sentence.presence || "Could not upload the photo."
      end
    elsif @distributor.kyc_document("Profile Photo").nil?
      return redirect_to ambassador_kyc_path(step: 4), alert: "Please upload a clear photo of yourself."
    end

    advance_step_to(4)
    redirect_to ambassador_kyc_path(step: 4, review: 1)
  end

  # POST /ambassador/kyc/submit
  def submit
    missing = @distributor.kyc_missing_items
    if missing.any?
      return redirect_to ambassador_kyc_path(step: 1), alert: "Still needed before we can review: #{missing.to_sentence}."
    end

    @distributor.submit_kyc!
    session.delete(:kyc_ocr)
    redirect_to ambassador_kyc_path, notice: "Thanks! Your KYC has been submitted for review."
  end

  private

  def ensure_ambassador
    redirect_to root_path, alert: "Ambassador access required." unless current_user&.ambassador?
  end

  def set_distributor
    @distributor = Distributor.find_by(email: current_user.email)
    redirect_to root_path, alert: "Ambassador profile not found." if @distributor.nil?
  end

  def advance_step_to(step)
    @distributor.update_column(:kyc_step, step) if @distributor.kyc_step < step
  end

  def rerender_step(step)
    @submitted = false
    @rejected  = @distributor.kyc_rejected?
    @max_step  = [@distributor.kyc_step + 1, LAST_STEP].min
    @step      = step
    @review    = false
    @prefill   = (session[:kyc_ocr] || {})
    @missing   = @distributor.kyc_missing_items
    flash.now[:alert] = @distributor.errors.full_messages.to_sentence
    render :show, status: :unprocessable_entity
  end

  def personal_params
    params.require(:distributor).permit(
      :first_name, :middle_name, :last_name, :birth_date, :gender, :address, :city, :state, :pan_no, :aadhaar_no
    )
  end

  def bank_params
    params.require(:distributor).permit(
      :bank_name, :account_no, :ifsc_code, :account_holder_name, :account_type, :upi_id
    )
  end

  # Combines the Aadhaar + PAN OCR results into pre-fill values for the
  # Personal-details form. PAN wins for name/DOB (cleaner label), Aadhaar
  # provides gender + address.
  def id_ocr_prefill
    aadhaar = @distributor.kyc_document("Aadhaar Card")&.ocr_extracted_data || {}
    pan     = @distributor.kyc_document("Pancard")&.ocr_extracted_data || {}

    full_name = pan["name"].presence || aadhaar["name"]
    first, *rest = full_name.to_s.strip.split(/\s+/)

    {
      "first_name"  => first,
      "last_name"   => rest.join(" ").presence,
      "birth_date"  => normalize_dob(pan["dob"] || aadhaar["dob"]),
      "gender"      => normalize_gender(aadhaar["gender"]),
      "address"     => aadhaar["address"],
      "pan_no"      => pan["pan_number"],
      "aadhaar_no"  => aadhaar["aadhaar_number"]&.gsub(/\s+/, "")
    }.compact_blank
  end

  def normalize_dob(str)
    return nil if str.blank?
    return "#{str}-01-01" if str.match?(/\A\d{4}\z/) # Aadhaar "Year of Birth"
    Date.strptime(str, "%d/%m/%Y").iso8601
  rescue ArgumentError
    nil
  end

  def normalize_gender(str)
    return nil if str.blank?
    %w[Male Female Other].find { |g| g.casecmp?(str.to_s.strip) }
  end
end
