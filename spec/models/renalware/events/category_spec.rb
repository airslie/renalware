module Renalware::Events
  describe Category do
    it_behaves_like "a Paranoid model"
    it { is_expected.to have_many(:types) }

    describe "validation" do
      subject(:category) { described_class.new(name: "X") }

      it { is_expected.to validate_presence_of :name }

      describe "uniqueness" do
        it { is_expected.to validate_uniqueness_of :name }
      end

      describe "#to_s" do
        it "delegates to name" do
          expect(category.to_s).to eq("X")
        end
      end
    end
  end
end
