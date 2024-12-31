module Renalware
  module Drugs::DMD
    module Repositories
      class FormRepository
        attr_reader :client

        Entry = Struct.new(:name, :code,
                           keyword_init: true)

        def initialize(client: OntologyClient)
          @client = client.call
        end

        def call
          response = client.post(
            "production1/fhir/ValueSet/$expand", {
              resourceType: "Parameters",
              parameter: [
                {
                  name: "valueSet",
                  resource: {
                    resourceType: "ValueSet",
                    compose: {
                      include: [
                        {
                          system: "https://dmd.nhs.uk",
                          filter: [
                            {
                              property: "parent",
                              op: "=",
                              value: "FORM"
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

          # Example response
          # [
          #   { "system" => "https://dmd.nhs.uk", "code" => "10547007", "display" => "Auricular" },
          #   { "system" => "https://dmd.nhs.uk", "code" => "420254004", "display" => "Body cavity"}
          # ]
        end
      end
    end
  end
end
