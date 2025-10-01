describe "Recording an access assessment for a patient" do
  let(:clinician) { create(:user, :clinical) }
  let(:patient) { create(:patient) }
  let(:accesses_patient) { Renalware::Accesses.cast_patient(patient) }

  describe "creating an access assessment" do
    it "allows a clinician to record an access assessment" do
      access_type = create(:access_type)

      # Create assessment via domain logic (mimicking the step definition)
      assessment = accesses_patient.assessments.create!(
        type_id: access_type.id,
        side: :left,
        performed_on: Time.zone.today,
        by: clinician
      )

      # Verify assessment was created
      expect(accesses_patient.assessments.first).to be_present
      expect(assessment.type_id).to eq(access_type.id)
      expect(assessment.side).to eq("left")
      expect(assessment.performed_on).to eq(Time.zone.today)
    end
  end
end
