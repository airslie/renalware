describe "Clinic Visits Management" do
  let(:user) { @current_user }
  let(:clinic) { create(:clinic) }
  let(:patient) { create(:clinics_patient, by: user) }

  describe "GET index" do
    before do
      get patient_clinic_visits_path(patient_id: patient.to_param)
    end

    it "responds successfully" do
      expect(response).to be_successful
    end
  end

  describe "GET new" do
    it "responds successfully" do
      get new_patient_clinic_visit_path(patient_id: patient.to_param)
      expect(response).to be_successful
    end
  end

  describe "POST create" do
    before do
      post patient_clinic_visits_path(patient_id: patient.to_param),
           params: {
             clinic_visit: {
               date: Time.zone.today,
               time: Time.zone.now,
               clinic_id: clinic,
               did_not_attend: false,
               height: 1.75, weight: 89.2, bp: "110/78",
               urine_blood: "neg",
               urine_protein: "neg",
               urine_glucose: "high",
               notes: "Nothing unusual"
             }
           }
    end

    it "responds successfully" do
      expect(response).to be_successful
    end
  end

  describe "GET edit" do
    before do
      clinic_visit = create(:clinic_visit, patient: patient, by: user)
      get edit_patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)
    end

    it "responds successfully" do
      expect(response).to be_successful
    end
  end

  describe "PUT update" do
    before do
      clinic_visit = create(:clinic_visit, patient: patient, by: user)
      put patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param),
          params: {
            clinic_visit: {
              date: Time.zone.today,
              time: Time.zone.now,
              did_not_attend: false,
              height: 1.75, weight: 89.2, bp: "110/70",
              urine_blood: "neg",
              urine_protein: "neg",
              urine_glucose: "high",
              notes: "Nothing unusual"
            }
          }
    end

    it "redirects to the clinic_visits index" do
      expect(response).to redirect_to(patient_clinic_visits_path(patient))
    end
  end

  describe "DELETE destroy" do
    it "deletes a clinic_visit" do
      clinic_visit = create(:clinic_visit, patient: patient, by: user)
      expect {
        delete patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)
      }.to change(patient.clinic_visits, :count).by(-1)
    end
  end
end
