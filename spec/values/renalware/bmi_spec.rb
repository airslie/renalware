# frozen_string_literal: true

module Renalware
  describe BMI do
    let(:height) { 1.80 }
    let(:weight) { 180.0 }

    describe ".to_f" do
      subject { described_class.new(height: height, weight: weight).to_f }

      context "when height and weight are present" do
        it { is_expected.to eq(55.6) }
      end

      context "when height is missing" do
        let(:height) { nil }

        it { is_expected.to be_nil }
      end

      context "when weight is missing" do
        let(:weight) { nil }

        it { is_expected.to be_nil }
      end

      context "when weight is zero" do
        let(:weight) { 0 }

        it { is_expected.to eq(0.00) }
      end

      context "when height is zero" do
        let(:height) { 0 }

        it { is_expected.to be_nil }
      end
    end

    describe ".to_s" do
      subject { described_class.new(height: height, weight: weight).to_s }

      it { is_expected.to eq("55.6") }

      context "when height is missing" do
        let(:height) { nil }

        it { is_expected.to eq("") }
      end
    end
  end
end
