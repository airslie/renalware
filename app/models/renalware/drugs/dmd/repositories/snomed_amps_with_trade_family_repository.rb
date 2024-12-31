module Renalware
  module Drugs::DMD
    module Repositories
      class SnomedAmpsWithTradeFamilyRepository
        attr_reader :client

        PARENT = "parent".freeze

        Entry = Struct.new(:name, :code, :parent_codes,
                           keyword_init: true)

        def initialize(client: OntologyClient)
          @client = client.call
        end

        def call(count: 2, offset: 0) # rubocop:disable Metrics/MethodLength
          response = client.post(
            "production1/fhir/ValueSet/$expand",
            {
              resourceType: "Parameters",
              parameter: [
                {
                  name: "count",
                  valueInteger: count
                },
                {
                  name: "offset",
                  valueInteger: offset
                },
                {
                  name: "property",
                  valueString: "parent"
                },
                {
                  name: "valueSet",
                  resource: {
                    resourceType: "ValueSet",
                    compose: {
                      include: [
                        {
                          system: "http://snomed.info/sct",
                          filter: [
                            {
                              property: "constraint",
                              op: "=",
                              value: "<! 10363901000001102|Actual medicinal product|"
                            }
                          ]
                        }
                      ]
                    }
                  }
                }
              ]
            }.to_json
          )

          raise(OntologyClient::RequestFailed.new(response: response)) unless response.success?

          return [] if response.body["expansion"]["total"] == 0
          return [] if response.body.dig("expansion", "contains").blank?

          response.body["expansion"]["contains"].filter_map do |row|
            next if row["extension"].blank?

            Entry.new(
              name: row["display"],
              code: row["code"],
              parent_codes: dig_parents_out(row["extension"])
            )
          end
        end

        private

        def dig_parents_out(node)
          node.select { |el|
            next if el["extension"].blank?

            el["extension"][0]["valueCode"] == PARENT
          }.compact.map { |property|
            property["extension"][1]["valueCode"]
          }
        end

        # Example response
        # [
        #   {
        #       "extension": [
        #           {
        #               "url": "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #               "extension": [
        #                   {
        #                       "url": "code",
        #                       "valueCode": "parent"
        #                   },
        #                   {
        #                       "url": "value",
        #                       "valueCode": "319223009"
        #                   }
        #               ]
        #           },
        #           {
        #               "url": "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #               "extension": [
        #                   {
        #                       "url": "code",
        #                       "valueCode": "parent"
        #                   },
        #                   {
        #                       "url": "value",
        #                       "valueCode": "9197101000001103"
        #                   }
        #               ]
        #           },
        #           {
        #               "url": "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #               "extension": [
        #                   {
        #                       "url": "code",
        #                       "valueCode": "parent"
        #                   },
        #                   {
        #                       "url": "value",
        #                       "valueCode": "10363901000001102"
        #                   }
        #               ]
        #           }
        #       ],
        #       "system": "http://snomed.info/sct",
        #       "code": "17573711000001101",
        #       "display": "Adalat 10mg capsules (Necessity Supplies Ltd)"
        #   }
        # ]
      end
    end
  end
end
