# frozen_string_literal: true

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

          PROFILE_URL = "https://fhir.nhs.uk/STU3/StructureDefinition/ITK-Message-Bundle-1"

          def call
            ::FHIR::STU3::Bundle.new(
              type: "message",
              id: arguments.transmission_uuid,
              meta: {
                lastUpdated: letter.updated_at.to_datetime, # Or message.created_at?
                profile: PROFILE_URL
              },
              identifier: system_identifier(arguments.transmission_uuid),
              entry: [
                MessageHeader.call(arguments),
                ITK::Organisation.call(arguments),
                document_bundle_class.call(arguments)
              ]
            )
          end

          private

          def document_bundle_class
            arguments.gp_connect? ? GPConnect::DocumentBundle : TransferOfCare::DocumentBundle
          end
        end
      end
    end
  end
end
