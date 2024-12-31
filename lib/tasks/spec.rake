#
# These tasks run the turnip (migrated from cucumber) features.
#
namespace :spec do
  namespace :acceptance do
    if defined?(RSpec)
      ENV["RACK_ENV"] = ENV["RAILS_ENV"] = "test"
      require "rspec/core/rake_task"
      pattern = "./spec/acceptance/renalware/features/**/*.feature"

      # domain features are those that do not exercise the UI
      # Usage:
      #   bundle exec rake spec:acceptance:domain
      RSpec::Core::RakeTask.new(:domain) do |t|
        t.pattern = pattern
      end

      # web features exerciswe the UI and may use a webdriver is tagged with @javascript
      # Usage:
      #   bundle exec rake spec:acceptance:web
      RSpec::Core::RakeTask.new(:web) do |t|
        t.pattern = "./spec/acceptance/renalware/features/**/*.feature"
        t.rspec_opts = "--tag web --require spec_helper" # targets features with the @web tag only
        ENV["TURNIP_WEB"] = "1" # triggers inclusion of web_steps
      end

      # Run both domain and web acceptance specs.
      # Usage:
      #   bundle exec rake spec:acceptance:all
      task all: [:domain, :web]
    end
  end
end
