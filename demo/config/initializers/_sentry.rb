if defined?(Sentry)
  Sentry.init do |config|
    config.dsn = Renalware.config.sentry_dsn
    config.breadcrumbs_logger = %i(active_support_logger http_logger)

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    config.traces_sample_rate = Renalware.config.sentry_traces_sample_rate

    # Set profiles_sample_rate to profile 100%
    # of sampled transactions.
    # We recommend adjusting this value in production.
    config.profiles_sample_rate = Renalware.config.sentry_profiles_sample_rate
  end
end
