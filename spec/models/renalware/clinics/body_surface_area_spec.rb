describe Renalware::Clinics::BodySurfaceArea do
  describe "#calculate" do
    context "when no weight supplied" do
      it "returns nil" do
        result = described_class.new(weight: nil, height: 1.23).calculate

        expect(result).to be_nil
      end
    end

    context "when a visit has height and weight" do
      it "returns the correct calculated BSA rounded to default 2 dp" do
        result = described_class.new(height: 1.23, weight: 100.99).calculate

        # BSA = 0.007184 * Weight (kg) ^0.425 * Height (cm) ^0.725
        # To calculate see e.g.
        # https://www.msdmanuals.com/en-gb/medical-calculators/BodySurfaceArea.htm
        expect(result).to eq(1.67)
      end

      it "returns the correct calculated BSA rounded to the requested dp" do
        result = described_class.new(height: 1.23, weight: 100.99).calculate(dp: 3)

        expect(result).to eq(1.672)
      end
    end
  end

  describe "self.calculate convenience class method" do
    it do
      result = described_class.calculate(height: 1.23, weight: 100.99, dp: 3)

      expect(result).to eq(1.672)
    end
  end
end
