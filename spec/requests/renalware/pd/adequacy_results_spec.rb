describe "Managing PD Adequacy Results" do
  let(:patient) { create(:pd_patient, by: user) }
  let(:user) { create(:user) }

  describe "GET new" do
    it "responds with a form" do
      get new_patient_pd_adequacy_result_path(patient)

      expect(response).to be_successful
      expect(response.body).to match("PD Summary")
      expect(response.body).to match("New Adequacy")
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      result = create(:pd_adequacy_result, patient: patient)
      get edit_patient_pd_adequacy_result_path(patient, result)

      expect(response).to be_successful
      expect(response.body).to match("PD Summary")
      expect(response.body).to match("Edit Adequacy")
    end
  end

  describe "DELETE destroy" do
    it "soft deletes a pet result" do
      result = create(:pd_adequacy_result, patient: patient)
      delete patient_pd_adequacy_result_path(patient, result)

      expect(response).to be_redirect
      expect(result.reload.deleted_at).to be_present
      expect(patient.adequacy_results.count).to eq(0) # soft deleted
    end
  end
end
