# frozen_string_literal: true

module Renalware
  module Drugs::DMD
    describe Repositories::UnitOfMeasureRepository do
      describe "#call" do
        let(:instance) {
          described_class.new(client: ontology_client)
        }

        let(:response_body) do
          {
            expansion: {
              contains: [
                code: "code",
                display: "display"
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

          expect(result.first.code).to eq "code"
          expect(result.first.name).to eq "display"
        end
      end
    end
  end
end
