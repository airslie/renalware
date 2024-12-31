module Renalware
  module Transplants
    describe InvestigationType do
      it_behaves_like "a Paranoid model"

      it :aggregate_failures do
        is_expected.to validate_presence_of(:code)
        is_expected.to validate_presence_of(:description)
      end

      describe "uniqueness" do
        subject { described_class.new(code: "x", description: "y", deleted_at: nil) }

        it { is_expected.to validate_uniqueness_of(:code) }
      end
    end
  end
end
