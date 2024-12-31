module Renalware
  module Drugs::DMD
    describe Repositories::VirtualTherapeuticMoietyRepository do
      describe "#call" do
        let(:instance) {
          described_class.new(client: ontology_client)
        }

        let(:response_body) do
          {
            expansion: {
              contains: [
                code: "code",
                display: "display",
                extension: [{
                  url: "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
                  extension: [
                    {
                      url: "code",
                      valueCode: "inactive"
                    },
                    {
                      url: "value",
                      valueBoolean: false
                    }
                  ]
                }]
              ]
            }
          }.deep_stringify_keys
        end

        let(:stubs) { Faraday::Adapter::Test::Stubs.new }
        let(:ontology_client) {
          class_double \
            OntologyClient,
            call: Faraday.new { |b| b.adapter(:test, stubs) }
        }

        before do
          stubs.get("/production1/fhir/ValueSet/$expand?url=https%3A%2F%2Fdmd.nhs.uk%2FValueSet%2FVTM") do |_env| # rubocop:disable Layout/LineLength
            [
              200,
              { "Content-Type": "application/javascript" },
              response_body
            ]
          end
        end

        it "returns friendly data" do
          result = instance.call

          expect(result.size).to eq 1

          expect(result.first.code).to eq "code"
          expect(result.first.name).to eq "display"
          expect(result.first.inactive).to be false
        end
      end
    end
  end
end
