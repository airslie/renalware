# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR
      #
      # FHIR resource representing binary PDF letter payload
      #
      class Resources::Binary
        include Support::Construction
        include Support::Helpers

        PROFILE = "https://fhir.nhs.uk/STU3/StructureDefinition/ITK-Attachment-Binary-1"

        def call
          {
            fullUrl: arguments.binary_urn,
            resource: FHIR::STU3::Binary.new(
              meta: {
                profile: PROFILE
              },
              id: arguments.binary_uuid,
              contentType: "application/pdf",
              content: Base64.encode64(arguments.pdf_content)
            )
          }
        end
      end
    end
  end
end
