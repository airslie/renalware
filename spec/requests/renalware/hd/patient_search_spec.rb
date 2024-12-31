describe "Patient HD Search e.g. when adding patients to a slot" do
  include PatientsSpecHelper

  let(:hd_mod)  { create(:hd_modality_description) }
  let(:pd_mod)  { create(:pd_modality_description) }
  let(:user)    { create(:user) }
  let(:hd_pat1) { create_pat(given: "HDP1X", family: "HDP1Y", nhs: "4414733227", mod_desc: hd_mod) }
  let(:hd_pat2) { create_pat(given: "HDP2X", family: "HDP2Y", nhs: "7489724309", mod_desc: hd_mod) }
  let(:pd_pat)  { create_pat(given: "PDPx", family: "PDPy", nhs: "1408462818", mod_desc: pd_mod) }
  let(:unit1)   { create(:hospital_unit, unit_code: "UNIT1") }
  let(:unit2)   { create(:hospital_unit, unit_code: "UNIT2") }

  def create_pat(given:, family:, nhs:, mod_desc:)
    create(:hd_patient, family_name: family, given_name: given, nhs_number: nhs).tap do |pat|
      set_modality(
        patient: pat,
        modality_description: mod_desc,
        by: user
      )
    end
  end

  # How the json returned from the API should look for a single patient
  def patient_json(patient, unit_code = nil)
    {
      "text" => [
        patient.becomes(Renalware::Patient).to_s(:long),
        unit_code
      ].compact_blank.join(" - "),
      "value" => patient.id
    }
  end

  describe "dialysing_at_hospital" do
    it "returns [] when there are no HD patients" do
      pd_pat # no hd patients
      get renalware.hd_patients_dialysing_at_hospital_path(format: :json)

      expect(response).to be_successful
      expect(response.parsed_body).to be_empty
    end

    it "returns all HD patients" do
      hd_pat1
      pd_pat

      get renalware.hd_patients_dialysing_at_hospital_path(format: :json)

      expect(response).to be_successful
      expect(response.parsed_body).to match([patient_json(hd_pat1)])
    end

    it "can filter by a search term which matches against e.g. name" do
      hd_pat1
      hd_pat2
      pd_pat

      get renalware.hd_patients_dialysing_at_hospital_path(format: :json, term: hd_pat2.family_name)

      expect(response).to be_successful
      expect(response.parsed_body).to eq([patient_json(hd_pat2)])
    end
  end

  describe "dialysing_at_unit" do
    it "returns [] when there are no HD patients" do
      pd_pat # no hd patients
      get renalware.hd_patients_dialysing_at_unit_path(unit_id: unit1.id, format: :json)

      expect(response).to be_successful
      expect(response.parsed_body).to be_empty
    end

    it "returns all HD patients at unit when no search term" do
      # hd_pat1 is dialysing at our target unit
      create(:hd_profile, hospital_unit: unit1, patient_id: hd_pat1.id)
      # hd_pat2 is dialysing at another unit, so should not show up in the results.
      create(:hd_profile, hospital_unit: unit2, patient_id: hd_pat2.id)

      pd_pat

      get renalware.hd_patients_dialysing_at_unit_path(unit_id: unit1.id, format: :json)

      expect(response).to be_successful
      expect(response.parsed_body).to eq([patient_json(hd_pat1, unit1.unit_code)])
    end

    it "can filter by a search term which matches against e.g. name" do
      # Make both HD patients dialyse at the same unit, but we target just hd_pat2
      create(:hd_profile, hospital_unit: unit1, patient_id: hd_pat1.id)
      create(:hd_profile, hospital_unit: unit1, patient_id: hd_pat2.id)
      pd_pat

      get renalware.hd_patients_dialysing_at_hospital_path(format: :json, term: hd_pat2.family_name)

      expect(response).to be_successful
      expect(response.parsed_body).to eq([patient_json(hd_pat2, unit1.unit_code)])
    end
  end
end
