module Renalware
  module Pathology
    class ObservationForPatientRequestDescriptionQuery
      def initialize(patient, request_description)
        @patient = patient
        @observation_description = request_description.required_observation_description
      end

      # I tried to switch over here to pulling the results from current_observation_set but]
      # the dates seemed to be one year ahead in the test suite
      def call
        return if @observation_description.nil?

        return if @patient.current_observation_set.nil?

        result = @patient.current_observation_set.values[@observation_description.code]
        if result
          OpenStruct.new(
            observed_on: Time.zone.parse(result["observed_at"]).to_date,
            result: result["result"].to_f
          )
        end

        # @patient
        #   .observations
        #   .where(description: @observation_description)
        #   .order(observed_at: :desc)
        #   .first
      end
    end
  end
end
