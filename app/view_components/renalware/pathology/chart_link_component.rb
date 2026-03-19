module Renalware
  module Pathology
    # Renders a link that will open up a modal dialog to view a 'chartable'
    # which can be either a chart or an observation description.
    class ChartLinkComponent < ApplicationComponent
      pattr_initialize [:patient!, :chartable!]

      def call
        link_to(
          chartable.code,
          chartable_path(format: :html),
          data: { "reveal-id" => "pathology-chart-modal", "reveal-ajax" => "true" },
          class: "path-chart-link"
        )
      end

      private

      def chartable_path(format:)
        # In app mode route helpers are not prefixed with "renalware_".
        helper_name =
          "patient_#{chartable.model_name.singular_route_key.delete_prefix('renalware_')}_path"
        public_send(helper_name, patient, chartable, format: format)
      rescue NoMethodError
        polymorphic_path([patient, chartable], format: format)
      end
    end
  end
end
