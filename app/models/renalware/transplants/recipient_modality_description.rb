module Renalware
  module Transplants
    class RecipientModalityDescription < Modalities::Description
      def to_sym
        :transplant
      end
    end
  end
end
