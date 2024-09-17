# frozen_string_literal: true

module Renalware
  module Medications
    describe PatientListener do
      subject(:listener) { described_class.new }

      describe "#patient_modality_changed_to_death" do
        it "terminates all prescriptions if the modality description type is death" do
          patient = build_stubbed(:patient)
          user = build_stubbed(:user)

          allow(TerminateAllPatientPrescriptions).to receive(:call)

          listener.patient_modality_changed_to_death(
            patient: patient,
            modality: Object.new,
            actor: user
          )

          expect(TerminateAllPatientPrescriptions)
            .to have_received(:call)
            .with(patient: patient, by: user)
        end
      end
    end
  end
end
