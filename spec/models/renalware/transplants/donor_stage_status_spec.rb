# frozen_string_literal: true

module Renalware
  module Transplants
    describe DonorStageStatus do
      it :aggregate_failures do
        is_expected.to respond_to(:created_at)
        is_expected.to respond_to(:updated_at)
        is_expected.to validate_presence_of :name
      end

      describe "validation" do
        subject { described_class.new(name: "name") }

        it { is_expected.to validate_uniqueness_of :name }
      end
    end
  end
end
