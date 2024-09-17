# frozen_string_literal: true

module Renalware::Drugs
  describe DMDMigration::DrugMigrator do
    let(:dmd_drug) { create(:drug, name: "DMD Drug", code: "ABCD") }
    let(:legacy_drug) { create(:drug, code: nil) }
    let(:drug_no_match) { create(:drug, code: nil) }
    let(:prescription) { create(:prescription, drug: legacy_drug) }
    let(:prescription_without_a_match) { create(:prescription, drug: drug_no_match) }
    let(:match) {
      DMDMatch.create!(drug: legacy_drug, vtm_name: "DMD Drug", approved_vtm_match: true)
    }

    before do
      prescription && dmd_drug && prescription_without_a_match && match
    end

    context "when a vmt_drug_name exists in the match table" do
      it "replaces the old drug with the DMD matched drug" do
        described_class.new.call
        expect(prescription.reload.drug_id).to eq dmd_drug.id
        expect(prescription_without_a_match.reload.drug_id).to eq drug_no_match.id

        # Re-run -> shouldn't change anything or report an error
        described_class.new.call
        prescription.reload
        expect(prescription.drug_id).to eq dmd_drug.id
        expect(prescription.legacy_drug_id).to eq legacy_drug.id

        # Won't update if approved_vtm_match flag is false
        match.update_column(:approved_vtm_match, false)
        prescription.update_column(:drug_id, legacy_drug.id)

        described_class.new.call
        expect(prescription.reload.drug_id).to eq legacy_drug.id

        # Won't update if drug name is not found
        match.update(approved_vtm_match: true, vtm_name: "Non-matching DMD Drug name")

        described_class.new.call
        expect(prescription.reload.drug_id).to eq legacy_drug.id
      end
    end
  end
end
