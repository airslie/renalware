# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Tests will store ActiveStorage uploads in the dir specified :test in config/storage.yml
  config.active_storage.service = :test

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = false
  config.assets.css_compressor = nil

  config.log_level = :debug

  # To test log formatting and lograge in the Test env uncomment these lines
  # (by default in test we log to STDOUT)
  # config.log_level = :info
  # config.log_tags = [:request_id]
  # config.log_formatter = ::Logger::Formatter.new

  # Keep the test log no bigger than 10mb.
  # Keep at most 1 rotated file, so there usually be a 10mb spec/dummy/log/test.log.0 file
  # and the current test.log in existence
  config.logger = ActiveSupport::Logger.new(config.paths["log"].first, 1, 10 * 1024 * 1024)

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=3600"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = true

  Renalware::Engine.routes.default_url_options[:host] = "localhost"

  config.active_job.queue_adapter = :good_job
end
