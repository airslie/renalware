describe "Patient Transplant MDM" do
  let(:patient) { create(:transplant_patient, family_name: "Rabbit", local_patient_id: "KCH12345") }

  describe "GET show" do
    it "responds successfully" do
      create(:pathology_observation_description, code: "HGB")
      create(:pathology_observation_description, code: "CMVD")
      create(:pathology_code_group, :default)

      get patient_transplants_mdm_path(patient)

      expect(response).to be_successful
    end
  end
end
