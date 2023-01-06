module Renalware
  module HD
    class GenerateMonthlyStatisticsAndRefreshMaterializedViewJob < ApplicationJob
      def perform(month: nil, year: nil)
        Renalware::HD::GenerateMonthlyStatistics.new(
          month: month,
          year: year
        ).call

        # Refresh the materialized view which will aggregate the monthly hd_patient_statistics data
        RefreshMaterializedViewJob.perform_later(view_name: "renalware.reporting_hd_overall_audit")
      end
    end
  end
end
