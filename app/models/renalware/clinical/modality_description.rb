module Renalware
  module Clinical
    class ModalityDescription < Modalities::Description
      def to_sym
        :clinical
      end
    end
  end
end
