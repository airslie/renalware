module Renalware
  describe BloodPressure do
    describe "#blank?" do
      it "returns true if systolic and diastolic are blank" do
        expect(described_class.new.blank?).to be(true)
      end

      it "returns false if systolic or diastolic are not blank" do
        expect(described_class.new(systolic: 123).blank?).to be(false)
      end
    end
  end
end
