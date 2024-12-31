module Renalware
  module Feeds
    class PatientLocator
      # Given an HL7 message type - eg :adt or :oru - create an instance of the configured
      # strategy class for that message type - eg DobAndAnyNHSOrAssigningAuthNumber - and call it,
      # passing through any other arguments (probably an object containing patient identifiers)
      # and return the result, which will be Renalware::Patient if one found, or nil if not.
      def self.call(hl7_message_type, **)
        klass = StrategyClassFactory.new(hl7_message_type).call
        klass.call(**)
      end

      # Given a config value like dob_and_any_nhs_or_assigning_auth_number, return the class
      # Renalware::Feeds::PatientLocatorStrategies::DobAndAnyNHSOrAssigningAuthNumber
      class StrategyClassFactory
        class InvalidStrategyError < StandardError; end
        class MissingStrategyError < StandardError; end

        pattr_initialize :hl7_message_type

        def call
          klass = strategy_name.to_s.classify
          "Renalware::Feeds::PatientLocatorStrategies::#{klass}".constantize
        rescue NameError
          raise InvalidStrategyError, "Could not resolve strategy class: #{klass}"
        end

        # Different HL7 message types can have different strategies for locating a patient in RW.
        def strategy_name
          Renalware.config.hl7_patient_locator_strategy.fetch(hl7_message_type.to_sym)
        rescue StandardError
          raise MissingStrategyError, "No strategy configured for msg type '#{hl7_message_type}'"
        end
      end
    end
  end
end
