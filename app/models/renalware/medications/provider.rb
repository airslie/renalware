# frozen_string_literal: true

module Renalware
  module Medications
    class Provider
      def self.codes
        %i(gp hospital home_delivery)
      end
    end
  end
end
