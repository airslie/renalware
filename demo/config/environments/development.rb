$stdout.sync = true

Rails.application.configure do
  config.after_initialize do
    if defined?(Bullet)
      Bullet.enable = true
      Bullet.bullet_logger = true
      Bullet.console = false
      Bullet.rails_logger = true
    end
  end

  # Execute jobs in separate thread in the web process. This makes debugging easier and we do not
  # need to run bin/good_job unless testing cron-style jobs.
  config.good_job.execution_mode = :external

  config.hosts << "dev.test"

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true
  config.i18n.raise_on_missing_translations = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=172800"
    }
    config.cache_store = :solid_cache_store
    config.cache_store = :solid_cache_store
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # Keep the development log no bigger than 10mb.
  # Keep at most 1 rotated file, so there will usually be a 10mb demo/log/developmen.log.0
  # file and the current development.log in existence
  config.logger = ActiveSupport::Logger.new(config.paths["log"].first, 1, 10 * 1024 * 1024)

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  # config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false
  config.assets.css_compressor = nil

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Run mailcatcher in development to see emails https://mailcatcher.me/
  #   $ gem install mailcatcher
  #   $ mailcatcher
  #   Go to http://localhost:1080/
  #   Send mail through smtp://localhost:1025

  # Deliver email via Microsoft Graph API using client credentials OAuth flow.
  config.action_mailer.delivery_method = :microsoft_graph_api

  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = { address: "localhost", port: 1025 }
  Rails.application.default_url_options = { host: "localhost", port: 3000 }

  config.active_job.queue_adapter = :good_job
end
