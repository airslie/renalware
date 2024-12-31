module Renalware
  module Drugs::DMD
    module Repositories
      class TradeFamilyRepository
        attr_reader :client

        Entry = Struct.new(:name, :code,
                           keyword_init: true)
        def initialize(client: OntologyClient)
          @client = client.call
        end

        def call
          response = client.post(
            "production1/fhir/ValueSet/$expand",
            {
              resourceType: "Parameters",

              parameter: [
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
                              value: "<! 9191801000001103|Trade family|"
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

          response.body["expansion"]["contains"].map do |row|
            Entry.new(
              name: row["display"],
              code: row["code"]
            )
          end
        end

        # Example response
        # [
        #   {
        # "contains": [
        #   {
        #       "system": "http://snomed.info/sct",
        #       "code": "9519201000001107",
        #       "display": "Intralgin"
        #   }
        # ]
      end
    end
  end
end
