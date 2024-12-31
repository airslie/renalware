module Renalware::PD
  describe ExitSiteInfectionDrop, type: :model do
    subject(:drop) { described_class.new(esi) }

    let(:patient) { build(:patient) }
    let(:esi) { build(:exit_site_infection, patient: patient) }

    it "delegates to #date" do
      expect(drop.date).to eq(l(esi.diagnosis_date))
    end

    describe "organisms" do
      it "concats all organisms into a string" do
        organism_code1 = build(:organism_code, name: "A")
        organism_code2 = build(:organism_code, name: "B")
        organisms = [
          build(:infection_organism, infectable: esi, organism_code: organism_code1),
          build(:infection_organism, infectable: esi, organism_code: organism_code2)
        ]
        allow(esi).to receive(:infection_organisms).and_return(organisms)

        expect(drop.organisms).to eq("A, B")
      end
    end
  end
end
