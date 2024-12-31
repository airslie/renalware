module Renalware::Letters
  describe Part::Problems do
    let(:instance) { described_class.new(letter: Letter.new(patient: patient)) }
    let(:patient) { Renalware::Letters::Patient.new }

    it "delegates to the patient's current problems" do
      allow(patient).to receive(:problems).and_return(Renalware::Problems::Problem.none)

      instance.to_a

      expect(patient).to have_received(:problems)
    end

    describe "#to_partial_path" do
      subject { instance.to_partial_path }
      it { is_expected.to eq "renalware/letters/parts/problems" }
    end
  end
end
