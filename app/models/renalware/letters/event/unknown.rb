module Renalware
  module Letters
    class Event::Unknown < Event
      def description; end

      def to_s
        clinical? ? "Clinical" : "Simple"
      end

      def to_link
        ->(_) { to_s }
      end
    end
  end
end
