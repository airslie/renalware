module Renalware
  describe UKRDC::Batch do
    describe "#next" do
      it "creates a new Batch and returns it" do
        batch_number = described_class.next

        expect(batch_number).to be_a(described_class)
        expect(batch_number).to be_persisted
      end
    end

    describe "#number" do
      subject(:number) { described_class.next.number }

      it "returns the row id as in the format 000001" do
        expect(number.length).to eq(6)
        expect(number).to match(/0+\d+/)
      end
    end
  end
end
