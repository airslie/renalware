module Renalware
  module Accesses
    describe Assessment do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to validate_presence_of(:type)
        is_expected.to validate_presence_of(:side)
        is_expected.to validate_presence_of(:performed_on)
        is_expected.to validate_timeliness_of(:performed_on)
        is_expected.to validate_timeliness_of(:procedure_on)
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to be_versioned
      end

      describe "patient association" do
        let(:user) { create(:user, :minimal, :clinical) }
        let(:patient) { create(:patient, :minimal) }
        let(:accesses_patient) { Renalware::Accesses.cast_patient(patient) }

        it "can be created through patient association" do
          access_type = create(:access_type)

          assessment = accesses_patient.assessments.create!(
            type_id: access_type.id,
            side: :left,
            performed_on: Time.zone.today,
            by: user
          )

          expect(accesses_patient.assessments.count).to eq(1)
          expect(assessment.patient).to eq(accesses_patient)
        end
      end
    end
  end
end
