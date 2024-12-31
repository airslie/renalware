module Renalware
  module HD
    class StationPresenter < DumbDelegator
      def self.policy_class = StationPolicy

      def name
        super.presence || "Unnamed Station"
      end

      def css
        return if location.blank?

        "background-color: #{location&.colour}"
      end
    end
  end
end
