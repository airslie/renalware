module Renalware
  module Problems
    class SimpleSummaryComponent < ApplicationComponent
      attr_reader :problems

      def initialize(problems:)
        @problems = problems
        super
      end
    end
  end
end
