module Renalware
  module Pathology
    # An abstract class representing the responsibility of building the
    # view model for Observation results.
    #
    class ResultsPresenter
      attr_reader :paginator, :view_model

      def present(results, paginator)
        @results = results
        @paginator = paginator
        @view_model = build_view_model
      end

      private

      def build_view_model
        build_header + build_body
      end

      def build_header
        raise NotImplementedError
      end

      def build_body
        raise NotImplementedError
      end
    end
  end
end
