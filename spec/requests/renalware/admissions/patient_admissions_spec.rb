module Renalware
  describe "Listing admissions for the current patient" do
    let(:user) { create(:user) }
    let(:time) { Time.zone.now }
    let(:hospital_ward) { create(:hospital_ward, name: "Ward1") }
    let(:patient) { create(:patient, by: user) }

    describe "GET #index" do
      it "lists the patient's inpatient admissions" do
        create(:admissions_admission,
               by: user,
               patient: patient,
               admitted_on: Time.zone.today,
               admission_type: :unknown,
               reason_for_admission: "Reason1",
               hospital_ward: hospital_ward)

        get patient_admissions_path(patient)

        expect(response).to be_successful
        expect(response.body).to include("Inpatient Admissions")
        expect(response.body).to include("Reason1")
        expect(response.body).to include(hospital_ward.name)
      end
    end
  end
end
