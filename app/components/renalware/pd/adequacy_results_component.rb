module Renalware
  module PD
    class AdequacyResultsComponent < ApplicationComponent
      include BooleanHelper
      include Pagy::Backend
      include Pagy::Frontend
      include ToggleHelper
      rattr_initialize [:patient!, :current_user!]
      attr_reader :pagination

      TITLE = "Adequacy Results".freeze

      def results
        @results ||= begin
          @pagination, @results = pagy(scope, items: 6)
          @results
        end
      end

      def title
        if pagination.limit < pagination.count
          "#{TITLE} (#{pagination.limit} of #{pagination.count})"
        else
          "#{TITLE} (#{pagination.limit})"
        end
      end

      def render?
        results.any?
      end

      private

      def scope
        AdequacyResult.includes([:patient]).for_patient(patient).ordered
      end
    end
  end
end
