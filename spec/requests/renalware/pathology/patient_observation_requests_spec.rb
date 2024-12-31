describe "Patient's Observation Requests" do
  let(:patient) { create(:pathology_patient) }

  describe "GET index" do
    before { create(:pathology_observation_request, patient: patient) }

    it "responds with a list" do
      get patient_pathology_observation_requests_path(patient_id: patient)

      expect(response).to be_successful
    end
  end

  describe "GET show" do
    let(:observation_request) { create(:pathology_observation_request, patient: patient) }

    before { create(:pathology_observation, request: observation_request) }

    it "responds with details" do
      get patient_pathology_observation_request_path(
        patient_id: patient, id: observation_request.id
      )

      expect(response).to be_successful
    end
  end
end
