describe "Donor stage management" do
  let(:patient) { create(:transplant_patient, by: @current_user) }

  describe "GET show" do
    context "when the patient has no donor workup yet" do
      it "redirects to the workup edit page so one can be added" do
        get patient_transplants_donor_workup_path(patient)

        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response).to render_template(:edit)
      end
    end

    context "when the patient has a donor workup" do
      it "renders the show page" do
        Renalware::Transplants::DonorWorkup.create!(
          patient: patient,
          document: {
            comorbidities: {
              diabetes: {
                status: "unknown"
              }
            }
          }
        )

        get patient_transplants_donor_workup_path(patient)

        expect(response).to be_successful
        expect(response).to render_template(:show)
      end
    end
  end
end
