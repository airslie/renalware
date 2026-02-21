module Renalware
  module Pathology
    class RequestForPatientRequestDescriptionQuery
      def initialize(patient, request_description)
        @patient = patient
        @request_description = request_description
      end

      def call
        @patient
          .requests
          .includes(request_descriptions: :required_observation_description)
          .where(
            pathology_request_descriptions_requests_requests: {
              request_description_id: @request_description.id
            }
          )
          .order(created_at: :desc)
          .limit(1)
          .pick(:created_at)
      end
    end
  end
end
