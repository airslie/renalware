module Renalware
  module Reporting
    class Configuration
      include ActiveSupport::Configurable

      config_accessor(:filter_cache_expiry_seconds) {
        ENV.fetch("REPORTING_FILTER_CACHE_EXPIRY_SECONDS", "60").to_i
      }
    end

    def self.config
      @config ||= Configuration.new
    end

    def self.configure
      yield config
    end
  end
end
