module Renalware::Hospitals
  describe Unit do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:hospital_centre)
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:unit_code)
      is_expected.to validate_presence_of(:renal_registry_code)
      is_expected.to validate_presence_of(:unit_type)
      is_expected.to have_many(:wards)
    end

    describe "#unit_type_rr8" do
      it "maps each unit_type to the expected RR8 code" do
        described_class::UNIT_TYPE_RR8_MAP.each do |unit_type, rr8_code|
          unit = build(:hospital_unit, unit_type: unit_type)

          expect(unit.unit_type_rr8).to eq(rr8_code)
        end
      end
    end
  end
end
