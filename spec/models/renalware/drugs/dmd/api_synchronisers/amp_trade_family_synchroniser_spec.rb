# frozen_string_literal: true

module Renalware
  module Drugs::DMD
    describe APISynchronisers::AmpTradeFamilySynchroniser do
      describe "#call" do
        let(:instance) {
          described_class.new(snomed_amps_repository: snomed_amps_repository)
        }

        let(:snomed_amps_repository) {
          instance_double(Repositories::SnomedAmpsWithTradeFamilyRepository, call: [])
        }

        context "with no entries" do
          it "does nothing" do
            instance.call

            expect(ActualMedicalProduct.count).to eq 0
          end
        end

        context "with an entry" do
          let(:entry) do
            instance_double(
              Repositories::SnomedAmpsWithTradeFamilyRepository::Entry,
              code: "code",
              name: "name",
              parent_codes: %w(1234 5678)
            )
          end

          before do
            create(:dmd_actual_medical_product,
                   code: "code",
                   trade_family_code: nil,
                   name: "name")

            allow(snomed_amps_repository).to receive(:call)
              .and_return([entry], [])
          end

          context "when trade family is not found" do
            it "does nothing" do
              instance.call

              expect(ActualMedicalProduct.count).to eq 1

              item = ActualMedicalProduct.first
              expect(item.code).to eq "code"
              expect(item.name).to eq "name"
              expect(item.trade_family_code).to be_nil
            end
          end

          context "when a trade family matches is found" do
            let(:trade_family) {
              create(:drug_trade_family, name: "Family", code: "5678")
            }

            before do
              trade_family
            end

            it "updates the trade family" do
              instance.call

              expect(ActualMedicalProduct.count).to eq 1

              item = ActualMedicalProduct.first
              expect(item.code).to eq "code"
              expect(item.name).to eq "name"
              expect(item.trade_family_code).to eq "5678"
            end
          end
        end
      end
    end
  end
end
