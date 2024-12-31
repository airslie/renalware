module Renalware::Patients
  describe IdempotentCreatePatient do
    describe "#call" do
      subject(:command) { described_class.new(user) }

      let(:user) { create(:user) }

      context "when a patient does not have the same hospital number" do
        let(:params) { { patient: attributes_for(:patient) } }

        it "creates the patient" do
          expect { command.call(params) }.to change(::Renalware::Patient, :count).by(1)
        end
      end

      context "when a patient has the same hospital number" do
        let!(:existing_patient) { create(:patient, local_patient_id: "SAME-12345") }

        let(:params) do
          {
            patient: attributes_for(:patient).merge(
              local_patient_id: existing_patient.local_patient_id
            )
          }
        end

        it "does not create the patient" do
          expect { command.call(params) }.not_to change(::Renalware::Patient, :count)
        end
      end
    end
  end
end
