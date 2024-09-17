# frozen_string_literal: true

module Renalware
  module Drugs::DMD
    describe Repositories::SnomedAmpsWithTradeFamilyRepository do
      describe "#call" do
        let(:instance) {
          described_class.new(client: ontology_client)
        }

        let(:response_body) do
          {
            expansion: {
              contains: [
                {
                  extension: [
                    {
                      url: "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
                      extension: [
                        {
                          url: "code",
                          valueCode: "parent"
                        },
                        {
                          url: "value",
                          valueCode: "324178009"
                        }
                      ]
                    },
                    {
                      url: "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
                      extension: [
                        {
                          url: "code",
                          valueCode: "parent"
                        },
                        {
                          url: "value",
                          valueCode: "10363901000001102"
                        }
                      ]
                    }
                  ],
                  system: "http://snomed.info/sct",
                  code: "89511000001103",
                  display: "Erythromycin 250mg gastro-resistant tablets (Abbott Laboratories Ltd)"
                }
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
          stubs.post("/production1/fhir/ValueSet/$expand") do |_env|
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

          vmp1 = result.first

          expect(vmp1.code).to eq "89511000001103"
          expect(vmp1.name).to eq \
            "Erythromycin 250mg gastro-resistant tablets (Abbott Laboratories Ltd)"
          expect(vmp1.parent_codes).to eq %w(324178009 10363901000001102)
        end
      end
    end
  end
end
