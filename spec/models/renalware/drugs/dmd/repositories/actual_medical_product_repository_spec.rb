# frozen_string_literal: true

module Renalware
  module Drugs::DMD
    describe Repositories::ActualMedicalProductRepository do
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
                          valueCode: "AMP"
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
                          valueCode: "322236009"
                        }
                      ]
                    }
                  ],
                  system: "https://dmd.nhs.uk",
                  code: "115711000001103",
                  display: "Paracetamol 500mg tablets (Vantage)"
                },
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
                          valueCode: "AMP"
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
                          valueCode: "322236009"
                        }
                      ]
                    }
                  ],
                  system: "https://dmd.nhs.uk",
                  code: "36019811000001100",
                  display: "Paracetamol 500mg tablets (Medreich Plc)"
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
          stubs.get("/production1/fhir/ValueSet/$expand") do |_env|
            [
              200,
              { "Content-Type": "application/javascript" },
              response_body
            ]
          end
        end

        it "returns friendly data" do
          result = instance.call

          expect(result.size).to eq 2

          vmp1 = result.first
          expect(vmp1).to have_attributes \
            code: "115711000001103",
            name: "Paracetamol 500mg tablets (Vantage)",
            virtual_medical_product_code: "322236009"

          vmp2 = result.second
          expect(vmp2).to have_attributes \
            code: "36019811000001100",
            name: "Paracetamol 500mg tablets (Medreich Plc)",
            virtual_medical_product_code: "322236009"
        end
      end
    end
  end
end
