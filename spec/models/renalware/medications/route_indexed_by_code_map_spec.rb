# frozen_string_literal: true

module Renalware
  module Medications
    describe RoutesIndexedByCodeMap do
      subject(:map) { described_class.new }

      describe "#[](key)" do
        it "returns nil where no match" do
          create(:medication_route, code: "999")

          expect(map["123"]).to be_nil
        end

        it "returns the route that matches its code" do
          route = create(:medication_route, code: "123")

          expect(map["123"]).to eq(route)
        end

        it "does not match a route with a code of ''" do
          # Skip validations as although DB allows a blank code, Rails does not
          # As data might be upserted we cannot guarantee the code is not blank
          # as validations might not have been applied using upsert?
          MedicationRoute.new(code: "", name: "S").save!(validate: false)

          expect(map[""]).to be_nil
        end

        it "does not match a route with a code of nil" do
          # Skip validations as although DB allows a blank code, Rails does not
          # As data might be upserted we cannot guarantee the code is not blank
          # as validations might not have been applied using upsert?
          MedicationRoute.new(code: nil, name: "S").save!(validate: false)

          expect(map[""]).to be_nil
        end
      end
    end
  end
end
