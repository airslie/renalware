# frozen_string_literal: true

module Renalware::Pathology
  describe ObservationDescriptionsByCodeQuery do
    subject { described_class.new(relation: relation, codes: codes).call }

    let(:codes) { %w(HGB PLT) }
    let(:relation) { ObservationDescription.all }

    context "when codes supplied but there are no matching ObservationDescriptions" do
      it { is_expected.to be_empty }
    end

    context "when empty array of codes supplied" do
      let(:codes) { [] }

      it { is_expected.to be_empty }
    end

    context "when codes is nil" do
      let(:codes) { nil }

      it { is_expected.to be_empty }
    end
  end
end
