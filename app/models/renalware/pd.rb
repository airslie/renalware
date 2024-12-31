module Renalware
  module PD
    def self.table_name_prefix = "pd_"
    def self.cast_patient(patient) = patient.becomes(PD::Patient)

    # PD-specific configuration
    #
    # You can override default settings here in an initializer in the host app like so:
    #   Renalware::PD.configure do |config|
    #     config.delivery_intervals = [2.days, 1.week, 3.weeks, 1.year]
    #   end
    #
    #  You can access PD configuration like so
    #    Renalware::PD.config.delivery_intervals
    #
    class Configuration
      include ActiveSupport::Configurable

      config_accessor(:delivery_intervals) { [1.week, 2.weeks, 3.weeks, 4.weeks] }

      config_accessor(:training_durations) { (1..15).map(&:days) }
    end

    def self.config
      @config ||= Configuration.new
    end

    def self.configure
      yield config
    end

    module APD
      class NonUniqueOvernightVolumeError < StandardError
      end
    end
  end
end
