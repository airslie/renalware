# frozen_string_literal: true

module Renalware
  describe Dietetics::Queries::ClinicVisitsQuery, type: :component do
    describe "#call" do
      let(:patient) { create(:clinics_patient) }
      let(:instance) { described_class.new }

      context "with dietetic clinic visits for patient" do
        it "returns them" do
          create(:clinic_visit, type: "Renalware::Dietetics::ClinicVisit", patient: patient)

          result = instance.call(patient: patient)
          expect(result.size).to eq 1
          expect(result.first).to be_a Dietetics::ClinicVisit
        end
      end

      context "with not dietetic clinic visits for patient" do
        it "returns an empty array" do
          expect(instance.call(patient: Patient.new)).to eq []
        end
      end
    end
  end
end
