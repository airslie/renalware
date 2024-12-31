module Renalware
  module Problems
    class ProblemPolicy < BasePolicy
      def sort?   = edit?
      def search? = edit?
    end
  end
end
