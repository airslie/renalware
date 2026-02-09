source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

gem "activesupport_cache_database", github: "airslie/activesupport-cache-database"
gem "sprockets-rails"

# https://opentelemetry.io/docs/instrumentation/ruby/getting-started/
# See config/initializers/opentelemetry.rb where we load this group if
# opentelemetry is enabled with an ENV var.
group :opentelemetry do
  gem "opentelemetry-exporter-otlp"
  gem "opentelemetry-instrumentation-active_job"
  gem "opentelemetry-instrumentation-faraday"
  gem "opentelemetry-instrumentation-net_http"
  gem "opentelemetry-instrumentation-pg"
  gem "opentelemetry-instrumentation-rack"
  gem "opentelemetry-instrumentation-rails"
  gem "opentelemetry-sdk"
end

gem "autoprefixer-rails"
gem "aws-sdk-s3", require: false # for active storage when using Heroku for test environments
gem "bootsnap", require: false # speeds up rspec and rails server boot time in development
gem "faker"
gem "i18n-tasks", require: false
gem "jsbundling-rails", "~> 1.0"
gem "net-smtp", require: false # remove in Rails 7
gem "nhs_api_client", github: "airslie/nhs_api_client", require: false
gem "rails", "~> 8.1.2"
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

gem "tailwind_merge", "< 1.0" # For Tailwind 3.4

group :test do
  gem "capybara" # , "~> 3.32"
  gem "capybara-screenshot" # , "~> 1.0"
  gem "capybara-select-2", github: "airslie/capybara_select2", branch: "playwright"
  gem "cucumber", github: "cucumber/cucumber-ruby"
  gem "cucumber-rails", require: false # , "~> 2.6.1", require: false # must be loaded in env.rb
  gem "database_cleaner", require: false # for cucumber (now not needed for rspec)
  gem "execjs" # , "2.7.0" # 2.8.1 raises an error
  gem "fuubar", require: false
  gem "rails-controller-testing", "~> 1.0.4"
  gem "rspec-html-matchers", require: false
  gem "rspec_junit_formatter", "~> 0.4"
  gem "rspec-retry"
  # gem "selenium-webdriver", "4.28.0"
  gem "shoulda-matchers", "~> 7.0"
  gem "simplecov", require: false # only loaded if required
  gem "simplecov-cobertura", "~> 3.1", require: false
  gem "test-prof"
  gem "vcr", require: false
  gem "webmock", "~> 3.7", require: false
  gem "wisper-rspec", "~> 1.1.0"
end

group :production do
  # For redirecting renalware-demo.herokuapp.com => demo.renalware.app
  gem "rack-host-redirect", github: "airslie/rack-host-redirect"
  gem "wkhtmltopdf-heroku", "~> 3.0.0"
end

group :development do
  # gem "meta_request" # useful for https://github.com/dejan/rails_panel
  # gem "traceroute" # for finding unused routes
  gem "awesome_print", require: false
  gem "binding_of_caller"
  # gem "bullet"
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
  gem "ruby-lsp", "~> 0.24", require: false
  gem "stackprof"
  gem "web-console"
end

group :development, :test do
  gem "brakeman"
  gem "bundler-audit", require: false
  gem "capybara-playwright-driver"
  gem "guard", require: false
  gem "guard-cucumber", require: false
  gem "guard-rspec", require: false
  # Start debugger with binding.b [https://github.com/ruby/debug]
  gem "debug", ">= 1.0.0", platforms: %i(mri windows)
  gem "factory_bot_rails", "~> 6.2"
  gem "launchy", require: false
  gem "overcommit"
  gem "pry-rails"
  gem "rspec-rails"
  gem "rubocop", require: false
  gem "wkhtmltopdf-binary", "0.12.6.8"
end

# From gemspec
gem "activerecord-import", "~> 1.0"
gem "activerecord-postgres_enum", "~> 2.0"
gem "acts_as_list", "~> 1.1"
gem "after_commit_everywhere"
gem "ahoy_matey"
gem "attr_extras"
gem "bcrypt_pbkdf"
gem "clipboard-rails", "~> 1.7.1"
gem "cocoon", "~> 1.2.11"
gem "combine_pdf", "~> 1.0.26"
gem "concurrent-ruby", "~> 1.1"
gem "cronex", "~> 0.6"
gem "devise", ">= 5"
gem "devise-security"
gem "diffy"
gem "dotenv-rails"
gem "dumb_delegator", "~> 1.1"
gem "ed25519"
gem "email_validator", "> 1.6.0"
gem "enumerize", "~> 2.5"
gem "faraday"
gem "faraday-retry"
gem "fhir_models"
gem "font-awesome-sass", "~> 5.6" # See icons here: https://fortawesome.github.io/Font-Awesome/icons/
gem "friendly_id", "~> 5.3"
gem "fugit", ">= 1.1"
gem "groupdate", ">= 4.2", "< 7"
gem "hashdiff", "~> 1.0"
gem "i18n" # , "~> 1.8.9"
gem "inline_svg", "~> 1.8"
gem "jbuilder", "~> 2.8"
gem "jquery-rails", "~> 4.4"
gem "kaminari", "~> 1.1"
gem "liquid", "~> 5.6"
gem "lograge", "~> 0.11"
gem "naught", "~> 1.1.0"
gem "nested_form", "~> 0.3.2"
gem "net-ldap"
gem "net-sftp", "~> 4.0"
gem "nokogiri", "~> 1.9"
gem "omniauth"
gem "omniauth-entra-id" # OAuth2/OIDC against Entra ID
gem "omniauth-rails_csrf_protection"
gem "ox", "~> 2.13"
gem "pagy", "~> 9.0"
gem "pandoc-ruby", "~> 2.1.4"
gem "paper_trail"
gem "paranoia", "~> 3.0"
gem "pdf-reader", "~> 2.9"
gem "pg", "~> 1.1"
gem "phlex-rails"
gem "prawn", "~> 2.5.0"
gem "prawn-table", "~> 0.2"
gem "psych", ">= 5.1.2" # required for ruby 3.x to avoid invalid database.yml error
gem "puma", "< 8" # Puma 7 may require testing due to call back changes
gem "pundit", "~> 2.5.0"
gem "rack"
gem "rack-attack"
gem "ransack", "~> 4.2"
gem "rqrcode", "~> 2.0"
gem "ruby-hl7", "~> 1.3"
gem "sassc-rails", "~> 2.1.0"
gem "scenic", "~> 1.5"
gem "sendgrid-ruby", "~> 6.7"
gem "simple_form", "~> 5.1"
gem "sinatra"
gem "slim-rails"
gem "store_model", "< 5"
gem "tailwindcss-rails", "~> 3.0"
gem "tailwindcss-ruby", "~> 3.4"
gem "turbo-rails", "2.0.23"
gem "validates_timeliness"
gem "view_component", "< 4.0"
gem "virtus", "~> 1.0.5"
gem "wicked_pdf", "~> 2.8.0"
gem "wisper", "~> 3.0.0"
gem "wisper-activejob", "~> 1.0.0"
gem "yard", ">= 0.9.35"
