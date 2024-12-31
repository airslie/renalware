module Renalware
  module PD
    class MDMPresenter < Renalware::MDMPresenter
      def pathology_code_group_name
        :pd_mdm
      end

      def current_regime
        @current_regime ||= patient.pd_regimes&.current
      end

      def latest_pd_line_change_events
        @latest_pd_line_change_events ||= Events::LineChangeEventQuery.new(patient).call(limit: 1)
      end
    end
  end
end
