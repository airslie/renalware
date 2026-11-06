module Renalware
  module Letters
    module Formats::FHIR
      module Resources
        # The top-level 'message' Bundle that will contain
        # - the message header
        # - the organisation, because it is referenced in the MessageHeader
        # - the document bundle with the main payload in.
        class Bundle
          include Support::Construction
          include Support::Helpers

          PROFILE_URL = "https://fhir.nhs.uk/STU3/StructureDefinition/ITK-Message-Bundle-1".freeze

          def call
            ::FHIR::STU3::Bundle.new(
              type: "message",
              id: arguments.transmission_uuid,
              meta: {
                lastUpdated: arguments.letter_datetime,
                profile: PROFILE_URL
              },
              identifier: system_identifier(arguments.transmission_uuid),
              entry: [
                MessageHeader.call(arguments),
                ITK::Organisation.call(arguments),
                GPConnect::DocumentBundle.call(arguments)
              ]
            )
          end
        end
      end
    end
  end
end
