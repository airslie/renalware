# frozen_string_literal: true

module Renalware
  module Transplants
    class RecipientModalityDescription < Modalities::Description
      def to_sym
        :transplant
      end
    end
  end
end
