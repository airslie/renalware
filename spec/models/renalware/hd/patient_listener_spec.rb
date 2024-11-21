# frozen_string_literal: true

module Renalware
  module HD
    describe PatientListener do
      subject(:listener) { described_class.new }

      describe "#patient_modality_changed_to_death" do
        it "deactivates the current HD Profile" do
          user = create(:user)
          unit = create(:hospital_unit)
          schedule_definition = create(:schedule_definition, :mon_wed_fri_am)
          patient = create(:hd_patient)
          profile = create(
            :hd_profile,
            patient: patient,
            by: user,
            prescriber: user,
            hospital_unit: unit,
            schedule_definition: schedule_definition
          )

          freeze_time do
            listener.patient_modality_changed_to_death(
              patient: patient,
              modality: Object.new,
              actor: user
            )

            expect(profile.reload).to be_deleted

            # Patient now has no current HD Profile
            expect(patient.reload.hd_profile).to be_nil
          end
        end
      end
    end
  end
end
