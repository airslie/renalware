#
# When subscribed to HL7 `oru_message_arrived` messages, gets notified of incoming HL7 messages
# and creates the observations contained therein provided the patient exists.
#
module Renalware
  module Pathology
    module Ingestion
      class MessageListener
        # NOTE: We are already inside a transaction here
        def oru_message_arrived(args)
          feed_message_id = args[:feed_message]&.id
          pathology_params = parse_pathology_params(args[:hl7_message])
          create_observation_requests_and_their_child_observations_from(
            pathology_params,
            feed_message_id
          )
          #
          # Note: The current_observation_set for the patient is updated by a trigger here!
          #
        end

        private

        def parse_pathology_params(hl7_message)
          ObservationRequestsAttributesBuilder.new(hl7_message).parse
        end

        def create_observation_requests_and_their_child_observations_from(
          pathology_params,
          feed_message_id
        )
          return if pathology_params.nil? # e.g. patient does not exist

          CreateObservationRequests.new.call(pathology_params, feed_message_id: feed_message_id)
        end
      end
    end
  end
end
