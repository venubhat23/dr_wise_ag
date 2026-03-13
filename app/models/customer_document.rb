class CustomerDocument < ApplicationRecord
  # Associations
  belongs_to :customer

  # Validations
  validates :document_type, presence: true
  validates :document_type, inclusion: {
    in: ['Aadhaar Card', 'Pancard', 'Driving License', 'Mediclaim', 'RC Book', 'Other File']
  }

  # R2 File Storage - Direct upload to Cloudflare R2 (no ActiveStorage)
  # Uses columns: r2_file_key, r2_filename, r2_content_type, r2_file_size (to be added via migration)

  # Instance methods
  def document_name
    r2_filename.present? ? r2_filename : "No file attached"
  end

  def document_size
    return "0 KB" unless r2_file_size.present? && r2_file_size > 0
    number_to_human_size(r2_file_size)
  end

  def document_url
    return nil unless r2_file_key.present?
    # Use public R2 domain for direct access
    "https://pub-54653c57ac144e4a820943b13bf076de.r2.dev/#{r2_file_key}"
  end

  def public_document_url
    document_url
  end

  def has_file?
    r2_file_key.present?
  end

  # File type from content type
  def file_type
    r2_content_type
  end

  # Legacy methods for backward compatibility
  def filename
    document_name
  end

  def file_size
    r2_file_size
  end

  def file
    # For compatibility, return a simple object with key attributes
    OpenStruct.new(
      filename: r2_filename,
      content_type: r2_content_type,
      byte_size: r2_file_size,
      key: r2_file_key
    ) if has_file?
  end

  def document_file
    # Return a compatible object that has an attached? method for backward compatibility
    return DocumentFileProxy.new(self) if has_file?
    nil
  end

  # Compatibility class for ActiveStorage-like behavior
  class DocumentFileProxy
    def initialize(document)
      @document = document
    end

    def attached?
      @document.has_file?
    end

    def filename
      OpenStruct.new(to_s: @document.r2_filename)
    end

    def content_type
      @document.r2_content_type
    end

    def byte_size
      @document.r2_file_size
    end

    def key
      @document.r2_file_key
    end

    def url
      @document.document_url
    end
  end

  # R2 Upload method (to be used by controller)
  def upload_to_r2(file_param)
    return false unless file_param.present?

    # Validate file
    unless valid_file_type?(file_param.content_type)
      errors.add(:base, 'File must be a JPEG, PNG, or PDF')
      return false
    end

    if file_param.size > 10.megabytes
      errors.add(:base, 'File must be less than 10MB')
      return false
    end

    # Generate unique filename
    timestamp = Time.current.strftime('%Y%m%d_%H%M%S')
    random_string = SecureRandom.hex(8)
    file_extension = File.extname(file_param.original_filename)
    unique_filename = "customer_documents/#{customer_id}/#{document_type.downcase.gsub(' ', '_')}_#{timestamp}_#{random_string}#{file_extension}"

    begin
      # Use R2Service to upload
      r2_service = R2Service.new
      result = r2_service.upload_file(file_param.tempfile, unique_filename, file_param.content_type)

      if result[:success]
        # Update record with R2 file information
        update!(
          r2_file_key: unique_filename,
          r2_filename: file_param.original_filename,
          r2_content_type: file_param.content_type,
          r2_file_size: file_param.size
        )
        return { success: true, key: unique_filename }
      else
        errors.add(:base, "Upload failed: #{result[:error]}")
        return { error: result[:error] }
      end
    rescue => e
      errors.add(:base, "Upload failed: #{e.message}")
      return { error: e.message }
    end
  end

  # Delete from R2
  def delete_from_r2
    return true unless r2_file_key.present?

    begin
      r2_service = R2Service.new
      result = r2_service.delete_file(r2_file_key)

      # Clear R2 fields regardless of deletion result
      update!(
        r2_file_key: nil,
        r2_filename: nil,
        r2_content_type: nil,
        r2_file_size: nil
      )

      return result[:success]
    rescue => e
      Rails.logger.error "Failed to delete file from R2: #{e.message}"
      return false
    end
  end

  private

  def number_to_human_size(number)
    ActionController::Base.helpers.number_to_human_size(number)
  end

  def valid_file_type?(content_type)
    allowed_types = %w[image/jpeg image/jpg image/png application/pdf]
    allowed_types.include?(content_type)
  end
end