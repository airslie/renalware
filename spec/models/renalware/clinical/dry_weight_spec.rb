module Renalware
  module Clinical
    describe DryWeight do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to validate_presence_of(:patient)
        is_expected.to validate_presence_of(:assessor)
        is_expected.to validate_presence_of(:weight)
        is_expected.to validate_presence_of(:assessed_on)
        is_expected.to validate_timeliness_of(:assessed_on)
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to be_versioned
      end

      describe "optional weight range validation" do
        context "when min and max weights are entered" do
          it "validates minimum_weight is <= maximum_weight" do
            dw = described_class.new(minimum_weight: 80, maximum_weight: 90).tap(&:valid?)

            expect(dw.errors.attribute_names).not_to include(:minimum_weight)
            expect(dw.errors.attribute_names).not_to include(:maximum_weight)
          end
        end

        it "validates minimum_weight cannot be > maximum_weight" do
          dw = described_class.new(minimum_weight: 90, maximum_weight: 80).tap(&:valid?)

          expect(dw.errors[:minimum_weight]).to eq(["must be less than or equal to 80.0"])
        end

        it "validates maximum_weight must be lteq min weight plus max range/diff eg 90kg" do
          dw = described_class.new(minimum_weight: 100, maximum_weight: 191).tap(&:valid?)

          expect(dw.errors[:maximum_weight]).to eq(["must be less than or equal to 190.0"])
        end
      end
    end
  end
end
