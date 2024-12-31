module Renalware
  module HD
    class SessionAccessPresenter
      def initialize(session)
        @session = session
      end

      def to_s
        return "" unless info

        [
          info.access_type,
          info.access_side&.capitalize
        ].compact.join("<br/>")
      end

      def to_html
        return "" unless info

        [
          abbreviated_type,
          abbreviated_side
        ].compact.join("/").html_safe
      end

      private

      attr_reader :session

      def info
        @info ||= session&.document&.info
      end

      def abbreviated_type
        info.access_type_abbreviation
      end

      def abbreviated_side
        return if info.access_side.blank?

        info.access_side[0].upcase
      end
    end
  end
end
