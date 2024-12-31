module Renalware
  describe Age, type: :model do # rubocop:disable RSpec/SpecFilePathFormat
    describe "#valid?" do
      context "when born in the last 3 years" do
        subject { described_class.new(amount: 2, unit: :years) }

        it { is_expected.not_to be_valid }
      end

      context "when amount is a string starting with a number" do
        subject { described_class.new(amount: "10s", unit: :years) }

        it { is_expected.to be_valid }
      end

      context "when amount is a string and it is coerced to 0" do
        subject { described_class.new(amount: "s10", unit: :years) }

        it { is_expected.not_to be_valid }
      end
    end

    describe ".new_from" do
      subject { described_class.new_from(**parts) }

      context "when params are blank" do
        let(:parts) { { years: nil, months: nil, days: nil } }

        it { is_expected.to have_attributes(amount: nil, unit: nil) }
      end

      context "when born more that 3 years ago" do
        let(:parts) { { years: 3, months: 1, days: 2 } }

        it { is_expected.to have_attributes(amount: 3, unit: "years") }
      end

      context "when less than 3 years ago" do
        let(:parts) { { years: 2, months: 11, days: 27 } }

        it { is_expected.to have_attributes(amount: 35, unit: "months") }
      end

      context "when values are numeric strings" do
        let(:parts) { { years: "2", months: "11", days: "27" } }

        it { is_expected.to have_attributes(amount: 35, unit: "months") }
      end

      context "when values are non numeric strings" do
        let(:parts) { { years: "s2", months: "s11", days: "s27" } }

        it { is_expected.to have_attributes(amount: 0, unit: "months") }
      end
    end
  end
end
