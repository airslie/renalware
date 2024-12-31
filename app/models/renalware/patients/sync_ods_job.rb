require "nhs_api_client"

module Renalware
  module Patients
    #
    # A background job to fetch practice and GP updates from the NHS Organisation Data Service (ODS)
    # The order in which we fetch data is necessarily strict in order to build the relationships:
    # 1. Practices
    # 2. GPS
    # 3. Practice memberships
    #
    class SyncODSJob < ApplicationJob
      # Do not retry this job as we do not want to keep hitting the ODS API.
      # If it fails this job will be removed form the queue, but make sure we report the error.
      # discard_on(StandardError) do |_job, exception|
      #   Renalware::Engine.exception_notifier.notify(exception)
      #   Rails.logger.error exception
      # end

      # If dry_run: true when we should not save any changes.
      def perform(args)
        dry_run = args[:dry_run]
        sync_practices(dry_run)
        sync_gps_and_memberships(dry_run)
      end

      private

      # For practices, call the NHS Organisation Data Service (ODS) API to get any recent
      # changes/additions. The first time this runs it will take a while because it will fetch all
      # practices. On successive runs it will just find changes since the last run.
      def sync_practices(dry_run)
        Renalware::System::APILog.with_log("nhs_data_api", dry_run: dry_run) do |api_log|
          Renalware::Patients::SyncPracticesViaAPI.call(
            dry_run: dry_run,
            api_log: api_log
          )
        end
      end

      # Kick off another job to download GP and practice membership zip files and import
      # any changes, additions etc.
      # Note at some point ODS might publish this as an API.
      def sync_gps_and_memberships(dry_run)
        return if dry_run

        SyncGpsViaFileDownloadJob.perform_later
      end
    end
  end
end
