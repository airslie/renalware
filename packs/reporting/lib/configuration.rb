module Renalware
  module Reporting
    class Configuration
      include Renalware::ConfigAccessors

      config_accessor(:filter_cache_expiry_seconds) do
        ENV.fetch("REPORTING_FILTER_CACHE_EXPIRY_SECONDS", "60").to_i
      end
    end

    class << self
      def config        = Configuration.config # rubocop:disable Rails/Delegate
      def configure(&)  = Configuration.configure(&)
    end
  end
end
