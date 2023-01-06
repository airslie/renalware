class DropReportingDailyPathologyView < ActiveRecord::Migration[6.0]
  def change
    # Dropping this view as the engine should be agnostic about the activejob adapter in use
    # and not know about delayed_job. The host app can add a view with the same name in the site's
    # own schema eg renalware_kch.reporting_daily_pathology and define a query to identify
    # any queuing issues and pathology counts etc.
    within_renalware_schema do
      drop_view :reporting_daily_pathology
    end
  end
end
