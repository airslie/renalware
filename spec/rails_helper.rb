# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= "test"

require_relative "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../demo/config/environment"
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"

require "fuubar"
require "factory_bot_rails"
require "shoulda/matchers"
require "pundit/rspec"
require "paper_trail/frameworks/rspec"
require "wisper/rspec/matchers"
require "view_component/test_helpers"
require "capybara/rspec"
require "capybara-screenshot/rspec"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_request do |request|
    request.uri.include?("__identify__") || request.uri.include?("session")
  end
end

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Renalware::Engine.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
Dir[Renalware::Engine.root.join("spec/pages/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.full_backtrace = false

  # System tests use Rack::Test for non JS test and headless Chrome for JS specs
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  Capybara::Screenshot.register_driver(:rw_headless_chrome) do |driver, path|
    driver.browser.save_screenshot(path)
  end

  Capybara.register_driver(:rw_headless_chrome) do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_preference(:download, prompt_for_download: false)
    options.add_preference(:download, default_directory: Rails.root.join("tmp"))
    options.add_argument("window-size=1366,1768")
    options.add_argument("headless=new") unless ENV["HEADFULL"]
    options.add_argument("disable-gpu")
    options.add_argument("disable-extensions")
    options.add_argument("no-sandbox")
    options.add_argument("enable-features=NetworkService,NetworkServiceInProcess")

    # If using `binding.b` or `binding.pry` in Capybara tests,
    # it's a good idea to increase the timeout to avoid cut-outs
    client = Selenium::WebDriver::Remote::Http::Default.new
    unless ENV["CI"]
      client.open_timeout = 30.minutes.to_i
    end

    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      http_client: client,
      options: options
    )
  end

  config.before(:each, js: true, type: :system) do
    driven_by :rw_headless_chrome
  end

  # Make I18n t() and l() helpers available
  config.include AbstractController::Translation

  # show retry status in spec process
  config.verbose_retry = true

  # show exception that triggers a retry if verbose_retry is set to true
  config.display_try_failure_messages = true

  config.retry_callback = proc do |ex|
    Capybara.reset! if ex.metadata[:js]
  end

  if ENV["CI"]
    config.around :each, :js do |ex|
      ex.run_with_retry retry: 2
    end
  end

  config.around(:each, :caching) do |example|
    caching = ActionController::Base.perform_caching
    ActionController::Base.perform_caching = example.metadata[:caching]
    example.run
    Rails.cache.clear
    ActionController::Base.perform_caching = caching
  end

  config.example_status_persistence_file_path = Rails.root.join("tmp/examples.txt")

  config.fixture_paths ||= []
  config.fixture_paths << Rails.root.join("spec/fixtures")

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.include Renalware::Engine.routes.url_helpers
  config.include Wisper::RSpec::BroadcastMatcher
  config.include CapybaraHelper, type: %i(system feature)
  config.include SelectDateSpecHelper, type: %i(system feature)
  config.include TextEditorHelpers, type: :system
  config.include CapybaraSelect2, type: :system
  config.include ActiveSupport::Testing::TimeHelpers
  config.include Shoulda::Matchers::ActiveModel, type: :model
  config.include Shoulda::Matchers::ActiveRecord, type: :model
  config.include ViewComponent::TestHelpers, type: :component
  config.include ActionView::RecordIdentifier, type: :system
  config.include SlimSelectHelper, type: :system
  config.include CapybaraAccessibleSelectors::Session, type: :system
  config.include FormHelpers, type: :system

  config.fuubar_progress_bar_options = { progress_mark: "≈" }

  # By default, all specs will have versioning enabled.
  # Enable it one spec/example_group at a time by adding `versioning: true`.
  # Or you can enable it globally:
  #   config.before(:each) do
  #    ::PaperTrail.enabled = true
  #   end
  # See https://github.com/airblade/paper_trail#7b-rspec for more information.

  config.after(:each, js: true, type: :system) do
    # TODO: reinstate once we work out why Selenium on GH actions gives

    # errors = page.driver.browser.logs.get(:browser)
    # if errors.present?
    #   aggregate_failures "javascript errors" do
    #     errors.each do |error|
    #       # expect(error.level).not_to eq('SEVERE'), error.message
    #       next unless error.level == "WARNING"

    #       warn "WARN: javascript warning"
    #       warn error.message
    #     end
    #   end
    # end
  end
end
