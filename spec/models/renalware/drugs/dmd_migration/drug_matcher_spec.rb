module Renalware::Drugs
  describe DMDMigration::DrugMatcher do
    let(:vtm) {
      create(:dmd_virtual_therapeutic_moiety,
             name: "Some Acetazolamide drug")
    }
    let(:match) { DMDMatch.create!(drug_name: "Acetazolamide Capsule SR") }

    before do
      vtm && match
    end

    it "finds a match for the drug" do
      described_class.new.call
      expect(match.reload.vtm_name).to eq "Some Acetazolamide drug"
    end
  end
end
