require "rails_helper"

module Renalware
  describe Dietetics::Queries::ClinicVisitsQuery, type: :component do
    describe "#call" do
      let(:patient) { Renalware::Clinics.cast_patient(create(:patient)) }
      let(:instance) { described_class.new }

      context "with dietetic clinic visits for patient" do
        let!(:clinic_visit) {
          create(:clinic_visit, type: "Renalware::Dietetics::ClinicVisit", patient: patient)
        }

        it "returns them" do
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
