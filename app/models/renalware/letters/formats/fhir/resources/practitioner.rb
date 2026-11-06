module Renalware
  module Letters
    module Formats::FHIR
      #
      # FHIR Practitioner resource, profiled to CareConnect,  representing the letter author.
      #
      class Resources::Practitioner
        include Support::Construction
        include Support::Helpers

        def call
          {
            fullUrl: arguments.author_urn,
            resource: ::FHIR::STU3::Practitioner.new(
              id: arguments.author_uuid,
              meta: {
                profile: "https://fhir.hl7.org.uk/STU3/StructureDefinition/CareConnect-Practitioner-1"
              },
              # There a couple of options for resolving a user by identifier
              # - GPC number
              # - SDS (Spine Directory Service) number -  we don't have this yet
              # - local
              # identifier: {
              #   system: "https://fhir.hl7.org.uk/Id/hcpc-number",
              #   value: "????" # TODO: GPC number
              # },
              identifier: [ # sds id required even if UNK
                {
                  system: "https://fhir.nhs.uk/Id/sds-user-id",
                  value: "UNK"
                }
                # , system_identifier(arguments.author_uuid)
              ],
              name: {
                use: "official",
                family: author.family_name,
                given: author.given_name,
                prefix: author.professional_position
              }
            )
          }
        end

        private

        def author = arguments.request.author

        # Until we can resolve individual user details via Active/Spine Directory lookup,
        # Just use a globally configured telephone number
        def telephone = Renalware.config.mesh_practitioner_phone
      end
    end
  end
end
