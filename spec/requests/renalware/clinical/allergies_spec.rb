describe "Allergy management" do
  let(:patient) { create(:clinical_patient, by: user) }
  let(:user) { @current_user }

  context "when allergies are enabled" do
    before do
      allow(Renalware.config).to receive(:enable_allergies).and_return(true)
    end

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

  context "when allergies are disabled" do
    before { allow(Renalware.config).to receive(:enable_allergies).and_return(false) }

    describe "POST create" do
      it "redirects with alert when allergies disabled" do
        url = patient_clinical_allergies_path(patient_id: patient.to_param)
        params = { clinical_allergy: { description: "Nuts" } }

        expect {
          post(url, params: params)
        }.not_to change(patient.allergies, :count)

        expect(response).to redirect_to(patient_clinical_profile_path(patient))
        follow_redirect!
        expect(response.body).to include("Allergy management is disabled")
      end
    end

    describe "DELETE destroy" do
      it "redirects with alert when allergies disabled" do
        allergy = create(:allergy, patient: patient, by: user)
        url = patient_clinical_allergy_path(patient_id: patient.to_param, id: allergy.to_param)

        expect { delete(url) }.not_to change(patient.allergies, :count)

        expect(response).to redirect_to(patient_clinical_profile_path(patient))
        follow_redirect!
        expect(response.body).to include("Allergy management is disabled")
      end
    end
  end
end
