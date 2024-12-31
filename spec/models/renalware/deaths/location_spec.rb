module Renalware
  module Deaths
    describe Location do
      it_behaves_like "a Paranoid model"
      it { is_expected.to validate_presence_of(:name) }

      describe "uniqueness" do
        subject { described_class.new(name: "Other") }

        it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
      end
    end
  end
end
