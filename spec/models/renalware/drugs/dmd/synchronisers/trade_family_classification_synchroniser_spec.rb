# frozen_string_literal: true

module Renalware
  module Drugs
    describe DMD::Synchronisers::TradeFamilyClassificationSynchroniser do
      describe "#call" do
        let(:instance) { described_class.new }

        context "without data" do
          it "does nothing" do
            instance.call

            expect(TradeFamilyClassification.count).to eq 0
          end
        end

        context "with data" do
          let(:trade_family) { create(:drug_trade_family, code: "FAMILY") }
          let(:drug) { create(:drug, code: "VTM_CODE") }
          let(:vmp) {
            create(:dmd_virtual_medical_product,
                   code: "VMP_CODE",
                   virtual_therapeutic_moiety_code: "VTM_CODE")
          }
          let(:amp) {
            create(:dmd_actual_medical_product,
                   trade_family_code: "FAMILY",
                   virtual_medical_product_code: "VMP_CODE")
          }

          before do
            trade_family && drug && vmp && amp
          end

          context "when classification row doesn't exist" do
            it "inserts it" do
              instance.call

              expect(TradeFamilyClassification.count).to eq 1

              row = TradeFamilyClassification.first
              expect(row.drug_id).to eq drug.id
              expect(row.trade_family_id).to eq trade_family.id
            end
          end

          context "when classification row exists" do
            it "updates it" do
              Drugs::TradeFamilyClassification.create! \
                drug: drug,
                trade_family: trade_family

              instance.call

              expect(TradeFamilyClassification.count).to eq 1

              row = TradeFamilyClassification.first
              expect(row.drug_id).to eq drug.id
              expect(row.trade_family_id).to eq trade_family.id
            end
          end
        end
      end
    end
  end
end
