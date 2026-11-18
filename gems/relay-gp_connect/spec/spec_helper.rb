# The specs for this gem must run without Rails (and so without a database, Renalware models or
# Renalware.config). Do not require rails_helper here; spec/relay/gp_connect_standalone_spec.rb
# fails if Rails gets loaded.
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "relay/gp_connect"
require "faraday"
require "tmpdir"
require "active_support/testing/time_helpers"
require "vcr"
require "webmock/rspec"

Dir[File.join(__dir__, "support/**/*.rb")].each { |file| require file }

VCR.configure do |config|
  config.cassette_library_dir = File.join(__dir__, "fixtures/vcr_cassettes")
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.mock_with(:rspec) { |m| m.verify_partial_doubles = true }
  config.disable_monkey_patching!
  config.order = :random

  config.include ActiveSupport::Testing::TimeHelpers
  config.include FaradayHelper
  config.include MeshConfigHelper
  config.include DeliveryRequestHelper
end
