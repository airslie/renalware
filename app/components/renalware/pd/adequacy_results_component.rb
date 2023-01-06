# frozen_string_literal: true

module Renalware
  module PD
    class AdequacyResultsComponent < ApplicationComponent
      include BooleanHelper
      include Pagy::Backend
      include Pagy::Frontend
      include ToggleHelper
      rattr_initialize [:patient!, :current_user!]
      attr_reader :pagination

      TITLE = "Adequacy Results"

      def results
        @results ||= begin
          @pagination, @results = pagy(scope, items: 6) # , link_extra: "data-remote='true'")
          @results
        end
      end

      def title
        if pagination.items < pagination.count
          "#{TITLE} (#{pagination.items} of #{pagination.count})"
        else
          "#{TITLE} (#{pagination.items})"
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
