# frozen_string_literal: true

module Renalware
  module HD
    describe PatientListener do
      subject(:listener) { described_class.new }

      describe "#patient_modality_changed_to_death" do
        it "supersedes HD Profile and nulls unit and schedule" do
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

            # Existing profile is unchanged
            expect(profile.reload).to have_attributes(
              hospital_unit_id: unit.id,
              schedule_definition_id: schedule_definition.id,
              deactivated_at: Time.zone.now
            )

            new_profile = patient.reload.hd_profile
            expect(new_profile).not_to eq(profile)

            # New profile has nulled out unit and schedule
            expect(new_profile.reload).to have_attributes(
              hospital_unit_id: nil,
              schedule_definition_id: nil,
              deactivated_at: nil
            )
          end
        end
      end
    end
  end
end
