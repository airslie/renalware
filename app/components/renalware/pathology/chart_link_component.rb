module Renalware
  module Pathology
    # Renders a link that will open up a modal dialog to view a 'chartable'
    # which can be either a chart or an observation description.
    class ChartLinkComponent < ApplicationComponent
      pattr_initialize [:patient!, :chartable!]

      def call
        link_to(
          chartable.code,
          renalware.polymorphic_path([patient, chartable], format: :html),
          data: {
            "reveal-id" => "pathology-chart-modal",
            "reveal-ajax" => "true"
          },
          class: "path-chart-link"
        )
      end
    end
  end
end
