# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Transplants
    describe DonorStagePosition do
      it :aggregate_failures do
        is_expected.to respond_to(:created_at)
        is_expected.to respond_to(:updated_at)
        is_expected.to validate_presence_of(:name)
      end

      describe "validation" do
        subject { DonorStagePosition.new(name: "name") }

        it { is_expected.to validate_uniqueness_of :name }
      end
    end
  end
end
