class CloudflareR2Service < ActiveStorage::Service::S3Service
  def upload(key, io, content_type:, filename:, content_length: nil, **options)
    instrument :upload, key: key, content_type: content_type, filename: filename do
      # Remove all checksum options for R2 compatibility
      clean_options = options.except(:content_md5, :checksum_sha256, :checksum_sha1, :checksum_crc32, :checksum_crc32c)

      if io.size < 100.megabytes
        upload_with_single_part(key, io, content_type: content_type, **clean_options)
      else
        upload_with_multipart(key, io, content_type: content_type, **clean_options)
      end
    end
  end

  private

  def upload_with_single_part(key, io, content_type:, **options)
    bucket.put_object(
      body: io,
      content_type: content_type,
      key: key,
      **options
    )
  rescue Aws::S3::Errors::InvalidRequest => e
    Rails.logger.warn "R2 upload error for key #{key}: #{e.message}"
    # Retry without any additional options
    bucket.put_object(
      body: io,
      content_type: content_type,
      key: key
    )
  end

  def upload_with_multipart(key, io, content_type:, **options)
    upload = bucket.object(key).initiate_multipart_upload(
      content_type: content_type
    )

    parts = []
    part_number = 1

    while (chunk = io.read(5.megabytes))
      part = upload.upload_part(
        part_number: part_number,
        body: chunk
      )
      parts << { etag: part.etag, part_number: part_number }
      part_number += 1
    end

    upload.complete(multipart_upload: { parts: parts })
  rescue => e
    Rails.logger.error "Multipart upload failed for key #{key}: #{e.message}"
    upload&.abort
    raise
  end
end