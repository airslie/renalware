module Renalware
  module Letters
    describe SnomedDocumentType do
      it :aggregate_failures do
        is_expected.to validate_presence_of(:title)
        is_expected.to validate_presence_of(:code)
      end

      describe "uniqueness" do
        subject { described_class.new(title: "X", code: "Y") }

        it { is_expected.to validate_uniqueness_of(:title) }
        it { is_expected.to validate_uniqueness_of(:code) }
      end
    end
  end
end
