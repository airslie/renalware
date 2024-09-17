# frozen_string_literal: true

module Renalware
  module PD
    describe CAPDRegime do
      describe "validations" do
        it :aggregate_failures do
          is_expected.not_to validate_numericality_of(:last_fill_volume)
          is_expected.not_to validate_numericality_of(:additional_manual_exchange_volume)
          is_expected.not_to validate_numericality_of(:tidal_percentage)
          is_expected.not_to validate_numericality_of(:no_cycles_per_apd)
          is_expected.not_to validate_numericality_of(:overnight_volume)
          is_expected.not_to validate_numericality_of(:daily_volume)
        end
      end
    end
  end
end
