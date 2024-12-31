module Renalware
  module Deaths
    class ModalityDescription < Modalities::Description
      def to_sym
        :death
      end
    end
  end
end
