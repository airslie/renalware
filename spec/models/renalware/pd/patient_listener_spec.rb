module Renalware
  module PD
    describe PatientListener do
      subject(:listener) { described_class.new }

      describe "#patient_modality_changed_from_pd" do
        it "terminates the current PD regime when the patient changes away from PD" do
          user = create(:user)
          patient = create(:pd_patient, :with_pd_modality)
          regime = create(:capd_regime, patient:, start_date: "2026-01-01", end_date: nil)
          modality = build(
            :modality,
            patient:,
            description: create(:hd_modality_description),
            started_on: Date.parse("2026-03-01")
          )

          listener.patient_modality_changed_from_pd(
            patient:,
            modality:,
            previous_modality: patient.current_modality,
            actor: user
          )

          expect(regime.reload).to be_terminated
          expect(regime.end_date).to eq(Date.parse("2026-03-01"))
          expect(regime.termination).to have_attributes(
            created_by: user,
            updated_by: user,
            terminated_on: Date.parse("2026-03-01")
          )
        end

        it "does not terminate the current PD regime when the new modality is also PD" do
          user = create(:user)
          patient = create(:pd_patient, :with_pd_modality)
          regime = create(:capd_regime, patient:, start_date: "2026-01-01", end_date: nil)
          modality = build(
            :modality,
            patient:,
            description: create(:pd_modality_description),
            started_on: Date.parse("2026-03-01")
          )

          listener.patient_modality_changed_from_pd(
            patient:,
            modality:,
            previous_modality: patient.current_modality,
            actor: user
          )

          expect(regime.reload).not_to be_terminated
        end
      end
    end
  end
end
