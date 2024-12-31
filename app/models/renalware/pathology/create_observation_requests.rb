#
# Create pathology observations requests and their child observations for an existing
# patient from HL7 message content previously parsed into an array of hashes (there can be > 1 OBR
# in each message).
#
module Renalware
  module Pathology
    class CreateObservationRequests
      include Wisper::Publisher

      def call(params, feed_message_id: nil)
        Array(params).each do |request|
          patient = find_patient(request.fetch(:patient_id))
          observation_params = request.fetch(:observation_request)
          broadcast :before_observation_request_persisted, observation_params
          obr = patient.observation_requests.create!(
            observation_params.merge(feed_message_id: feed_message_id)
          )
          broadcast :after_observation_request_persisted, obr
        end
      end

      private

      def find_patient(id)
        ::Renalware::Pathology::Patient.find_by(id: id) || NullObject.instance
      end
    end
  end
end
