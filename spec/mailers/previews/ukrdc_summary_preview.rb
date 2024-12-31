module Renalware
  module UKRDC
    # Preview all emails at http://localhost:3000/rails/mailers
    class SumaryPreview < ActionMailer::Preview
      def daily_summary
        summary = ExportSummary.new(
          archive_folder: "/var/ukrdc/test",
          num_changed_patients: 10,
          milliseconds_taken: 123.0,
          results: { sent: 1, unsent: 2 }
        )
        UKRDC::SummaryMailer.export_summary(summary: summary)
      end
    end
  end
end
