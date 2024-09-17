# frozen_string_literal: true

module Renalware
  module PD
    describe PETDextroseConcentration do
      it { is_expected.to validate_presence_of(:name) }

      describe "uniqueness" do
        subject { described_class.new(name: "x", position: 0, value: 1) }

        it { is_expected.to validate_uniqueness_of(:name) }
      end
    end
  end
end
