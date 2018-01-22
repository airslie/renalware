require "rails_helper"

module Renalware::Letters
  describe Part::ClinicalObservations do
    subject(:part) { Part::ClinicalObservations.new(patient, Letter.new, clinic_visit_event) }

    let(:clinic_visit_event) {
      Renalware::Clinics::ClinicVisit.new(
        height: 1.80, weight: 90.0, bp: "110/70", urine_blood: :very_low, urine_protein: :trace
      )
    }
    let(:patient) { double(:patient) }

    it "delegates the height to the event" do
      expect(part.height).to eq(1.80)
    end

    it "delegates the weight to the event" do
      expect(part.weight).to eq(90.0)
    end

    it "delegates the bp to the event" do
      expect(part.bp).to eq("110/70")
    end

    it "delegates the bmi to the event" do
      expect(part.bmi).to eq(27.78)
    end

    it "delegates the urine_blood to the event" do
      expect(part.urine_blood.text).to eq("+")
    end

    it "delegates the urine_protein to the event" do
      expect(part.urine_protein.text).to eq("Trace")
    end
  end
end
