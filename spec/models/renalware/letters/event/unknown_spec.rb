module Renalware::Letters
  describe Event::Unknown do
    context "with a clinical letter" do
      subject(:event) { described_class.new(nil, clinical: true) }

      describe "#part_classes" do
        it "contains the default clinical part classes" do
          expect(event.part_classes).to eq \
            [
              Part::Problems,
              Part::Prescriptions,
              Part::RecentPathologyResults,
              Part::Allergies
            ]
        end
      end

      it "has a #to_s of Clinical" do
        expect(event.to_s).to eq("Clinical")
      end

      it "is clinical" do
        expect(event).to be_clinical
      end
    end

    context "with a non-clinical letter" do
      subject(:event) { described_class.new(nil) }

      describe "#part_classes" do
        it "is an empty array" do
          expect(event.part_classes).to eq([])
        end
      end

      it "has a #to_s of Simple" do
        expect(event.to_s).to eq("Simple")
      end

      it "is not clinical" do
        expect(event).not_to be_clinical
      end
    end
  end
end
