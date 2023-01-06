# frozen_string_literal: true

module Renalware
  module LowClearance
    class ModalityDescription < Modalities::Description
      def to_sym
        :low_clearance
      end
    end
  end
end
