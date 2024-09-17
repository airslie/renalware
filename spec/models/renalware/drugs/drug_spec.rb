# frozen_string_literal: true

module Renalware::Drugs
  describe Drug do
    subject(:drug) { build(:drug) }

    it :aggregate_failures do
      is_expected.to have_many(:drug_type_classifications)
      is_expected.to have_many(:drug_types).through(:drug_type_classifications)
      is_expected.to be_versioned
    end

    it_behaves_like "a Paranoid model"

    describe "destroy" do
      it "soft deletes the drug" do
        drug.save!
        expect { drug.destroy! }.to change(described_class, :count).by(-1)
        soft_deleted = described_class.with_deleted.find(drug.id)
        expect(soft_deleted).to eq(drug)
        expect(soft_deleted.deleted_at).not_to be_nil
      end
    end

    describe "assigning drug types to a drug" do
      it "can be assigned many unique drug types" do
        @antibiotic = create(:drug_type, code: "antibiotic", name: "Antibiotic")
        @esa = create(:drug_type, code: "esa", name: "ESA")

        drug.drug_types << @antibiotic
        drug.drug_types << @esa

        drug.save!
        drug.reload

        expect(drug.drug_types.size).to eq(2)

        expect(drug).to be_valid
      end
    end
  end
end
