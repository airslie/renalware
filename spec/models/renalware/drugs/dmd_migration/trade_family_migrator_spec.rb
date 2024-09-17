# frozen_string_literal: true

module Renalware::Drugs
  describe DMDMigration::TradeFamilyMigrator do
    let(:trade_family) { create(:drug_trade_family, name: "Adalat") }
    let(:drug) { create(:drug) }
    let(:prescription) { create(:prescription, drug: drug) }
    let(:match) {
      DMDMatch.create!(drug: drug, trade_family_name: "Adalat", approved_trade_family_match: true)
    }

    before do
      trade_family && prescription && match
    end

    context "when a trade_family_name exists in the match table" do
      it "populates the newly added `trade_family_id` based on a match from the match table" do
        described_class.new.call
        expect(prescription.reload.trade_family_id).to eq trade_family.id

        # Re-run -> shouldn't change anything or report an error
        described_class.new.call
        expect(prescription.reload.trade_family_id).to eq trade_family.id

        # Won't update if approved_vtm_match flag is false
        match.update_column(:approved_trade_family_match, false)
        prescription.update_column(:trade_family_id, nil)

        described_class.new.call
        expect(prescription.reload.trade_family_id).to be_nil

        # Won't update if trade family name is not found
        match.update(
          approved_trade_family_match: true,
          trade_family_name: "Non-matching Trade Family"
        )

        described_class.new.call
        expect(prescription.reload.trade_family_id).to be_nil
      end
    end
  end
end
