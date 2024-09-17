# frozen_string_literal: true

module Renalware::Clinics
  describe WeightValuePresenter do
    describe "#to_s" do
      let(:instance) { described_class.new(value) }

      subject { instance.to_s }

      context "when value is nil" do
        let(:value) { nil }

        it { is_expected.to be_nil }
      end

      context "when value is set" do
        let(:value) { 123 }

        it { is_expected.to eq "123 kg" }
      end
    end
  end
end
