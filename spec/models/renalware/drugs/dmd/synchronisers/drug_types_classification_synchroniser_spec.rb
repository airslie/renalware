module Renalware
  module Drugs
    describe DMD::Synchronisers::DrugTypesClassificationSynchroniser do
      describe "#call" do
        let(:instance) { described_class.new }

        context "without data" do
          it "does nothing" do
            instance.call

            expect(DrugTypeClassification.count).to eq 0
          end
        end

        context "with data" do
          let(:drug_type) { create(:drug_type, atc_codes: ["C0"]) }
          let(:drug) { create(:drug, code: "DRUG_CODE") }
          let(:vmp) {
            create(:dmd_virtual_medical_product,
                   atc_code: "C01BD01",
                   virtual_therapeutic_moiety_code: "DRUG_CODE")
          }

          before do
            drug_type && drug && vmp
          end

          context "when classification row doesn't exist" do
            it "inserts it" do
              instance.call

              expect(DrugTypeClassification.count).to eq 1

              row = DrugTypeClassification.first
              expect(row.drug_id).to eq drug.id
              expect(row.drug_type_id).to eq drug_type.id
            end
          end

          context "when classification row exists" do
            it "updates it" do
              Drugs::DrugTypeClassification.create! \
                drug: drug,
                drug_type: drug_type

              instance.call

              expect(DrugTypeClassification.count).to eq 1

              row = DrugTypeClassification.first
              expect(row.drug_id).to eq drug.id
              expect(row.drug_type_id).to eq drug_type.id
            end
          end

          context "with matches on more than one drug type" do
            let(:drug_type_2) do
              create(:drug_type,
                     code: "another code",
                     atc_codes: ["C01B"],
                     name: "Another name")
            end

            before do
              drug_type_2
            end

            it "creates all matches" do
              instance.call

              expect(DrugTypeClassification.count).to eq 2

              row = DrugTypeClassification.first
              expect(row.drug_id).to eq drug.id
              expect(row.drug_type_id).to eq drug_type.id

              row = DrugTypeClassification.second
              expect(row.drug_id).to eq drug.id
              expect(row.drug_type_id).to eq drug_type_2.id
            end
          end

          context "with matches on more than one VMP, but same Drug" do
            let(:drug_type) { create(:drug_type, atc_codes: %w(C0 B123)) }
            let(:vmp_2) {
              create(:dmd_virtual_medical_product,
                     atc_code: "B123456",
                     virtual_therapeutic_moiety_code: "DRUG_CODE")
            }

            before do
              vmp_2
            end

            it "creates all matches" do
              instance.call

              expect(DrugTypeClassification.count).to eq 1

              row = DrugTypeClassification.first
              expect(row.drug_id).to eq drug.id
              expect(row.drug_type_id).to eq drug_type.id
            end
          end

          context "with matches on more than one VMP and Drug" do
            let(:drug_type) { create(:drug_type, atc_codes: %w(C0 B123)) }
            let(:drug_2) { create(:drug, code: "ANOTHER_DRUG_CODE") }
            let(:vmp_2) {
              create(:dmd_virtual_medical_product,
                     atc_code: "B123456",
                     virtual_therapeutic_moiety_code: "ANOTHER_DRUG_CODE")
            }

            before do
              drug_2 && vmp_2
            end

            it "creates all matches" do
              instance.call

              expect(DrugTypeClassification.count).to eq 2

              row = DrugTypeClassification.first
              expect(row.drug_id).to eq drug.id
              expect(row.drug_type_id).to eq drug_type.id

              row = DrugTypeClassification.second
              expect(row.drug_id).to eq drug_2.id
              expect(row.drug_type_id).to eq drug_type.id
            end
          end
        end
      end
    end
  end
end
