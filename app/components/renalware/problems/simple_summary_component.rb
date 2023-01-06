# frozen_string_literal: true

module Renalware
  module Problems
    class SimpleSummaryComponent < ApplicationComponent
      attr_reader :problems

      def initialize(problems:)
        @problems = problems
      end
    end
  end
end
