module Renalware
  module Letters
    class Part::ClinicalObservations < Section
      include Renalware::AttributeNameHelper
      OBSERVATION_ATTRS = %i(bp weight height bmi urine_blood urine_protein urine_glucose).freeze
      OBSERVATION_UNITS = { weight: :kg, height: :m }.freeze
      delegate(*OBSERVATION_ATTRS, to: :event)
      delegate :any?, to: :observations

      def each_observation
        observations.each do |arr|
          label, result, unit_of_measurement = arr
          yield(label, result, unit_of_measurement)
        end
      end

      def to_partial_path
        "renalware/letters/parts/clinical_observations"
      end

      private

      def observations
        OBSERVATION_ATTRS.each_with_object([]) do |observation, arr|
          value = send(observation)
          next if value.blank?

          arr << [
            label_for(observation),
            enum_text_or_raw_value_for(value),
            OBSERVATION_UNITS[observation]
          ]
        end
      end

      def label_for(observation)
        attr_name(Renalware::Clinics::ClinicVisit, observation)
      end

      def enum_text_or_raw_value_for(value)
        value.try(:text) || value
      end
    end
  end
end
