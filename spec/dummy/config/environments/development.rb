# frozen_string_literal: true

$stdout.sync = true

# In development don't ajax poll so often for a timeout as it can upset our byebug sessions.
Renalware.configure do |config|
  config.session_timeout_polling_frequency = 1.hour
end

Rails.application.configure do
  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
  end

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
  config.action_view.raise_on_missing_translations = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=172800"
    }
    config.cache_store = :redis_cache_store,
                         {
                           url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0/renalware")
                         }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Keep the developoment log no bigger than 10mb.
  # Keep at most 1 rotated file, so there will usually be a 10mb spec/dummy/log/developmen.log.0
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
  config.active_support.deprecation = :log

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

  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Run mailcatcher in development to see emails https://mailcatcher.me/
  #   $ gem install mailcatcher
  #   $ mailcatcher
  #   Go to http://localhost:1080/
  #   Send mail through smtp://localhost:1025
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { address: "localhost", port: 1025 }

  config.active_job.queue_adapter = :good_job
end
