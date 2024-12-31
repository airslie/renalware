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
  end
end
