module Renalware::Drugs
  describe DrugColourPresenter do
    describe "#css_class" do
      let(:instance) { described_class.new }
      let(:drug) { create(:drug, drug_types: drug_types, code: code) }
      let(:drug_types) { [] }
      let(:code) { "dmd code" }

      subject { instance.css_class(drug) }

      context "when drug has no drug types and is a dm+d drug" do
        it { is_expected.to be_blank }
      end

      context "when drug has no drug types and is not a dm+d drug" do
        let(:code) { "" }

        it { is_expected.to eq("bg-green-50 hover:bg-green-100") }
      end

      context "when drug types are set for a drug with a dmd code" do
        let(:drug_type_1) { create(:drug_type, name: "a", code: "a", weighting: 1, colour: "blue") }
        let(:drug_type_2) { create(:drug_type, name: "b", code: "b", weighting: 20, colour: "red") }
        let(:drug_type_3) { create(:drug_type, name: "c", code: "c", weighting: 6, colour: "pink") }
        let(:drug_types) { [drug_type_1, drug_type_2, drug_type_3] }

        it { is_expected.to eq "bg-red-100 hover:bg-red-200" }
      end
    end
  end
end
