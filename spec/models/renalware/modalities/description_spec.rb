module Renalware
  describe Modalities::Description do
    it_behaves_like "a Paranoid model"
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to be_versioned }

    describe "#validation" do
      subject { described_class.new(name: "P") }

      it { is_expected.to validate_uniqueness_of :name }
    end

    describe "#augmented_name_for(patient)" do
      subject(:augmented_name) { described_class.new(name: "XYZ").augmented_name_for(patient) }

      let(:patient) { nil }

      it "defaults to returning the modality name (a subclass may override to change behaviour)" do
        expect(augmented_name).to eq("XYZ")
      end
    end
  end
end
