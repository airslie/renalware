module Renalware
  module Pathology
    # Can render a predefined Chart or an individual Observation Description
    class ChartComponent < ApplicationComponent
      rattr_initialize [:chartable!, :patient!]
      delegate :title, :axis_label, :axis_type, :to_param, :to_model, to: :chartable

      def chart_id
        @chart_id ||= dom_id(chartable)
      end
    end
  end
end
