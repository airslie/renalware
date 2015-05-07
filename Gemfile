source "https://rubygems.org"
ruby "2.2.0"

gem "rails", "~> 4.2"
gem "pg"
gem "foundation-rails"
gem "jquery-rails"
gem "underscore-rails"
gem "uglifier", ">= 1.3.0"
gem "sass-rails", "~> 4.0.3"
gem "haml-rails"
gem "sdoc", "~> 0.4.0", group: :doc
gem "httparty"
gem 'paper_trail', '~> 3.0.6'
gem "paranoia", "~> 2.0"
gem 'ransack', git: 'https://github.com/activerecord-hackery/ransack.git'

group :development, :test do
  gem "frog_spawn", :git => "git@github.com:dmgarland/frog_spawn.git"
  # gem "frog_spawn", :path => '/home/daniel/projects/frog_spawn'
  gem "spring"
  gem "cucumber-rails", :require => false
  gem "rspec-rails"
  gem "rspec-expectations"
  gem "capybara", "2.4.4"
  gem "launchy"
  gem "pry-byebug"
  gem "database_cleaner"
  gem "spring-commands-cucumber"
  gem "spring-commands-rspec"
  gem "ffaker"
  gem "mocha"
  gem "shoulda-matchers"
  gem "web-console", "~> 2.0"
  gem "factory_girl_rails", "~> 4.0"
end

group :test do
  gem "poltergeist", "~> 1.5.1"
  gem "webmock"
end

group :production do
  gem "rails_12factor"
  gem "unicorn"
end
