# frozen_string_literal: true

module Renalware
  module Clinical
    class ModalityDescription < Modalities::Description
      def to_sym
        :clinical
      end
    end
  end
end
