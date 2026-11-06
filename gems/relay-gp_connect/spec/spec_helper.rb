# The specs for this gem must run without Rails (and so without a database, Renalware models or
# Renalware.config). Do not require rails_helper here; spec/relay/gp_connect/standalone_spec.rb
# fails if Rails gets loaded.
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "relay/gp_connect"

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.mock_with(:rspec) { |m| m.verify_partial_doubles = true }
  config.disable_monkey_patching!
  config.order = :random
end
