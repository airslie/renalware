describe "Patient's Dry Weights" do
  let(:patient) { create(:hd_patient) }

  describe "GET index" do
    before do
      create(:dry_weight, patient: Renalware::Clinical.cast_patient(patient))
    end

    it "responds with a list" do
      get patient_clinical_dry_weights_path(patient_id: patient)

      expect(response).to be_successful
    end
  end
end
