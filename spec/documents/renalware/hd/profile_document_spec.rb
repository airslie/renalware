# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe ProfileDocument::Dialysis, type: :model do
      subject(:dialysis) { described_class.new }

      describe "validation" do
        it :aggregate_failures do
          is_expected.to validate_numericality_of(:blood_flow).is_greater_than_or_equal_to(50)
          is_expected.to validate_numericality_of(:blood_flow).is_less_than_or_equal_to(800)
        end

        context "when it has sodium profiling" do
          before { dialysis.has_sodium_profiling = :yes }

          it :aggregate_failures do
            is_expected.to validate_presence_of(:sodium_first_half)
            is_expected.to validate_presence_of(:sodium_second_half)
          end
        end

        context "when it doesn't have sodium profiling" do
          before { dialysis.has_sodium_profiling = :no }

          it :aggregate_failures do
            is_expected.not_to validate_presence_of(:sodium_first_half)
            is_expected.not_to validate_presence_of(:sodium_second_half)
          end
        end
      end
    end
  end
end
