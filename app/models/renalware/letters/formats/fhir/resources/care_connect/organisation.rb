module Renalware
  module Letters
    module Formats::FHIR
      # FHIR resource representing a Renalware site/hospital, profiled to CareConnect-Organization-1
      class Resources::CareConnect::Organisation
        include Support::Construction
        include Support::Helpers

        PROFILE = "https://fhir.hl7.org.uk/STU3/StructureDefinition/CareConnect-Organization-1".freeze

        def call
          {
            fullUrl: arguments.organisation_urn,
            resource: ::FHIR::STU3::Organization.new(
              id: arguments.organisation_uuid,
              meta: {
                profile: PROFILE
              },
              identifier: {
                system: "https://fhir.nhs.uk/Id/ods-organization-code",
                value: arguments.organisation_ods_code
              },
              name: name,
              telecom: telecoms
            )
          }
        end

        private

        def phone         = Renalware.config.mesh_organisation_phone
        def email         = Renalware.config.mesh_organisation_email
        def name          = Renalware.config.mesh_organisation_name
        def telecom_phone = contact_point("phone", phone)
        def telecom_email = email.presence && contact_point("email", email)
        def telecoms      = [telecom_phone, telecom_email].compact

        def contact_point(system, value, use = "work")
          ::FHIR::STU3::ContactPoint.new(system: system, value: value, use: use)
        end
      end
    end
  end
end
