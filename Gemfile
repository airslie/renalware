# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby ">= 3.3"

gemspec

gem "activesupport_cache_database", github: "airslie/activesupport-cache-database"

# https://opentelemetry.io/docs/instrumentation/ruby/getting-started/
# See demo/config/initializers/opentelemetry.rb where we load this group if
# opentelemetry is enabled with an ENV var.
group :opentelemetry do
  gem "opentelemetry-exporter-otlp"
  gem "opentelemetry-instrumentation-faraday"
  gem "opentelemetry-instrumentation-net_http"
  gem "opentelemetry-instrumentation-pg"
  gem "opentelemetry-instrumentation-rack"
  gem "opentelemetry-instrumentation-rails"
  gem "opentelemetry-sdk"
end

# These are visible to demo app only
gem "autoprefixer-rails"
gem "aws-sdk-s3", require: false # for active storage when using Heroku for test environments
gem "bootsnap", require: false # speeds up rspec and rails server boot time in development
gem "daemons", require: false # to use cmds like `bin/delayed_job start`
gem "faker"
gem "i18n-tasks", "~> 1.0.12"
gem "jsbundling-rails", "~> 1.0"
gem "net-smtp", require: false # remove in Rails 7
gem "nhs_api_client", github: "airslie/nhs_api_client", require: false
gem "paper_trail"
gem "party_foul", "~> 1.5.5", github: "airslie/party_foul"
gem "rails", "~> 7.2.2"
gem "renalware-forms", ">=0.1", github: "airslie/renalware-forms", branch: "main"
gem "ruby-prof", require: false
gem "solid_cache"
gem "terser"
gem "thruster"
# Re wkhtmltopdf binary for letter generation
# a host app could include the wkhtmltopdf-binary gem, or use the apt package.
# Bear in mind the gem contains several platform-specific binaries so is pretty large,
# so in a docker image the apt package is a better choice
gem "httparty", require: false

gem "rake"

gem "strong_migrations"

gem "fhir_stu3_models", github: "airslie/fhir_stu3_models"
gem "good_job", "~> 4.0"

gem "matrix"

group :test do
  gem "capybara" # , "~> 3.32"
  gem "capybara-screenshot" # , "~> 1.0"
  gem "capybara-select-2"
  gem "cucumber", "~> 9.2"
  gem "cucumber-rails", require: false # , "~> 2.6.1", require: false # must be loaded in env.rb
  gem "database_cleaner", require: false # for cucumber (now not needed for rspec)
  gem "execjs" # , "2.7.0" # 2.8.1 raises an error
  gem "fuubar", require: false
  gem "rails-controller-testing", "~> 1.0.4"
  gem "rspec-html-matchers", require: false
  gem "rspec_junit_formatter", "~> 0.4"
  gem "rspec-retry"
  gem "selenium-webdriver", "~> 4.11"
  gem "shoulda-matchers", "~> 6.1"
  gem "simplecov", "~> 0.17", require: false # only loaded if required
  gem "test-prof"
  gem "vcr", require: false
  gem "webmock", "~> 3.7", require: false
  gem "wisper-rspec", "~> 1.1.0"
end

group :production do
  # For redirecting renalware-demo.herokuapp.com => demo.renalware.app
  gem "rack-host-redirect", github: "airslie/rack-host-redirect"
  gem "wkhtmltopdf-heroku", "3.0.0.pre.rc0"
end

group :development do
  # gem "meta_request" # useful for https://github.com/dejan/rails_panel
  # gem "traceroute" # for finding unused routes
  gem "awesome_print", require: false
  gem "binding_of_caller"
  gem "bullet", "~> 7.2"
  gem "foreman", require: false
  gem "query_count"
  gem "rack-mini-profiler"
  gem "rubocop-capybara", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rake", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rspec_rails", require: false
  gem "turnip", github: "airslie/turnip", require: false
  # gem 'sql_tracker'
  gem "solargraph"
  gem "web-console"

  # For sentry error reporting and metrics - load stackprof first
  # rubocop:disable Bundler/OrderedGems
  gem "stackprof"
  gem "sentry-opentelemetry"
  gem "sentry-ruby"
  gem "sentry-rails"
  # rubocop:enable Bundler/OrderedGems
end

group :development, :test do
  gem "bundler-audit", require: false
  # Start debugger with binding.b [https://github.com/ruby/debug]
  gem "debug", ">= 1.0.0", platforms: %i(mri mingw x64_mingw)
  gem "factory_bot_rails", "~> 6.2"
  gem "launchy", require: false
  gem "pry-rails"
  gem "rspec-rails"
  gem "rubocop", require: false
  gem "wkhtmltopdf-binary", "0.12.6.8"
end
