ruby "2.5.1"

source "https://rubygems.org"
source "https://rails-assets.org"

gemspec

# These are visible to dummy app only
gem "bootsnap", require: false # speeds up rspec and rails server boot time in development
gem "daemons", require: false # to use cmds like `bin/delayed_job start`
gem "faker"
gem "party_foul", "~> 1.5.5"
gem "redis"

#
# devise_security_extension
#
# NB for now you will need to put this into the host app's Gemfile also.
# Once latest devise_security_extension changes are released uncomment this line.
# (check version has not bumped to 11 though). In the meantime, because we cannot use git
# references in the gemspec, we add this gem in the host app.
# The issue with the gem version of 0.10.0 is it requires rails < v5
# The master branch has this fixed so we are using that.
# Perhaps we should fork this into our own repo/gem.
gem "devise_security_extension",
    git: "https://github.com/phatworx/devise_security_extension.git"

# The main trix gem at https://github.com/maclover7/trix is not yet Rails 5.2 compatible; it give
# an argument error when calling f.trix_editor due to a Rails 5.2 ActionView change.
# For now use this fork until the upstream has been fixed (this line will also need to appear in
# each hospital's Gemfile for now)
gem "trix",
    git: "https://github.com/airslie/trix.git",
    branch: "master"

group :test do
  gem "capybara", "~> 3.12.0"
  gem "capybara-screenshot" # "~> 1.0.18"
  gem "capybara-select-2"
  # gem "chromedriver-helper" # this clashses with the */*-browsers images in cirlci so removed
  gem "codeclimate-test-reporter", "~> 1.0.9", require: false # loads simplecov
  gem "cucumber", "~> 3.1.0"
  gem "cucumber-rails", "~> 1.6.0", require: false # must be loaded in env.rb
  gem "database_cleaner", "~> 1.7.0", require: false # for cucumber (now not needed for rspec)
  gem "factory_bot_rails", "~> 4.11"
  gem "fuubar", require: false
  gem "rails-controller-testing", "~> 1.0.4"
  gem "rspec-html-matchers", "~> 0.9.1"
  gem "rspec-rails", "~> 3.8.0"
  gem "rspec_junit_formatter", "~> 0.4.1"
  gem "selenium-webdriver", "~> 3.141.0"
  gem "shoulda-matchers", "~> 3.1.2"
  gem "simplecov", "~> 0.13.0", require: false # only loaded if required
  gem "webmock", require: false
  gem "wisper-rspec", "~> 1.1.0"
end

group :staging do
  gem "newrelic_rpm"
  gem "wkhtmltopdf-heroku", "~> 2.12.3"
end

group :development do
  gem "awesome_print", require: false
  # gem "better_errors"
  # gem "binding_of_caller"
  gem "bullet"
  gem "foreman", require: false
  # gem "meta_request" # useful for https://github.com/dejan/rails_panel
  gem "rubocop-rspec", require: false # for housekeeping
  # gem "traceroute" # for finding unused routes
  gem "web-console", require: false
end

group :development, :test do
  gem "bundler-audit", require: false
  gem "byebug"
  gem "launchy", require: false
  gem "rubocop", require: false
  gem "spring"
  gem "spring-commands-cucumber", require: false
  gem "spring-commands-rspec", require: false
  gem "terminal-notifier-guard", require: false
end
