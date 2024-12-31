module Renalware::Drugs
  describe DMDMigration::IdentifyVtmByTradeFamily do
    let(:dmd_drug) { create(:drug, name: "DMD Drug", code: "ABCD") }
    let(:legacy_drug) { create(:drug, code: nil, name: "Legacy Drug") }
    let(:trade_family) { create(:drug_trade_family, name: "Trade Family Name") }
    let(:vmp_classification) {
      create(
        :drug_vmp_classification,
        drug: dmd_drug,
        trade_family_ids: [trade_family.id]
      )
    }
    let(:match) {
      DMDMatch.create!(
        trade_family_name: "Trade Family Name",
        approved_trade_family_match: true,
        vtm_name: nil,
        approved_vtm_match: false
      )
    }

    before do
      dmd_drug && vmp_classification && match
    end

    context "when trade family is approved in a DMD Match, " \
            "but the vtm is not found" do
      it "then identify the vtm name using a classification" do
        described_class.new.call

        match.reload
        expect(match.vtm_name).to eq "DMD Drug"
        expect(match.approved_vtm_match).to be true
      end
    end

    context "when classification is not found" do
      before do
        vmp_classification.update(trade_family_ids: [0])
      end

      it "does nothing" do
        described_class.new.call

        match.reload
        expect(match.vtm_name).to be_nil
        expect(match.approved_vtm_match).to be false
      end
    end
  end
end
