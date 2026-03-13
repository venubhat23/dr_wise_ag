require 'aws-sdk-s3'

# Cloudflare R2 Client Configuration
R2_CLIENT = Aws::S3::Client.new(
  access_key_id: "52ed60ae0a0776fb357299dede45ab9f",
  secret_access_key: "5b19ea5dede62f503eebb2b57de7719962f38d6b86ef387f993bcf0d6102f657",
  endpoint: "https://1f8982473cb9a48a41c053ca18db87ca.r2.cloudflarestorage.com",
  region: 'auto',
  force_path_style: true
)

# Cloudflare R2 Configuration Constants
R2_CONFIG = {
  bucket: "dr-wise-software",
  public_url: "https://pub-5c8ca1934dba43a9bc18041c326adce0.r2.dev"
}.freeze

# Cloudflare R2 compatibility configuration
Rails.application.config.to_prepare do
  # Only run this configuration for R2
  if Rails.env.development? || Rails.env.production?
    # Load AWS SDK when needed
    begin
      # Configure AWS SDK to be compatible with R2
      Aws.config.update(
        s3: {
          signature_version: 'v4',
          force_path_style: true,
          compute_checksums: false  # This is key for R2 compatibility
        }
      )
    rescue LoadError
      Rails.logger.warn "AWS SDK not available, skipping R2 configuration"
    end
  end
end