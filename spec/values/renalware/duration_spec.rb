module Renalware
  describe Duration, type: :model do
    describe "#new" do
      it "stores the value is seconds" do
        expect(described_class.new(60).seconds).to eq(60)
      end

      it "keeps a nil value" do
        expect(described_class.new(nil).seconds).to be_nil
      end
    end

    describe ".from_string" do
      it "returns a duration in seconds" do
        expect(described_class.from_string("0:10").seconds).to eq(600)
        expect(described_class.from_string("10").seconds).to eq(600)
        expect(described_class.from_string("1:00").seconds).to eq(3600)
      end

      it "keeps a nil value" do
        expect(described_class.from_string("").seconds).to be_nil
      end

      it "drops the seconds if provided" do
        expect(described_class.from_string("0:10:10").seconds).to eq(600)
      end
    end

    describe ".from_minutes" do
      it "returns a duration in seconds" do
        expect(described_class.from_minutes(0).seconds).to eq(0)
        expect(described_class.from_minutes(30).seconds).to eq(1800)
        expect(described_class.from_minutes("30").seconds).to eq(1800)
      end

      it "keeps a nil value" do
        expect(described_class.from_minutes(nil).seconds).to eq(0)
      end

      it "handles invalid string inputs" do
        expect(described_class.from_minutes("").seconds).to eq(0)
        expect(described_class.from_minutes("bla").seconds).to eq(0)
      end
    end

    describe "#to_s" do
      it "returns the duration formatted in hours:minutes" do
        expect(described_class.new(600).to_s).to eq("0:10")
        expect(described_class.new(3600).to_s).to eq("1:00")
        expect(described_class.new(30 * 3600).to_s).to eq("30:00")
      end
    end
  end
end
