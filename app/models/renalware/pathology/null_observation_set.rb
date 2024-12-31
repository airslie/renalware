module Renalware
  module Pathology
    class NullObservationSet
      def values
        ObservationsJsonbSerializer.load(ActiveSupport::HashWithIndifferentAccess.new)
      end

      def values_for_codes(_codes)
        CurrentObservationSet.null_values_hash
      end
    end
  end
end
