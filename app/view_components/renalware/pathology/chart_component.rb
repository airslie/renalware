module Renalware
  module Pathology
    # Can render a predefined Chart or an individual Observation Description
    class ChartComponent < ApplicationComponent
      rattr_initialize [:chartable!, :patient!]
      delegate :title, :axis_label, :axis_type, :to_param, :to_model, to: :chartable

      def chart_id
        @chart_id ||= dom_id(chartable)
      end

      def chart_data_path
        # In app mode route helpers are not prefixed with "renalware_".
        helper_name =
          "patient_#{chartable.model_name.singular_route_key.delete_prefix('renalware_')}_path"
        public_send(helper_name, patient, chartable, format: :json)
      rescue NoMethodError
        polymorphic_path([patient, chartable], format: :json)
      end
    end
  end
end
