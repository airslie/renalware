# frozen_string_literal: true

module Renalware
  module Drugs
    describe DMD::Synchronisers::VMPClassificationSynchroniser do
      describe "#call" do
        let(:instance) { described_class.new }

        context "without data" do
          it "does nothing" do
            instance.call

            expect(VMPClassification.count).to eq 0
          end
        end

        context "with data" do
          let(:drug) { create(:drug, code: "DRUG_CODE") }
          let(:form) { create(:drug_form, code: "FORM") }
          let(:unit_of_measure1) { create(:drug_unit_of_measure, code: "STRNT_NMRTR_UOMCD") }
          let(:unit_of_measure2) { create(:drug_unit_of_measure, code: "UDFS_UOMCD") }
          let(:unit_of_measure3) { create(:drug_unit_of_measure, code: "UNIT_DOSE_UOMCD") }
          let(:route) { create(:medication_route, code: "MED_ROUTE") }
          let(:vmp) {
            create(:dmd_virtual_medical_product,
                   code: "VMP_CODE",
                   form_code: "FORM",
                   active_ingredient_strength_numerator_uom_code: "STRNT_NMRTR_UOMCD",
                   unit_dose_form_size_uom_code: "UDFS_UOMCD",
                   unit_dose_uom_code: "UNIT_DOSE_UOMCD",
                   route_code: "MED_ROUTE",
                   virtual_therapeutic_moiety_code: "DRUG_CODE",
                   inactive: true)
          }

          context "with full data available" do
            before do
              form && drug && vmp && unit_of_measure1 &&
                unit_of_measure2 && unit_of_measure3 && route
            end

            context "when classification row doesn't exist" do
              it "inserts it" do
                instance.call

                expect(VMPClassification.count).to eq 1

                row = VMPClassification.first
                expect(row.drug_id).to eq drug.id
                expect(row.form_id).to eq form.id
                expect(row.route_id).to eq route.id
                expect(row.active_ingredient_strength_numerator_uom_id).to eq unit_of_measure1.id
                expect(row.unit_dose_form_size_uom_id).to eq unit_of_measure2.id
                expect(row.unit_dose_uom_id).to eq unit_of_measure3.id
                expect(row.inactive).to be true
              end
            end

            context "when classification row exists" do
              it "updates it" do
                Drugs::VMPClassification.create!(
                  code: "VMP_CODE",
                  drug: drug,
                  inactive: false
                )

                instance.call

                expect(VMPClassification.count).to eq 1

                row = VMPClassification.first
                expect(row.drug_id).to eq drug.id
                expect(row.form_id).to eq form.id
                expect(row.route_id).to eq route.id
                expect(row.active_ingredient_strength_numerator_uom_id).to eq unit_of_measure1.id
                expect(row.unit_dose_form_size_uom_id).to eq unit_of_measure2.id
                expect(row.unit_dose_uom_id).to eq unit_of_measure3.id

                expect(row.inactive).to be true
              end
            end
          end

          context "with multiple trade families for the same vmp" do
            let(:trade_family1) { create(:drug_trade_family, code: "TF_CODE_1") }
            let(:trade_family2) { create(:drug_trade_family, code: "TF_CODE_2") }
            let(:actual_medical_product1) {
              create(:dmd_actual_medical_product, trade_family_code: "TF_CODE_1",
                                                  virtual_medical_product_code: "VMP_CODE")
            }
            let(:actual_medical_product2) {
              create(:dmd_actual_medical_product, trade_family_code: "TF_CODE_2",
                                                  virtual_medical_product_code: "VMP_CODE")
            }

            before do
              drug && vmp
              trade_family1 && trade_family2
              actual_medical_product1 && actual_medical_product2
            end

            it "adds them as an array to the same vmp classification row" do
              instance.call

              expect(VMPClassification.count).to eq 1

              row = VMPClassification.first
              expect(row.trade_family_ids).to eq([trade_family1.id, trade_family2.id])
            end
          end
        end
      end
    end
  end
end
