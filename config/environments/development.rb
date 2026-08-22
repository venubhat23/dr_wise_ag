require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Configure 'rails notes' to inspect Cucumber files
  config.annotations.register_directories('features')
  config.annotations.register_extensions('feature') { |tag| /#\s*(#{tag}):?\s*(.*)$/ }

  # Settings specified here will take precedence over those in config/application.rb.

  # Make code changes take effect immediately without server restart.
  config.enable_reloading = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing.
  config.server_timing = true

  # Enable/disable Action Controller caching. By default Action Controller caching is disabled.
  # Run rails dev:cache to toggle Action Controller caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.public_file_server.headers = { "cache-control" => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false
  end

  # Change to :null_store to avoid any caching.
  config.cache_store = :memory_store

  # Set ActiveStorage to use Cloudflare R2
  config.active_storage.service = :development
  # Set ActiveStorage URL options for proper blob URLs
  config.after_initialize do
    ActiveStorage::Current.url_options = { host: "localhost", port: 3000, protocol: "http" }
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Make template changes take effect immediately.
  config.action_mailer.perform_caching = false

  # Set localhost to be used by links generated in mailer templates.
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

  # Outgoing SMTP for local testing (Gmail).
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.smtp_settings = {
    user_name: "drwisedev@gmail.com",
    password: "eynrfikkliphtqcv",
    address: "smtp.gmail.com",
    port: 587,
    domain: "localhost",
    authentication: :plain,
    enable_starttls_auto: true
  }

  # Set default URL options for Rails routes (including Active Storage URLs)
  Rails.application.routes.default_url_options = { host: "localhost", port: 3000 }

  # ActiveStorage disabled - using direct R2Service instead
  # config.after_initialize do
  #   ActiveStorage::Current.url_options = { host: "localhost", port: 3000, protocol: 'http' }
  # end

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Append comments with runtime information tags to SQL queries in logs.
  config.active_record.query_log_tags_enabled = true

  # Highlight code that enqueued background job in logs.
  config.active_job.verbose_enqueue_logs = true

  # Use the same durable queue backend as production. Without this, ActiveJob
  # silently falls back to Rails' in-process :async adapter here - jobs still
  # "run", but they never touch the solid_queue_* tables, so Mission Control
  # (/admin/jobs) can't detect Solid Queue and hides the Recurring tasks and
  # Workers tabs. recurring.yml's tasks only worked regardless, because
  # config/puma.rb runs a real Solid Queue supervisor independent of this.
  #
  # Deliberately NOT setting config.solid_queue.connects_to here (unlike
  # production.rb): database.yml's `queue:`/`cache:` blocks nest env name and
  # role backwards from Rails' convention (top-level `queue:` is read as an
  # env, not a role), so connects_to resolves to env "queue" + role
  # "production", which - combined with a local .env DATABASE_URL - lands on
  # an isolated local Postgres instead of the shared one. Leaving connects_to
  # unset means SolidQueue::Record just inherits ActiveRecord::Base's default
  # (primary/railway) connection, which is what we actually want here.
  config.active_job.queue_adapter = :solid_queue

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true

  # Raise error when a before_action's only/except options reference missing actions.
  config.action_controller.raise_on_missing_callback_actions = false

  # Serve static assets in development
  config.public_file_server.enabled = true

  # Add builds directory to asset paths for development
  config.assets.paths << Rails.root.join("app/assets/builds")
  config.assets.precompile = []

  # Apply autocorrection by RuboCop to files generated by `bin/rails generate`.
  # config.generators.apply_rubocop_autocorrect_after_generate!

  # N+1 query / unused eager loading detection. Logs warnings to
  # log/bullet.log and adds a footer alert in the browser instead of
  # raising, so it doesn't break the app while auditing.
  config.after_initialize do
    Bullet.enable        = true
    Bullet.alert         = false
    Bullet.bullet_logger = true
    Bullet.console       = true
    Bullet.rails_logger  = true
    Bullet.add_footer    = true
    Bullet.n_plus_one_query_enable = true
    Bullet.unused_eager_loading_enable = true
    Bullet.counter_cache_enable = true
  end
end

  # Set URL options for ActiveStorage
