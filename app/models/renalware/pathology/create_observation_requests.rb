#
# Create pathology observations requests and their child observations for an existing
# patient from HL7 message content previously parsed into an array of hashes (there can be > 1 OBR
# in each message).
#
module Renalware
  module Pathology
    class CreateObservationRequests
      include Broadcasting

      def self.call(...) = new.broadcasting_to_configured_subscribers.call(...)

      # params is an array of hashes, each hash representing an observation request
      # and its child observations
      # Example:
      # [
      #   {
      #     patient_id: 123,
      #     observation_request: {
      #       requestor_order_number: "123",
      #       filler_order_number: "F456",
      #       description_id: 1,
      #       requested_at: "2020-01-01 10:00",
      #       observations_attributes: [
      #         { description_id: 1, observed_at: "2020-01-01 10:00", result: "1.1" },
      #         { description_id: 2, observed_at: "2020-01-01 10:00", result: "2.2" }
      #       ]
      #     }
      #   }
      # ]
      # feed_message_id is optional, the id of the feed message from which these params were parsed
      # We store it on the observation request for audit purposes.
      # NOTE: We are already inside a transaction here!
      # We broadcast before and after persisting each observation request
      # so that other services can hook into this process.
      #
      def call(params, feed_message_id: nil)
        Array(params).each do |request|
          patient = find_patient(request.fetch(:patient_id))
          next if patient.nil?

          observation_params = request.fetch(:observation_request)
          broadcast :before_observation_request_persisted, observation_params
          obr = patient.observation_requests.create!(
            observation_params.merge(feed_message_id: feed_message_id)
          )
          broadcast :after_observation_request_persisted, obr
        end
      end

      private

      def find_patient(id) = Pathology::Patient.find_by(id: id)
    end
  end
end
