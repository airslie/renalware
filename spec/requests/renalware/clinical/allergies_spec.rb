describe "Allergy management" do
  let(:patient) { create(:clinical_patient, by: user) }
  let(:user) { @current_user }

  describe "POST create" do
    it "responds successfully" do
      url = patient_clinical_allergies_path(patient_id: patient.to_param)
      params = { clinical_allergy: { description: "Nuts" } }

      expect {
        post(url, params: params)
      }.to change(patient.allergies, :count).by(1)
      follow_redirect!
      expect(response).to be_successful
    end
  end

  describe "DELETE destroy" do
    it "deletes the allergy" do
      allergy = create(:allergy, patient: patient, by: user)
      url = patient_clinical_allergy_path(patient_id: patient.to_param, id: allergy.to_param)

      expect { delete(url) }.to change(patient.allergies, :count).by(-1)
      follow_redirect!
      expect(response).to be_successful
      expect(patient.allergies.with_deleted.count).to eq(1)
    end
  end
end
