module Renalware
  module Letters
    class Part::Problems < Section
      def problems
        @problems ||= patient.problems.includes(:notes)
      end
      delegate_missing_to :problems

      def to_partial_path
        "renalware/letters/parts/problems"
      end
    end
  end
end
