module Renalware::Accesses
  describe Patient do
    it :aggregate_failures do
      is_expected.to have_many(:profiles)
      is_expected.to have_many(:plans)
      is_expected.to have_many(:procedures)
      is_expected.to have_many(:assessments)
    end

    describe "current_plan" do
      it "returns the current plan" do
        patient = create(:accesses_patient)
        current_plan = create(:access_plan, patient: patient)
        create(:access_plan, patient: patient, terminated_at: Time.zone.now)

        expect(patient.current_plan).to eq(current_plan)
      end
    end
  end
end
