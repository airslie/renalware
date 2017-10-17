module Renalware
  module HD
    class StationPresenter < SimpleDelegator
      def name
        super.blank? ? "Unnamed Station" : super
      end

      def css
        return if location.blank?
        "background-color: #{location&.colour}"
      end
    end
  end
end
