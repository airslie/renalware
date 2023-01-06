require "rails_helper"

module Renalware
  describe Dietetics::Queries::ClinicVisitsCounter, type: :component do
    describe "#call" do
      let(:patient) { Renalware::Clinics.cast_patient(create(:patient)) }
      let(:instance) { described_class.new }

      context "with dietetic clinic visits for patient" do
        let!(:clinic_visit) {
          create(:clinic_visit, type: "Renalware::Dietetics::ClinicVisit", patient: patient)
        }

        it "returns the count" do
          expect(instance.call(patient: patient)).to eq 1
        end
      end

      context "with not dietetic clinic visits for patient" do
        it do
          expect(instance.call(patient: Patient.new)).to eq 0
        end
      end
    end
  end
end
