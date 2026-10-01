module Renalware
  module Users
    # The page a user can safely be returned to after re-authenticating, derived from the
    # page they were on. Form pages are mapped to the nearest page above them, as anything
    # typed into the form has been lost. The page of a singular resource is skipped when mapping
    # its own form, as the resource may not have been saved yet, and some such pages redirect
    # straight back to the form when that happens.
    class ResumablePath
      FORM_ACTIONS = %w(new edit).freeze
      NON_RESUMABLE_CONTROLLERS = %r{\A(renalware/)?(devise/|unlocks\z|session_timeout\z)}

      def initialize(path)
        @path, @query = path.to_s.split("?", 2)
      end

      def to_s
        return if path.blank? || !resumable?(path)

        form_page? ? nearest_page_above_form : path_with_query
      end

      private

      attr_reader :path, :query

      def form_page?
        FORM_ACTIONS.include?(segments.last)
      end

      def nearest_page_above_form
        (segments.length - 1).downto(1)
          .map { |length| "/#{segments.take(length).join('/')}" }
          .find { |candidate| resumable?(candidate) && !singular_resource_of_form?(candidate) }
      end

      def singular_resource_of_form?(candidate)
        route = recognise(candidate)
        route[:controller] == recognise(path)[:controller] &&
          route[:action] == "show" && !route.key?(:id)
      end

      def path_with_query
        [path, query.presence].compact.join("?")
      end

      def segments
        @segments ||= path.split("/").compact_blank
      end

      def resumable?(candidate)
        route = recognise(candidate)
        route.present? && !NON_RESUMABLE_CONTROLLERS.match?(route[:controller].to_s)
      end

      def recognise(candidate)
        Rails.application.routes.recognize_path(candidate, method: :get)
      rescue ActionController::RoutingError
        {}
      end
    end
  end
end
