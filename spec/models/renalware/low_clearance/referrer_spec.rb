module Renalware
  module LowClearance
    describe Referrer do
      it { is_expected.to validate_presence_of(:name) }

      describe "uniqueness" do
        subject { described_class.new(name: "x") }

        it { is_expected.to validate_uniqueness_of(:name) }
      end
    end
  end
end
