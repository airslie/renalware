module Relay
  module GPConnect
    module FHIR
      #
      # FHIR resource representing binary PDF letter payload
      #
      class Resources::Binary
        include Support::Construction
        include Support::Helpers

        PROFILE = "https://fhir.nhs.uk/STU3/StructureDefinition/ITK-Attachment-Binary-1".freeze

        def call
          {
            fullUrl: arguments.binary_urn,
            resource: ::FHIR::STU3::Binary.new(
              meta: {
                profile: PROFILE
              },
              id: arguments.binary_uuid,
              contentType: "application/pdf",
              content: [arguments.pdf_content].pack("m0") # Base64 strict encoding
            )
          }
        end
      end
    end
  end
end
