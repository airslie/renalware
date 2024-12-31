module Renalware
  module Drugs::DMD
    module Repositories
      class VirtualTherapeuticMoietyRepository
        attr_reader :client

        Entry = Struct.new(:name, :code, :inactive,
                           keyword_init: true)
        def initialize(client: OntologyClient)
          @client = client.call
        end

        def call
          response = client.get(
            "production1/fhir/ValueSet/$expand", {
              url: "https://dmd.nhs.uk/ValueSet/VTM",
              property: %w(inactive)
            }
          )

          raise(OntologyClient::RequestFailed.new(response: response)) unless response.success?

          response.body["expansion"]["contains"].map do |row|
            Entry.new(
              name: row["display"],
              code: row["code"],
              inactive: ParseHelper.dig_property_out(row["extension"], "inactive") # returns boolean
            )
          end

          # rubocop:disable Layout/LineLength
          # Example response
          # [
          #   { "system" => "https://dmd.nhs.uk", "code" => "9899211000001109", "display" => "Black currant" },
          #   { "system" => "https://dmd.nhs.uk", "code" => "412108007", "display" => "Camphor" },
          # extension: [{
          #   url: "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
          #   extension: [
          #     {
          #       url: "code",
          #       valueCode: "inactive"
          #     },
          #     {
          #       url: "value",
          #       valueBoolean: false
          #     }
          #   ]
          # ]
          # rubocop:enable Layout/LineLength
        end
      end
    end
  end
end
