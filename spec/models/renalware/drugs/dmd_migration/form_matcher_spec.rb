module Renalware::Drugs
  describe DMDMigration::FormMatcher do
    let(:form) { create(:drug_form, code: "A", name: "Capsule") }
    let(:match) { DMDMatch.create!(drug_name: "Acetazolamide Capsule SR") }

    before do
      form && match
    end

    it "finds a match for the form" do
      described_class.new.call
      expect(match.reload.form_name).to eq "Capsule"
    end
  end
end
