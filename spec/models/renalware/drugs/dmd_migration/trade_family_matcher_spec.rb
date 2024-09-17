# frozen_string_literal: true

module Renalware::Drugs
  describe DMDMigration::TradeFamilyMatcher do
    let(:trade_family) {
      create(:drug_trade_family,
             name: "Some Acetazolamide family")
    }
    let(:match) { DMDMatch.create!(drug_name: "Acetazolamide Capsule SR") }

    before do
      trade_family && match
    end

    it "finds a match for the drug" do
      described_class.new.call
      expect(match.reload.trade_family_name).to eq "Some Acetazolamide family"
    end
  end
end
