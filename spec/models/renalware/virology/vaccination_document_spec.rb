# frozen_string_literal: true

module Renalware
  describe Virology::Vaccination::Document do
    it { is_expected.to validate_presence_of(:type) }

    describe "#type_name" do
      it "resolves the vaccination type name using a database lookup" do
        create(:vaccination_type, code: "a", name: "A")

        doc = described_class.new(type: "a")
        expect(doc.type_name).to eq "A"
      end
    end

    describe "#to_s" do
      it "concatenates type name and drug if present" do
        create(:vaccination_type, code: "a", name: "Type1")
        doc = described_class.new(type: "a", drug: "Drug1")

        expect(doc.to_s).to eq "Type1 - Drug1"
      end

      it "returns type if drug not present" do
        create(:vaccination_type, code: "a", name: "Type1")
        doc = described_class.new(type: "a", drug: "")

        expect(doc.to_s).to eq "Type1"
      end
    end
  end
end
