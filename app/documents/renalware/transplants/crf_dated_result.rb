module Renalware
  module Transplants
    class CRFDatedResult < DatedResult
      validates :result,
                numericality: {
                  greater_than: 0,
                  less_than_or_equal_to: 100,
                  allow_blank: true
                }

      # This allow us to add specific validation to this value object while keeping the
      # default rendering of DatedResult
      def to_partial_path
        "renalware/shared/documents/dated_result"
      end
    end
  end
end
