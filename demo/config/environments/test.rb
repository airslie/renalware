Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.good_job.execution_mode = :inline # executes jobs immediately when adapter is :good_job
  config.active_job.queue_adapter = :test

  # Tests will store ActiveStorage uploads in the dir specified :test in config/storage.yml
  config.active_storage.service = :test

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true
  config.assets.css_compressor = nil
  config.i18n.raise_on_missing_translations = true
  config.log_level = :debug

  # To test log formatting and lograge in the Test env uncomment these lines
  # (by default in test we log to STDOUT)
  # config.log_level = :info
  # config.log_tags = [:request_id]
  # config.log_formatter = ::Logger::Formatter.new

  # Keep the test log no bigger than 10mb.
  # Keep at most 1 rotated file, so there usually be a 10mb demo/log/test.log.0 file
  # and the current test.log in existence
  config.logger = ActiveSupport::Logger.new(config.paths["log"].first, 1, 10 * 1024 * 1024)

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  # If your project has continuous integration in place, it is a good idea to eager load the
  # application when the suite runs there. If the application cannot be eager loaded for
  # whatever reason, you want to know in CI, better than in production, right?
  # CIs typically set some environment variable to indicate the test suite is running there.
  # Starting with Rails 7, newly generated applications are configured that way by default.
  config.eager_load = ENV["CI"].present?

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=3600"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  # config.action_dispatch.show_exceptions = false
  config.action_dispatch.show_exceptions = :all # rescuable

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  # config.active_support.deprecation = :log
  # Rails.application.deprecators.disallowed_warnings = :all

  # Raises error for missing translations
  config.i18n.raise_on_missing_translations = true

  Rails.application.default_url_options = { host: "localhost", port: 3000 }
end
