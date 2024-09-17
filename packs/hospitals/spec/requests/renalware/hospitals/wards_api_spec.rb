# frozen_string_literal: true

describe "Hospital Wards API" do
  describe "GET index JSON" do
    it "returns wards for a hospital unit, useful for example for inserting into a wards select " \
       "when the parent unit dropdown has changed" do
      unit = create(:hospital_unit)
      ward_a = create(:hospital_ward, name: "WardA", hospital_unit: unit)
      ward_b = create(:hospital_ward, name: "WardB", hospital_unit: unit)

      get hospitals.unit_wards_path(unit, format: :json)

      expect(response).to be_successful
      wards = response.parsed_body.map(&:symbolize_keys)
      expect(wards).to eq(
        [
          { id: ward_a.id, name: ward_a.name },
          { id: ward_b.id, name: ward_b.name }
        ]
      )
    end
  end
end
