describe Renalware::Clinics::Patient do
  describe ".most_recent_clinic_visit scope" do
    it "returns nil when the patient has no clinic visits" do
      patient = create(:clinics_patient)

      expect(patient.most_recent_clinic_visit).to be_nil
    end

    it "returns the latest clinic visit" do
      patient = create(:clinics_patient)

      # visits[1] is the target. It is on the same date as visits[0] but has a
      # more recent created_at so should be the most recent
      visits = [
        create(:clinic_visit, date: 1.day.ago, patient: patient),
        create(:clinic_visit, date: 1.day.ago, patient: patient),
        create(:clinic_visit, date: 2.days.ago, patient: patient)
      ]

      expect(patient.most_recent_clinic_visit).to eq(visits[1])
    end
  end
end
