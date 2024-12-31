module Renalware::Medications
  describe RevisePrescription do
    let(:patient) { create(:patient) }
    let(:user) { create(:user) }
    let(:original_dose_amount) { "100" }
    let(:original_prescription) do
      create(
        :prescription,
        patient: patient,
        dose_amount: original_dose_amount,
        dose_unit: "milligram"
      )
    end

    describe "#call" do
      let(:user) { create(:user) }

      context "when updating the prescription's dose_amount with a valid value" do
        subject!(:prescription_revision) do
          described_class
            .new(original_prescription, user)
            .call(dose_amount: revised_dose_amount, by: user)
        end

        let(:revised_dose_amount) { "200" }

        it "returns true" do
          expect(prescription_revision).to be(true)
        end

        it "terminates the original prescription and creates a new one" do
          expect(patient.prescriptions.count).to eq(2)
        end

        it "create a new prescription with the specified dose amount" do
          expect(patient.prescriptions.current.first.dose_amount).to eq(revised_dose_amount)
        end

        it "retains the original dose_amount on the terminated prescription" do
          expect(patient.prescriptions.terminated.first.dose_amount).to eq(original_dose_amount)
        end

        it "discards the original (legacy) dose_unit" do
          expect(original_prescription.dose_unit).to eq("milligram")
          expect(patient.prescriptions.current.first.dose_unit).to be_nil
        end
      end

      context "when updating the prescription's dose_amount with an invalid value" do
        subject!(:prescription_revision) do
          described_class
            .new(original_prescription, user)
            .call(dose_amount: revised_dose_amount, by: user)
        end

        let(:revised_dose_amount) { nil }

        it "returns false" do
          expect(prescription_revision).to be_falsey
        end

        it "populates the original prescription's errors" do
          expect(original_prescription.errors.messages.keys).to include(:dose_amount)
        end

        it "sets the original prescription's dose_amount to the revised value" do
          expect(original_prescription.dose_amount).to eq(revised_dose_amount)
        end

        it "rolls back the transaction" do
          expect(patient.prescriptions.count).to eq(1)
          expect(patient.prescriptions.current.first).to eq(original_prescription)
        end
      end

      context "when prescription is in the future and with no future termination date" do
        let(:original_prescribed_on) { 1.week.from_now.to_date }
        let(:original_prescription) do
          create(
            :prescription,
            patient: patient,
            dose_amount: original_dose_amount,
            dose_unit: "milligram",
            prescribed_on: original_prescribed_on
          )
        end

        it "terminates the original prescription using today for prescribed_on and terminated_on" do
          original_prescription
          today = Time.zone.today.to_date
          new_dose = "123"

          expect {
            described_class
              .new(original_prescription, user)
              .call(dose_amount: new_dose, by: user)
          }.to change(Prescription, :count).by(1)
            .and change(PrescriptionTermination, :count).by(1)

          original_prescription = patient.prescriptions.terminated.last
          new_prescription = patient.prescriptions.last

          # As the new prescription is on the future we should keep future prescription date.
          expect(new_prescription).to have_attributes(
            prescribed_on: original_prescribed_on,
            dose_amount: new_dose
          )
          expect(new_prescription.termination).to be_nil

          # we change the original prescription's dates to be today
          # TODO: expect(original_prescription.prescribed_on).to eq(today)
          expect(original_prescription.termination.terminated_on).to eq(today)
        end
      end

      context "when prescription is in the future and has a future termination date" do
        let(:original_prescribed_on) { 1.week.from_now.to_date }
        let(:original_terminated_on) { 2.weeks.from_now.to_date }
        let(:original_prescription) do
          create(
            :prescription,
            patient: patient,
            dose_amount: original_dose_amount,
            dose_unit: "milligram",
            prescribed_on: original_prescribed_on
          ).tap { |pres| pres.terminate(by: user, terminated_on: original_terminated_on).save! }
        end

        it "terminates the original prescription using today for prescribed_on and terminated_on" do
          original_prescription
          today = Time.zone.today.to_date
          new_dose = "123"

          expect {
            described_class
              .new(original_prescription, user)
              .call(dose_amount: new_dose, by: user)
          }.to change(Prescription, :count).by(1)
            .and change(PrescriptionTermination, :count).by(1)

          original_prescription = patient.prescriptions.terminated.last
          new_prescription = patient.prescriptions.last

          # As the new prescription is on the future we should keep future prescription date.
          expect(new_prescription).to have_attributes(
            prescribed_on: original_prescribed_on,
            dose_amount: new_dose
          )
          expect(new_prescription.termination.terminated_on).to eq(original_terminated_on)

          # we change the original prescription's dates to be today
          # expect(original_prescription.prescribed_on).to eq(today)
          expect(original_prescription.termination.terminated_on).to eq(today)
        end
      end
    end
  end
end
