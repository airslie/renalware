# frozen_string_literal: true

describe Renalware::Clinics::TotalBodyWater do
  describe "#calculate" do
    context "when no recent weight measurement found" do
      it "returns nil" do
        expect(
          described_class.new(
            height: 1.23,
            weight: nil,
            age: 50,
            sex: "F"
          ).calculate
        ).to be_nil
      end
    end

    context "when patient has no sex" do
      it "returns nil" do
        expect(
          described_class.new(
            height: 1.23,
            weight: 100.99,
            age: 50,
            sex: nil
          ).calculate
        ).to be_nil
      end
    end

    context "when patient has a sex which is neither M or F" do
      it "returns 0" do
        expect(
          described_class.new(
            height: 1.23,
            weight: 100.99,
            age: 50,
            sex: "NK"
          ).calculate
        ).to be_nil
      end
    end

    context "when height and weight are provided" do
      context "when male" do
        it "returns the correct calculated TBW rounded to default 2 dp" do
          result =  described_class.new(
            height: 1.23,
            weight: 100.99,
            age: 50,
            sex: "M"
          ).calculate

          # 2.447 - 0.09156 X age + 0.1074 X height (cm) + 0.3362 X weight (kg)
          # See https://qxmd.com/calculate/calculator_344/total-body-water-watson-formula
          # for a calculator
          expect(result).to eq(45.03)
        end
      end

      context "when female" do
        it "returns the correct calculated TBW rounded to default 2 dp" do
          result =  described_class.new(
            height: 1.23,
            weight: 100.99,
            age: 50,
            sex: "F"
          ).calculate

          # -2.097 + 0.1069 X height (cm) + 0.2466 X weight (kg)
          # See https://qxmd.com/calculate/calculator_344/total-body-water-watson-formula
          # for a calculator
          expect(result).to eq(35.96)
        end

        it "can get more decimal places if requested" do
          result =  described_class.new(
            height: 1.23,
            weight: 100.99,
            age: 50,
            sex: "F"
          ).calculate(dp: 4)

          expect(result).to eq(35.9558)
        end
      end
    end
  end

  describe "self.calculate convenience class method" do
    it do
      result = described_class.calculate(
        height: 1.23,
        weight: 100.99,
        age: 50,
        sex: "M",
        dp: 3
      )

      expect(result).to eq(45.032)
    end
  end
end
