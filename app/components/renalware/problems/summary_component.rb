module Renalware
  module Problems
    # Encapsulates a 'patient problems widget' comprising some heading 'chrome' and a compact table
    # of problems (with toggleable notes). The component is designed to be displayed on a
    # clinical summary or other patient dashboard.
    class SummaryComponent < ApplicationComponent
      include ToggleHelper
      rattr_initialize [:patient!, :current_user!]

      def problems
        @problems ||= CollectionPresenter.new(patient.problems.with_notes, ProblemPresenter)
      end

      def cache_key
        [
          patient.cache_key_with_version,
          patient.problems.cache_key_with_version
        ].join("~")
      end

      # Removing caching for now as on production on Azure the patient.cache_key was not
      # rendering (returning just an id and not an updated timestamp) resulting in stale
      # cache for this component being displayed.
      # TODO: investigate
      def cache?
        false # cache_key.present?
      end

      # Always render the component chrome even if there are no problems to display
      def render?
        true
      end
    end
  end
end
