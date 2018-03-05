# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

if ENV.key?("CC_TEST_REPORTER_ID") || ENV.key?("SIMPLECOV")
  require "simplecov"
  SimpleCov.command_name "Cucumber-" + (ENV["TEST_DEPTH"] || "domain")
end

require File.expand_path("../../../spec/dummy/config/environment.rb", __FILE__)

# Tell cucumber-rails where rails lives
ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + "../../../spec/dummy"

include Renalware::Engine.routes.url_helpers

# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

require "cucumber/rails"
require "capybara-screenshot/cucumber" if RUBY_PLATFORM =~ /darwin/
require "rspec/rails"
require "chosen-rails/rspec"
require "webmock"

require "factory_bot"
require "./spec/support/factory_bot"
FactoryBot.find_definitions

WebMock.disable!
# Capybara defaults to CSS3 selectors rather than XPath.
# If you"d prefer to use XPath, just uncomment this line and adjust any
# selectors in your step definitions to use the XPath syntax.
# Capybara.default_selector = :xpath
Capybara.default_max_wait_time = 5 # in seconds

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false
