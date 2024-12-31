describe WeekPeriod do
  describe "#new" do
    it "raises an error if the week/year combination is not valid" do
      expect { described_class.new(week_number: 54, year: 2017) }.to raise_error(ArgumentError)
    end

    it "raises an error if the week is 0" do
      expect { described_class.new(week_number: 0, year: 2017) }.to raise_error(ArgumentError)
    end

    it "raises an error if the week is nil" do
      expect { described_class.new(year: 2017) }.to raise_error(ArgumentError)
    end

    it "raises an error if the year is 0" do
      expect { described_class.new(week_number: 51, year: 0) }.to raise_error(ArgumentError)
    end

    it "raises an error if the year is nil" do
      expect { described_class.new(week_number: 51) }.to raise_error(ArgumentError)
    end

    it "coerces a year string into an integer" do
      period = described_class.new(week_number: 51, year: "2017")
      expect(period.year).to be_a(Integer)
      expect(period.year).to eq(2017)
    end
  end

  describe "#next" do
    it "returns a WeekPeriod staring the following Monday" do
      week_period = described_class.new(week_number: 1, year: 2017)
      next_week = week_period.next
      expect(next_week.week_number).to eq(2)
      expect(next_week.year).to eq(2017)
    end

    it "returns a WeekPeriod staring the following Monday across years" do
      week_period = described_class.new(week_number: 52, year: 2017)
      next_week = week_period.next
      expect(next_week.week_number).to eq(1)
      expect(next_week.year).to eq(2018)
    end
  end

  describe "#previous" do
    it "returns a WeekPeriod staring the previous Monday" do
      week_period = described_class.new(week_number: 12, year: 2017)
      expect(week_period.previous.to_a).to eq([11, 2017])
    end

    it "returns a WeekPeriod staring the previous Monday across years" do
      week_period = described_class.new(week_number: 1, year: 2017)
      expect(week_period.previous.to_a).to eq([52, 2016])
    end
  end
end
