module Renalware
  module Pathology
    class ObservationsForCodesPresenter
      # Example usage
      #   ObservationsForCodesPresenter.new(patient: patient, codes: %w(HBA FER PHT))
      def initialize(patient:, codes:)
        @patient = Pathology.cast_patient(patient)
        @codes = Array(codes).map(&:upcase)
      end

      # Returns an array of observations reformatted to be easy to consume.
      def observations
        codes.map do |code|
          observation = observation_for(code) || NullObject.instance
          OpenStruct.new(code: code,
                         description: description_for(code).name,
                         result: observation.result,
                         observed_at: observation.observed_at)
        end
      end

      private

      attr_reader :patient, :codes

      def descriptions
        @descriptions ||= Renalware::Pathology::ObservationDescription.where(code: codes).to_a
      end

      def matching_observations
        @matching_observations ||= patient.current_observations.where(description_code: codes).to_a
      end

      def description_for(code)
        descriptions.find { |desc| desc.code.upcase == code } || NullObject.instance
      end

      def observation_for(code)
        matching_observations.find { |observation| observation.description_code.upcase == code }
      end
    end
  end
end
