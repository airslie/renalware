# frozen_string_literal: true

module Renalware
  module Problems
    class ProblemPolicy < BasePolicy
      def sort?
        edit?
      end

      def search?
        edit?
      end
    end
  end
end
