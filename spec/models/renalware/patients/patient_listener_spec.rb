# frozen_string_literal: true

module Renalware
  module Patients
    describe PatientListener do
      subject(:listener) { described_class.new }

      describe "#patient_modality_changed_to_death" do
        it "delegates to ClearPatientUKRDCData" do
          patient = build_stubbed(:patient)
          user = build_stubbed(:user)

          allow(ClearPatientUKRDCData)
            .to receive(:call)
            .with(patient: patient, by: user)

          listener.patient_modality_changed_to_death(
            patient: patient,
            modality: Object.new,
            actor: user
          )

          expect(ClearPatientUKRDCData).to have_received(:call)
        end
      end
    end
  end
end
