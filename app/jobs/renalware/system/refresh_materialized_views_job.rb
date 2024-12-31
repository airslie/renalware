module Renalware
  module System
    # When this job executes it loops through all system_view_meta_data rows and
    # checks to see if there are any materialized views that can be refreshed. For each one
    # it calculates the next refresh_at datetime when the cron schedule will kick off, and provided
    # a GoodJob has not already been scheduled for that view_name/refresh_at combination, schedules
    # an active job with GoodJob.
    #
    # We check for an existing matching GoodJob entry first as we do not want to accidentally
    # kick off multiple refreshes of the same mat view.
    #
    # A couple of things to note:
    # - GoodJob of course has its own cron manager, but its cron jobs are whatever is defined in
    #   eg application.rb and are loaded into memory at app boot ie they are immutable, so event if
    #   we could cron-schedule individual mat view refreshes, any new mat view definitions added to
    #   system_view_metadata will not be be picked up without an app restart. There is also the
    #   issue of the order of initialisation and the fact that the system_view_metadata cron
    #   definitions are not available to be queried at the point that GoodJoB initializes, though
    #   that might be solvable.
    # - A better solution to the one below is to use the pg_cron postgres extension with perhaps
    #   a trigger on system_view_metadata to update pg_cron when rows are edited/added/deleted
    #   but unfortunately this is not yet available on Postgres Single Server, but will be when we
    #   migrate to Flexible server.
    class RefreshMaterializedViewsJob < ApplicationJob
      def perform
        Renalware::System::ViewMetadata.refreshable_materialised_views.each do |metadata|
          refresh_at = next_refresh_at(metadata.refresh_schedule)
          next if refresh_at.blank?
          next if scheduled_job_is_already_enqueued?(metadata, refresh_at)

          enqueue_job_to_refresh_materialized_view(metadata, refresh_at)
        end
      end

      private

      def scheduled_job_is_already_enqueued?(view_metadata, scheduled_at)
        GoodJob::Job.where(
          "serialized_params -> 'arguments' -> 1 ->> 'view_name' = ? and scheduled_at = ?",
          view_metadata.fully_qualified_view_name,
          scheduled_at.utc
        ).count > 0
      end

      # The view_name kw arg we pass to perform_later is stored in good_jobs.serialized_params
      # and we use it in #scheduled_job_is_already_enqueued but it has no other use. Its easier to
      # search  good_jobs.serialized_params for this than to try and match the globalid path
      # the view_metadata object.
      # E.g.
      #   arguments": [
      #    {
      #      "_aj_globalid": "gid://demo/Renalware::System::ViewMetadata/13"
      #    },
      #    {
      #      "view_name": "renalware.xxx",
      #      ...
      #    }
      #  ]
      def enqueue_job_to_refresh_materialized_view(view_metadata, refresh_at)
        # Note we need to convert the EtOrbi::EoTime into seconds when using wait_until
        RefreshMaterializedViewWithMetadataJob
          .set(wait_until: refresh_at.to_i) # populates good_jobs.scheduled_at column
          .perform_later(
            view_metadata,
            view_name: view_metadata.fully_qualified_view_name
          )
      end

      # For a given cron string, calculate the next datetime this cron schedule would kick in.
      # Example:
      #   when today is 2023-06-01 then '0 1 * * *' (At 01:00 each day) => '2023-06-02 01:00:00'
      # Note we only support trad cron syntax, not the 'natural' syntax eg 'every day at five'.
      # See https://github.com/floraison/fugit
      # Note we nil if the refresh_schedule was not a valid cron expression
      def next_refresh_at(cron_schedule)
        Fugit::Cron.parse(cron_schedule)&.next_time
      end
    end
  end
end
