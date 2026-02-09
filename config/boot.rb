# Set up gems listed in the Gemfile.
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" if File.exist?(ENV.fetch("BUNDLE_GEMFILE", nil))
begin
  require "bootsnap/setup"
rescue LoadError, StandardError
  # Allow boot to continue if bootsnap is unavailable or incompatible locally.
end
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
