module Renalware
  module Accesses
    describe Procedure do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to validate_presence_of(:type)
        is_expected.to validate_presence_of(:performed_on)
        is_expected.to validate_presence_of(:performed_by)
        is_expected.to validate_timeliness_of(:performed_on)
        is_expected.to validate_timeliness_of(:first_used_on)
        is_expected.to validate_timeliness_of(:failed_on)
        is_expected.to belong_to(:pd_catheter_insertion_technique)
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to be_versioned
      end

      describe "patient association" do
        let(:user) { create(:user, :minimal, :clinical) }
        let(:patient) { create(:patient, :minimal) }
        let(:accesses_patient) { Renalware::Accesses.cast_patient(patient) }

        it "can be created through patient association" do
          access_type = create(:access_type)

          procedure = accesses_patient.procedures.create!(
            type: access_type,
            performed_on: Time.zone.today,
            performed_by: user,
            by: user
          )

          expect(accesses_patient.procedures.count).to eq(1)
          expect(procedure.patient).to eq(accesses_patient)
        end
      end
    end
  end
end
