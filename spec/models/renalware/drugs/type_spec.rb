# frozen_string_literal: true

module Renalware::Drugs
  describe Type do
    describe "#active_drugs" do
      subject { described_class.new.active_drugs }
      it { is_expected.to eq [] }
    end
  end
end
