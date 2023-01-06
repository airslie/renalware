# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe PrescriptionsHelper do
    let(:patient) { create(:patient) }
    let(:med_route) { create(:medication_route) }
    let(:amoxicillin) { create(:drug, name: "Amoxicillin") }
    let(:invalid_patient_med) do
      build(
        :prescription,
        patient: patient,
        drug: nil,
        dose_amount: nil,
        dose_unit: nil,
        medication_route_id: nil,
        frequency: nil,
        prescribed_on: nil,
        provider: nil
      )
    end
    let(:valid_patient_med) do
      build(
        :prescription,
        patient: patient,
        treatable: patient,
        drug: amoxicillin,
        dose_amount: "23",
        dose_unit: "milligram",
        medication_route: med_route,
        frequency: "PID",
        prescribed_on: "02/10/2014",
        provider: 0
      )
    end

    describe "highlight_validation_fail" do
      context "with errors" do
        it "applies hightlight" do
          invalid_patient_med.save
          expect(highlight_validation_fail(invalid_patient_med, :drug)).to eq("field_with_errors")
        end
      end

      context "with no errors" do
        it "does not apply highlight" do
          valid_patient_med.save
          expect(highlight_validation_fail(valid_patient_med, :drug)).to be_nil
        end
      end
    end

    describe "validation_fail" do
      context "with errors" do
        it "applies class 'show-form'" do
          invalid_patient_med.save
          expect(validation_fail(invalid_patient_med)).to eq("show-form")
        end
      end

      context "with no errors" do
        it "applies class 'content'" do
          valid_patient_med.save
          expect(validation_fail(valid_patient_med)).to eq("content")
        end
      end
    end

    describe "default_provider" do
      let(:gp) { Medications::Prescription.providers.keys[0] }
      let(:hospital) { Medications::Prescription.providers.keys[1] }

      context "when gp" do
        it "returns 'checked'" do
          expect(default_provider(gp)).to eq("checked")
        end
      end

      context "when not gp" do
        it "returns nil" do
          expect(default_provider(hospital)).to be_nil
        end
      end
    end
  end
end
