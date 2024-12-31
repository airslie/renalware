module Renalware
  describe AgeCalculator do
    describe "#compute" do
      it "returns a hash for the year, month and day" do
        result = described_class.new.compute(Date.parse("1973/10/10"), Date.parse("2015/11/20"))

        expect(result).to eq(years: 42, months: 1, days: 10)
      end

      it "handles a leap year" do
        result = described_class.new.compute(Date.parse("1973/10/10"), Date.parse("2016/02/29"))

        expect(result).to eq(years: 42, months: 4, days: 19)
      end

      it "handles crossing over months" do
        result = described_class.new.compute(Date.parse("1973/09/24"), Date.parse("1973/10/10"))

        expect(result).to eq(years: 0, months: 0, days: 16)
      end
    end
  end
end
