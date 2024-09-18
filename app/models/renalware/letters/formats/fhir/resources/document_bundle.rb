# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR
      class Resources::DocumentBundle
        include Support::Construction
        include Support::Helpers

        PROFILE_URL = "https://fhir.nhs.uk/STU3/StructureDefinition/ITK-Document-Bundle-1"

        # Testing notes
        # - No CV?
        # - Letter not approved? - should abort?

        # Note that in the Composition, eg allergies sections will include a urn entry.reference to
        # the Allergy List (the first element in the array returned by
        # Factories::Allergies.call(arguments) so in order to inject urn reference into the letter
        # section, we need to assign it to the Argument object so it ca be passed around/down.
        # Its starting to feel like there might be a change eg
        # 1. Fetch and parse all data so urns can be resolved
        # 2. Use builder pattern to build the Arguments, setting each urn all the Arguments obj
        # 3. Build the xml, passing in the arguments
        #
        def call
          {
            fullUrl: arguments.letter_urn,
            resource: ::FHIR::STU3::Bundle.new(
              type: "document",
              id: arguments.transmission_uuid,
              meta: {
                lastUpdated: letter.updated_at.to_datetime, # Or message.created_at?
                profile: PROFILE_URL
              },
              identifier: system_identifier(arguments.transmission_uuid),
              entry: Array(entries)
            )
          }
        end

        # See TransferOfCare::DocumentBundle or GPConnect::DocumentBundle
        def entries
          raise NotImplementedError, "subclass must implement"
        end
      end
    end
  end
end
