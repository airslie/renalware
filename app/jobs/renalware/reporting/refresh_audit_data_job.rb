# frozen_string_literal: true

module Renalware
  module Reporting
    class RefreshAuditDataJob < ApplicationJob
      queue_as :reporting
      queue_with_priority 1

      # :reek:UtilityFunction
      def perform(audit)
        if audit.materialized?
          refresh_materialized_view_associated_with_audit(audit)
          update_audit_refreshment_date(audit)
        else
          Rails.logger.warn("Cannot refresh an view that is not materialized: #{audit.view_name}")
        end
      end

      private

      def refresh_materialized_view_associated_with_audit(audit)
        Scenic.database.refresh_materialized_view(audit.view_name,
                                                  concurrently: false,
                                                  cascade: false)
      end

      def update_audit_refreshment_date(audit)
        audit.update!(refreshed_at: Time.zone.now)
      end
    end
  end
end
