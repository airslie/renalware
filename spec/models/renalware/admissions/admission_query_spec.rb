# frozen_string_literal: true

module Renalware
  describe Admissions::AdmissionQuery do
    it "returns all admissions if no options passed" do
      admission = create(:admissions_admission)

      admissions = described_class.call({})

      expect(admissions).to eq([admission])
    end

    it "filters by name" do
      patient = create(:patient, family_name: "Jones", given_name: "Tom")
      admission = create(:admissions_admission, patient: patient)
      create(:admissions_admission) # other admission

      admissions = described_class.call(identity_match: "JOn to")

      expect(admissions).to eq([admission])
    end

    it "filters by hospital unit" do
      ward = create(:hospital_ward)
      admission = create(:admissions_admission, hospital_ward: ward)
      create(:admissions_admission) # other admission

      admissions = described_class.call(
        hospital_ward_hospital_unit_id_eq: ward.hospital_unit.id
      )

      expect(admissions).to eq([admission])
    end

    it "filters by hospital ward" do
      ward = create(:hospital_ward)
      admission = create(:admissions_admission, hospital_ward: ward)
      create(:admissions_admission) # other admission

      admissions = described_class.call(hospital_ward_id_eq: ward.id)

      expect(admissions).to eq([admission])
    end
  end
end
