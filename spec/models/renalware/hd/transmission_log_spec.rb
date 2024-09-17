# frozen_string_literal: true

module Renalware
  module HD
    describe TransmissionLog do
      it :aggregate_failures do
        is_expected.to validate_presence_of(:direction)
        is_expected.to validate_presence_of(:format)
        is_expected.to belong_to(:hd_provider_unit)
      end
    end
  end
end
