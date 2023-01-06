# frozen_string_literal: true

# An Audit Refreshment is a nominal sql-only activity. Its a REST #create action for consistency,
# though nothing is physically created other than an ActiveJob which is queued and which will
# asynchronously refresh the materialized view associated with the audit.
module Renalware
  module Reporting
    class AuditRefreshmentsController < BaseController
      # TODO: Move to Job
      def create
        authorize audit
        RefreshAuditDataJob.perform_later(audit)
        flash.now[:notice] = "Data will be refreshed in the background, please check back later"
        render locals: { audit_id: audit.id }
      end

      private

      def audit
        @audit ||= Audit.find(secure_params[:audit_id])
      end

      def secure_params
        params.permit(:audit_id)
      end
    end
  end
end
