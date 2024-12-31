module Renalware
  module Drugs::DMD
    module Repositories
      class ActualMedicalProductRepository
        attr_reader :client

        AMP = "AMP".freeze

        Entry = Struct.new(:name, :code,
                           :virtual_medical_product_code,
                           keyword_init: true)

        def initialize(client: OntologyClient)
          @client = client.call
        end

        def call(count: 2, offset: 0)
          response = client.get(
            "production1/fhir/ValueSet/$expand", {
              url: "https://dmd.nhs.uk/ValueSet/AMP",
              property: %w(parent),
              count: count,
              offset: offset
            }
          )
          raise(OntologyClient::RequestFailed.new(response: response)) unless response.success?

          return [] if response.body["expansion"]["total"] == 0
          return [] if response.body.dig("expansion", "contains").blank?

          response.body["expansion"]["contains"].filter_map do |row|
            next if row["extension"].blank?

            Entry.new(
              name: row["display"],
              code: row["code"],
              virtual_medical_product_code: ParseHelper.dig_property_out(
                row["extension"], "parent", excluded_values: [AMP]
              )
            )
          end
        end

        # Example response
        #   [
        #     {
        #         "extension": [
        #             {
        #                 "url": "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #                 "extension": [
        #                     {
        #                         "url": "code",
        #                         "valueCode": "parent"
        #                     },
        #                     {
        #                         "url": "value",
        #                         "valueCode": "AMP"
        #                     }
        #                 ]
        #             },
        #             {
        #                 "url": "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #                 "extension": [
        #                     {
        #                         "url": "code",
        #                         "valueCode": "parent"
        #                     },
        #                     {
        #                         "url": "value",
        #                         "valueCode": "322236009"
        #                     }
        #                 ]
        #             }
        #         ],
        #         "system": "https://dmd.nhs.uk",
        #         "code": "115711000001103",
        #         "display": "Paracetamol 500mg tablets (Vantage)"
        #     },
        #     {
        #         "extension": [
        #             {
        #                 "url": "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #                 "extension": [
        #                     {
        #                         "url": "code",
        #                         "valueCode": "parent"
        #                     },
        #                     {
        #                         "url": "value",
        #                         "valueCode": "AMP"
        #                     }
        #                 ]
        #             },
        #             {
        #                 "url": "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #                 "extension": [
        #                     {
        #                         "url": "code",
        #                         "valueCode": "parent"
        #                     },
        #                     {
        #                         "url": "value",
        #                         "valueCode": "322236009"
        #                     }
        #                 ]
        #             }
        #         ],
        #         "system": "https://dmd.nhs.uk",
        #         "code": "36019811000001100",
        #         "display": "Paracetamol 500mg tablets (Medreich Plc)"
        #     }
        # ]
      end
    end
  end
end
