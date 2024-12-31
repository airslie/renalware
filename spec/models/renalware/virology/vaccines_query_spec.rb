module Renalware
  describe Virology::VaccinesQuery do
    include DrugsSpecHelper

    let(:vaccine_drug_type) { create(:drug_type, code: :vaccine, name: "Vaccine") }
    let(:other_drug_type) { create(:drug_type, code: :other, name: "Other") }

    def create_drug(name:, type:, atc_code: [])
      drug = create(:drug, name: name, code: name)
      create(:dmd_virtual_medical_product,
             atc_code: atc_code,
             virtual_therapeutic_moiety_code: name)
      drug.drug_types << type
      drug
    end

    context "when vaccination_type has no atc_codes" do
      it "returns all vaccines" do
        vaccine_drug = create_drug(name: "Drug1", type: vaccine_drug_type, atc_code: ["ABC"])
        _other_drug = create_drug(name: "Drug2", type: other_drug_type, atc_code: ["ABC"])
        vaccination_type = create(:vaccination_type, atc_codes: [])
        refresh_prescribable_drugs_materialized_view

        expect(
          described_class.new(vaccination_type: vaccination_type).call.pluck(:drug_id)
        ).to eq([vaccine_drug.id])
      end
    end

    context "when vaccination_type has an atc_code" do
      it "returns matching vaccines" do
        abc_drug = create_drug(name: "Drug1", type: vaccine_drug_type, atc_code: "ABC111")
        _xyz_drug = create_drug(name: "Drug2", type: vaccine_drug_type, atc_code: "XYZ111")
        vaccination_type = create(:vaccination_type, atc_codes: "{ABC%}")
        refresh_prescribable_drugs_materialized_view

        expect(
          described_class.new(vaccination_type: vaccination_type).call.pluck(:drug_id)
        ).to eq([abc_drug.id])
      end
    end

    context "when vaccination_type has >1 atc_code" do
      it "returns matching vaccines" do
        abc_drug = create_drug(name: "ABC", type: vaccine_drug_type, atc_code: "ABC111")
        xyz_drug = create_drug(name: "XYZ", type: vaccine_drug_type, atc_code: "XYZ111")
        _other_drug = create_drug(name: "Other", type: vaccine_drug_type, atc_code: "OTHER")
        vaccination_type = create(:vaccination_type, atc_codes: "{ABC%,XYZ%}")
        refresh_prescribable_drugs_materialized_view

        expect(
          described_class.new(vaccination_type: vaccination_type).call.pluck(:drug_id)
        ).to eq([abc_drug.id, xyz_drug.id])
      end
    end
  end
end
