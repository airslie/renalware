# frozen_string_literal: true

module Renalware::Drugs
  module DMD
    describe APISynchronisers::UnitOfMeasureSynchroniser do
      describe "#call" do
        let(:instance) {
          described_class.new(unit_of_measure_repository: unit_of_measure_repository)
        }

        let(:unit_of_measure_repository) {
          instance_double(Repositories::UnitOfMeasureRepository, call: [])
        }

        context "with no entries" do
          it "does nothing" do
            instance.call

            expect(UnitOfMeasure.count).to eq 0
          end
        end

        context "with an entry" do
          let(:entry) do
            instance_double(
              Repositories::UnitOfMeasureRepository::Entry,
              code: "code",
              name: "name"
            )
          end

          before do
            allow(unit_of_measure_repository).to receive(:call)
              .and_return([entry], [])
          end

          context "when entry with same code doesn't exist" do
            it "inserts it" do
              instance.call

              expect(UnitOfMeasure.count).to eq 1

              item = UnitOfMeasure.first
              expect(item.code).to eq "code"
              expect(item.name).to eq "name"
            end
          end

          context "when entry with same code exists" do
            it "updates it" do
              create(:drug_unit_of_measure,
                     code: "code",
                     name: "Some other name")

              expect(UnitOfMeasure.find_by(code: "code").name).to eq "Some other name"

              instance.call

              expect(UnitOfMeasure.count).to eq 1

              item = UnitOfMeasure.first
              expect(item.code).to eq "code"
              expect(item.name).to eq "name"
            end
          end
        end
      end
    end
  end
end
