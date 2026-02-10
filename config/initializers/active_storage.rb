# Active Storage configuration
Rails.application.config.after_initialize do
  # Set default URL options for Active Storage
  if Rails.env.development?
    Rails.application.routes.default_url_options = {
      host: "localhost",
      port: 3000,
      protocol: 'http'
    }

    # Set Active Storage URL options
    ActiveStorage::Current.url_options = {
      host: "localhost",
      port: 3000,
      protocol: 'http'
    }
  elsif Rails.env.production?
    Rails.application.routes.default_url_options = {
      host: "dr-wise-ag.onrender.com",
      protocol: 'https'
    }

    # Set Active Storage URL options for production
    ActiveStorage::Current.url_options = {
      host: "dr-wise-ag.onrender.com",
      protocol: 'https'
    }
  end
end