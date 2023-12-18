# frozen_string_literal: true

require "rails_helper"

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
    end
  end
end
