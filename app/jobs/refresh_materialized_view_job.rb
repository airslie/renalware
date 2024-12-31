#
# Refresh a materialized view asynchronously via activejob.
# If no view_name supplied, refresh all materialized views
#
class RefreshMaterializedViewJob < ApplicationJob
  queue_with_priority 6

  def perform(view_name:, concurrently: false)
    concurrent = concurrently == true ? "CONCURRENTLY" : ""
    conn = ActiveRecord::Base.connection
    if view_name.present?
      Rails.logger.info("Refreshing materialized view #{view_name}...")
      conn.execute("REFRESH MATERIALIZED VIEW #{concurrent} #{view_name};")
    else
      Rails.logger.info("Refreshing all materialized views...")
      conn.execute("SELECT refresh_all_matierialized_views();")
    end
  end
end
