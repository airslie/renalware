module Renalware
  module Accesses
    describe Profile do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to validate_presence_of(:type)
        is_expected.to validate_presence_of(:side)
        is_expected.to validate_presence_of(:formed_on)
        is_expected.to validate_timeliness_of(:formed_on)
        is_expected.to validate_timeliness_of(:started_on)
        is_expected.to validate_timeliness_of(:terminated_on)
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to be_versioned
      end

      describe "patient association" do
        let(:clinician) { create(:user, :clinical) }
        let(:patient) { create(:patient) }
        let(:accesses_patient) { Renalware::Accesses.cast_patient(patient) }

        it "can be created through patient association" do
          access_type = create(:access_type)

          profile = accesses_patient.profiles.create!(
            type: access_type,
            side: :left,
            formed_on: Time.zone.today,
            started_on: Time.zone.today,
            by: clinician
          )

          expect(accesses_patient.profiles.count).to eq(1)
          expect(profile.patient).to eq(accesses_patient)
        end
      end
    end
  end
end
