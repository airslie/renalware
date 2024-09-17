# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR
      class Resources::ITK::Organisation
        include Support::Construction
        include Support::Helpers

        PROFILE_URL = "https://fhir.nhs.uk/STU3/StructureDefinition/CareConnect-ITK-Header-Organization-1"

        def call
          {
            fullUrl: arguments.itk_organisation_urn,
            resource: FHIR::STU3::Organization.new(
              id: arguments.itk_organisation_uuid,
              meta: {
                profile: PROFILE_URL
              },
              identifier: {
                system: "https://fhir.nhs.uk/Id/ods-organization-code",
                value: arguments.organisation_ods_code
              }
            )
          }
        end
      end
    end
  end
end
