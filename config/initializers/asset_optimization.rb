# Asset and frontend performance optimizations

Rails.application.configure do
  if Rails.env.production?
    # Enable gzip compression
    config.middleware.use Rack::Deflater

    # Set far future expires for static assets
    config.static_cache_control = "public, max-age=#{1.year.to_i}"

    # Enable asset compression and minification
    config.assets.compress = true
    config.assets.js_compressor = :terser
    config.assets.css_compressor = :sass

    # Precompile additional assets
    config.assets.precompile += %w[
      dashboard.js
      dashboard.css
      charts.js
      admin/application.css
    ]
  end

  # Development optimizations
  if Rails.env.development?
    # Cache asset compilation in development
    config.assets.cache_store = :file_store, Rails.root.join('tmp', 'cache', 'assets')
  end
end

# Configure HTTP caching headers for better browser caching
Rails.application.config.middleware.insert_before(
  ActionDispatch::Static,
  Rack::Cache,
  verbose: false,
  metastore: 'file:tmp/cache/rack/meta',
  entitystore: 'file:tmp/cache/rack/body'
) if Rails.env.production?