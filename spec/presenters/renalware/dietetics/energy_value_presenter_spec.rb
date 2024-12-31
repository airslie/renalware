module Renalware::Dietetics
  describe EnergyValuePresenter do
    describe "#to_s" do
      let(:instance) { described_class.new(value) }

      subject { instance.to_s }

      context "when value is nil" do
        let(:value) { nil }

        it { is_expected.to be_nil }
      end

      context "when value is set" do
        let(:value) { 123 }

        it { is_expected.to eq "123 kcal/day" }
      end
    end
  end
end
