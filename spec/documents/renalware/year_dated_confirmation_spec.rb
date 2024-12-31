module Renalware
  describe YearDatedConfirmation, type: :model do
    let(:year_dated_confirmation) {
      described_class.new(status: "yes", confirmed_on_year: 2015)
    }

    describe "#to_s" do
      subject { year_dated_confirmation.to_s }

      context "with a completed confirmation" do
        it { is_expected.to eq("Yes (2015)") }
      end

      context "when the year is missing" do
        before { year_dated_confirmation.confirmed_on_year = nil }

        it { is_expected.to eq("Yes") }
      end

      context "when the status is missing" do
        before { year_dated_confirmation.status = nil }

        it { is_expected.to eq("(2015)") }
      end
    end
  end
end
