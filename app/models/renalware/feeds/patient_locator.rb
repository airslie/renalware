# frozen_string_literal: true

module Renalware
  module Feeds
    class PatientLocator
      def self.call(patient_identification)
        strategy.call(patient_identification: patient_identification)
      end

      def self.strategy
        configured_strategy = Renalware.config.hl7_patient_locator_strategy
        case configured_strategy
        when :simple
          Renalware::Feeds::PatientLocatorStrategies::Simple
        when :dob_and_any_nhs_or_assigning_auth_number
          Renalware::Feeds::PatientLocatorStrategies::DobAndAnyNHSOrAssigningAuthNumber
        else
          raise "Invalid Renaware.config.hl7_patient_locator_strategy: #{configured_strategy}"
        end
      end
    end
  end
end
