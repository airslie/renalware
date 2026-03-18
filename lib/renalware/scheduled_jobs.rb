module Renalware
  # rubocop:disable Metrics/MethodLength
  module ScheduledJobs
    module_function

    def config
      base_jobs
        .merge(feed_import_jobs)
        .merge(mirth_monitoring_jobs)
        .merge(gp_connect_jobs)
        .merge(ukrdc_jobs)
        .merge(housekeeping_jobs)
    end

    # TODO: below
    # - add env var to enable
    # run_scheduled_function_ukrdc_update_send_to_renalreg: {
    #   cron: "every day at 5am",
    #   class: "Renalware::System::SqlFunctionJob",
    #   args: ["renalware.ukrdc_update_send_to_renalreg()"],
    #   description: "Demo-only scheduled SQL function execution."
    # }
    def base_jobs
      {
        ods_sync: {
          cron: "every day at 6am",
          class: "Renalware::Patients::SyncODSJob",
          kwargs: { dry_run: false },
          set: { priority: -10 },
          description: "Use the NHS Organisation Data Service (ODS) API to fetch updates to " \
                       "practices and GPs"
        },

        expire_inactive_users: {
          cron: "every day at 2am",
          class: "Renalware::ExpireInactiveUsersJob",
          description: "Expire users who have not been active for a certain number of days"
        },

        audit_patient_hd_statistics: {
          cron: "0 3 1 * *",
          class: "Renalware::HD::GenerateMonthlyStatisticsAndRefreshMaterializedViewJob",
          description: "Queues delayed jobs to generate monthly HD audits for each patient " \
                       "with a signed-off HD Session in the specified month and year. If no " \
                       "year or month supplied, it will generate stats for last month for " \
                       "each patient."
        },

        hd_scheduling_diary_housekeeping: {
          cron: "every day at 1:00am",
          class: "Renalware::HD::Scheduling::DiaryHousekeepingJob"
        },

        reporting_send_daily_summary_email: {
          cron: "every day at 11:45pm",
          class: "Renalware::InvokeCommandJob",
          args: ["bundle exec rake reporting:send_daily_summary_email"],
          description: "Send an email report on the day's activity (excluding sensitive data) " \
                       "to configured recipients"
        },

        dmd_sync: {
          cron: "every day at 3am",
          class: "Renalware::Drugs::DMD::SynchroniserJob",
          description: "Use the NHS Digital Terminology Service APIs to fetch DM+D updates to " \
                       "Drugs"
        },

        terminate_given_but_unwitnessed_hd_stat_prescriptions: {
          cron: "every day at 2am",
          class: "Renalware::HD::TerminateAdministeredUnwitnessedStatPrescriptionsJob",
          description: "Does what it says on the tin :)"
        }
      }
    end

    def feed_import_jobs
      return {} unless Renalware.config.process_hl7_via_raw_messages_table

      {
        mirth_raw_message_processor: {
          cron: "every minute",
          class: "Renalware::Feeds::ProcessRawHL7MessagesJob",
          description: "Process Mirth messages"
        }
      }
    end

    def mirth_monitoring_jobs
      return {} unless Renalware.config.monitoring_mirth_enabled

      {
        mirth_monitoring: {
          cron: "every 20 minutes",
          class: "Renalware::Monitoring::Mirth::FetchChannelStatsJob",
          description: "Poll for Mirth channel statistics"
        }
      }
    end

    def gp_connect_jobs
      return {} unless Renalware.config.send_gp_letters_over_mesh == true

      {
        mesh_handshake: {
          cron: "every day at 2am",
          class: "Renalware::Letters::Transports::Mesh::HandshakeJob",
          description: "Lets ToC know to keep the inbox connection alive"
        },

        mesh_check_inbox_for_outstanding_responses: {
          cron: "every 1 minute",
          class: "Renalware::Letters::Transports::Mesh::CheckInboxJob",
          description: "Check our MESH inbox for incoming messages"
        },

        reconcile_mesh_transmissions_job: {
          cron: "every 2 minutes",
          class: "Renalware::Letters::Transports::Mesh::ReconcileOperationsJob",
          description: ""
        }
      }
    end

    def housekeeping_jobs
      return {} unless Renalware.config.housekeeping_jobs_enabled

      {
        schedule_refresh_of_materialized_views: {
          cron: "every day at 10:00pm",
          class: "Renalware::System::RefreshMaterializedViewsJob",
          description: "Inspects system_view_metadata and schedules view refresh jobs " \
                       "without creating duplicates."
        },
        database_housekeeping: {
          cron: "every day at 11:00pm",
          args: ["bundle exec rake housekeeping"],
          class: "Renalware::InvokeCommandJob"
        }
      }
    end

    def ukrdc_jobs
      return {} unless Renalware.config.ukrdc_enabled

      {
        ukrdc_export: {
          cron: "Mon-Fri 1am",
          class: "Renalware::InvokeCommandJob",
          args: ["bundle exec rake ukrdc:export"],
          description: "Export UKRDC xml - initially to /apps/current/"
        },
        ukrdc_sftp_transfer: {
          cron: "every day at 5:30am",
          class: "Renalware::UKRDC::Outgoing::TransferFilesJob",
          description: "SFTP files generated earlier to the UKRDC"
        }
      }
    end
  end
  # rubocop:enable Metrics/MethodLength
end
