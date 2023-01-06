# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby ">= 3.1"

gemspec

gem "activesupport_cache_database", github: "airslie/activesupport-cache-database"

# These are visible to dummy app only
gem "autoprefixer-rails"
gem "aws-sdk-s3", require: false # for active storage when using Heroku for test environments
# gem "babel-transpiler" # not sure this is need now that we user rollupjs + babel npmm packages?
gem "bootsnap", require: false # speeds up rspec and rails server boot time in development
gem "daemons", require: false # to use cmds like `bin/delayed_job start`
gem "faker"
gem "i18n-tasks", "~> 0.9.33"
gem "jsbundling-rails", "~> 1.0"
gem "net-smtp", require: false # remove in Rails 7
gem "nhs_api_client", github: "airslie/nhs_api_client", tag: "v0.1.2", require: false
gem "paper_trail"
gem "party_foul", "~> 1.5.5", github: "airslie/party_foul"
gem "redis", "~> 4.8"
gem "renalware-forms", ">=0.1.16", github: "airslie/renalware-forms", branch: "main"
gem "ruby-prof", require: false
gem "uglifier", "~> 4.2"
# Re wkhtmltopdf binary for letter generation
# a host app could include the wkhtmltopdf-binary gem, or use the apt package.
# Bear in mind the gem contains several platform-specific binaries so is pretty large,
# so in a docker image the apt package is a better choice
gem "httparty", require: false
gem "tailwindcss-rails", "~> 2.0.8"
gem "wkhtmltopdf-binary", "0.12.3.1"
# For sentry error reporting and metrics
# gem "sentry-rails"
# gem "sentry-ruby"
gem "strong_migrations"

gem "diff-lcs"
gem "diffy"
gem "good_job"

group :test do
  gem "capybara", "~> 3.32"
  gem "capybara-screenshot", "~> 1.0"
  gem "capybara-select-2"
  gem "cucumber-rails", "~> 2.6.1", require: false # must be loaded in env.rb
  gem "database_cleaner", require: false # for cucumber (now not needed for rspec)
  gem "execjs", "2.7.0" # 2.8.1 raises an error
  gem "fuubar", require: false
  gem "rails-controller-testing", "~> 1.0.4"
  gem "rspec-html-matchers", require: false
  gem "rspec_junit_formatter", "~> 0.4"
  gem "rspec-retry"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 5.1"
  gem "simplecov", "~> 0.17", require: false # only loaded if required
  gem "test-prof"
  gem "webdrivers", "~> 5.0"
  gem "webmock", "~> 3.7", require: false
  gem "wisper-rspec", "~> 1.1.0"
end

group :uat, :pr do
  # For redirecting renalware-demo.herokuapp.com => demo.renalware.app
  gem "rack-host-redirect", github: "airslie/rack-host-redirect"
  gem "wkhtmltopdf-heroku", "~> 2.12.3"
end

group :development do
  # gem "meta_request" # useful for https://github.com/dejan/rails_panel
  # gem "traceroute" # for finding unused routes
  gem "awesome_print", require: false
  gem "binding_of_caller"
  gem "bullet"
  gem "foreman", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "spring"
  gem "spring-commands-cucumber"
  gem "spring-commands-rspec"
  gem "turnip", "~> 4.0", github: "airslie/turnip", require: false
  # gem 'sql_tracker'
  gem "solargraph"
  gem "web-console"
end

group :development, :test do
  gem "bundler-audit", require: false
  gem "byebug"
  # Start debugger with binding.b [https://github.com/ruby/debug]
  gem "debug", ">= 1.0.0", platforms: %i(mri mingw x64_mingw)
  gem "factory_bot_rails", "~> 6.1"
  gem "launchy", require: false
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails"
  gem "rubocop", require: false
end
