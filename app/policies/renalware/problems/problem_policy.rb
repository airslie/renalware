# frozen_string_literal: true

module Renalware
  module Problems
    class ProblemPolicy < BasePolicy
      def sort?   = edit?
      def search? = edit?
    end
  end
end
