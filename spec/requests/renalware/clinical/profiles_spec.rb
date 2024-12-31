describe "Viewing clinical profile" do
  let(:patient) { create(:clinical_patient, by: user) }
  let(:user) { @current_user }

  describe "GET show" do
    it "responds successfully" do
      get patient_clinical_profile_path(patient_id: patient.to_param)
      expect(response).to be_successful
    end
  end

  describe "GET edit" do
    it "responds successfully" do
      get edit_patient_clinical_profile_path(patient_id: patient.to_param)
      expect(response).to be_successful
    end
  end

  describe "PUT update" do
    it "responds successfully" do
      hospital_centre = create(:hospital_centre)
      url = patient_clinical_profile_path(patient_id: patient.to_param)
      death_location = Renalware::Deaths::Location.create!(name: "X")
      params = {
        clinical_profile: {
          hospital_centre_id: hospital_centre.id,
          preferred_death_location_id: death_location.id,
          preferred_death_location_notes: "ABC",
          document: {
            history: { smoking: "ex", alcohol: "rarely" },
            diabetes: { diagnosis: "true", diagnosed_on: "12-12-2017" }
          }
        }
      }

      put(url, params: params)

      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(response).to be_successful

      patient = Renalware::Clinical::Patient.last

      expect(patient.document.history).to have_attributes(
        alcohol: "rarely",
        smoking: "ex"
      )
      expect(patient.document.diabetes).to have_attributes(
        diagnosis: true,
        diagnosed_on: Date.parse("12-12-2017")
      )
      expect(patient).to have_attributes(
        hospital_centre: hospital_centre,
        preferred_death_location: death_location,
        preferred_death_location_notes: "ABC"
      )
    end
  end
end
