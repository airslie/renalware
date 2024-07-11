module Renalware
  describe UKRDC::MeasurementUnit do
    it :aggregate_failures do
      is_expected.to respond_to(:name)
      is_expected.to respond_to(:description)
      is_expected.to validate_presence_of(:name)
    end

    describe "#title" do
      it "appends the description in parentheses after the name" do
        [
          { name: "A", description: "B", expected: "A (B)" },
          { name: "A", description: "A", expected: "A" },
          { name: "A", description: "", expected: "A" },
          { name: "A", description: nil, expected: "A" }
        ].each do |conditions|
          unit = described_class.new(
            name: conditions[:name],
            description: conditions[:description]
          )
          expect(unit.title).to eq(conditions[:expected])
        end
      end
    end

    describe "test that .for_dmd_name checks name, description, alias when mapping dmd to " \
             "ukrdc equivalent" do
      [
        {
          name: "mg",
          description: "milligrams",
          alias: ["milligram"],
          matches: {
            "bla" => false,
            "mg" => true,
            "milligram" => true,
            "milligrams" => true
          }
        },
        {
          name: "L",
          description: "litres",
          alias: %w(l litre),
          matches: {
            "l" => true,
            "L" => true,
            "litre" => true,
            "litres" => true,
            "Litre" => false
          }
        }
      ].each do |hash|
        it hash[:name] do
          ukrdc_mg = create(:ukrdc_measurement_unit, hash.except(:matches))
          hash[:matches].each do |dmd_name, should_match|
            expectation = should_match ? ukrdc_mg : nil
            expect(described_class.for_dmd_name(dmd_name)).to eq(expectation)
          end
        end
      end
    end
  end
end
