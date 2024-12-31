module Renalware
  module Medications
    class TreatablePresenter < DumbDelegator
      def sortable?
        is_a?(Patient)
      end
    end
  end
end
