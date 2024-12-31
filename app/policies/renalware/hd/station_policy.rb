module Renalware
  module HD
    class StationPolicy < BasePolicy
      def sort? = edit?
      def index = true
    end
  end
end
