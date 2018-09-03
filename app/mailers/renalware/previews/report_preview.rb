# frozen_string_literal: true

require_dependency "renalware/reporting"

module Renalware
  module Reporting
    # Preview all emails at http://localhost:3000/rails/mailers/report
    class ReportPreview < ActionMailer::Preview
      def daily_summary
        Reporting::ReportMailer.daily_summary
      end
    end
  end
end
