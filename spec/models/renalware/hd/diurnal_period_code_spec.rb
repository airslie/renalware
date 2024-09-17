# frozen_string_literal: true

module Renalware::HD
  describe DiurnalPeriodCode do
    it { is_expected.to validate_presence_of(:code) }

    describe "#code uniqueness" do
      subject { described_class.new(code: "AM") }

      it { is_expected.to validate_uniqueness_of(:code) }
    end
  end
end
