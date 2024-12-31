module Renalware::Letters
  describe Part::ClinicalObservations do
    subject(:part) { described_class.new(letter: Letter.new, event: visit) }

    let(:visit) {
      Renalware::Clinics::ClinicVisit.new(
        height: 1.80, weight: 90.0, bp: "110/70", bmi: 27.8,
        urine_blood: :very_low, urine_protein: :trace, urine_glucose: :medium
      )
    }

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
      expect(part.bmi).to eq(27.8)
    end

    it "delegates the urine_blood to the event" do
      expect(part.urine_blood.text).to eq("+")
    end

    it "delegates the urine_protein to the event" do
      expect(part.urine_protein.text).to eq("Trace")
    end

    it "delegates the urine_glucose to the event" do
      expect(part.urine_glucose.text).to eq("++")
    end
  end
end
