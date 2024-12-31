module Renalware::Letters
  describe Part::Prescriptions do
    let(:instance) { described_class.new(letter: Letter.new(patient: Patient.new)) }

    describe "#to_partial_path" do
      subject { instance.to_partial_path }
      it { is_expected.to eq "renalware/letters/parts/prescriptions" }
    end
  end
end
