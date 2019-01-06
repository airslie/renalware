# frozen_string_literal: true

require "rails_helper"

module Renalware
  module PD
    describe CAPDRegime, type: :model do
      describe "validations" do
        it { is_expected.not_to validate_numericality_of(:last_fill_volume) }
        it { is_expected.not_to validate_numericality_of(:additional_manual_exchange_volume) }
        it { is_expected.not_to validate_numericality_of(:tidal_percentage) }
        it { is_expected.not_to validate_numericality_of(:no_cycles_per_apd) }
        it { is_expected.not_to validate_numericality_of(:overnight_volume) }
        it { is_expected.not_to validate_numericality_of(:daily_volume) }
      end
    end
  end
end
