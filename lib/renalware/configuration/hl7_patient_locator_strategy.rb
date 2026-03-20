module Renalware
  class Configuration
    class HL7PatientLocatorStrategy
      DEFAULTS = {
        oru: :simple,
        adt: :simple
      }.freeze
      KEYS = %i(oru adt).freeze
      VALUES = %i(
        simple
        dob_and_any_nhs_or_assigning_auth_number
        nhs_or_any_assigning_auth_number
        dynamic
        dynamic2
      ).freeze

      def self.load_from_env
        new(raw: ENV.fetch("HL7_PATIENT_LOCATOR_STRATEGY", DEFAULTS.to_json)).call
      end

      def initialize(raw:)
        @raw = raw
      end

      def call
        parsed = parse
        validate!(parsed)
        parsed.slice(*KEYS)
      end

      private

      attr_reader :raw

      def parse
        parsed = JSON.parse(raw)
        parsed = JSON.parse(parsed) if parsed.is_a?(String) # Handle double-encoded JSON in ENV.

        parsed.each_with_object({}) { |(key, value), hash| hash[key.to_sym] = value.to_sym }
      end

      def validate!(parsed)
        missing_keys = KEYS - parsed.keys
        if missing_keys.any?
          raise(
            ArgumentError,
            "HL7_PATIENT_LOCATOR_STRATEGY is missing keys: #{missing_keys.join(', ')}"
          )
        end

        invalid_values = parsed.slice(*KEYS).reject { |_key, value| VALUES.include?(value) }
        return if invalid_values.empty?

        raise ArgumentError,
              "HL7_PATIENT_LOCATOR_STRATEGY has invalid values: " \
              "#{invalid_values.map { |key, value| "#{key}=#{value}" }.join(', ')}. " \
              "Allowed values: #{VALUES.join(', ')}"
      end
    end
  end
end
