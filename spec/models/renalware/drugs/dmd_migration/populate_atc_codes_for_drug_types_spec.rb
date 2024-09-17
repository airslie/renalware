# frozen_string_literal: true

module Renalware::Drugs
  describe DMDMigration::PopulateAtcCodesForDrugTypes do
    let(:existing_drug_type) {
      create(
        :drug_type,
        name: "Test",
        position: -1,
        colour: "green",
        code: "controlled"
      )
    }

    before do
      existing_drug_type
    end

    it "populates the missing data in drug types without overriding" do
      expect(Type.count).to eq 1

      described_class.new.call
      expect(Type.count).to eq 14
      expect(Type.pluck(:name)).to contain_exactly(
        "Antibiotics", "Anticoag Antiplatelet", "Antivirl", "Bone / Calcium / Phosphate",
        "Cardiac", "Diabetes", "ESA", "Hypertension", "Immunosuppressant", "Iron", "Laxative",
        "Psychiatric Medication", "Test", "Vaccine"
      )
      drug_type = Type.find_by(code: "controlled")
      expect(drug_type).to have_attributes(
        name: "Test",
        position: -1,
        colour: "green",
        atc_codes: ["N02A"] # this is new
      )
    end
  end
end
