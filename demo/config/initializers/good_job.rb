Rails.application.configure do
  # NB: good_job.execution_mode is set differently in each environment so see those config files.
  # Good job recommends (and defaults to)
  #   development => :async => executes jobs in separate threads within the Rails web server process
  #   test => :inline => :inline executes jobs immediately in whatever process queued them
  #   production => :external = queue for processing by external process
  # Note the following env variables are available
  # (see https://github.com/bensheldon/good_job#execute-jobs-async--in-process)
  # GOOD_JOB_EXECUTION_MODE=async
  # GOOD_JOB_MAX_THREADS=4
  # GOOD_JOB_POLL_INTERVAL=30

  # number of seconds between polls for jobs when execution_mode is set to :async
  config.good_job.poll_interval = 30

  # Note that cron jobs are not invoked in development/test as they are only relevant when using
  # execution_mode = :async ie an external process. No harm in setting them globally here though.
  config.good_job.enable_cron = true
  config.good_job.cron = Renalware::Engine.scheduled_jobs_config.merge(
    schedule_refresh_of_materialized_views: {
      cron: "every day at 10:00pm",
      class: "Renalware::System::RefreshMaterializedViewsJob",
      description: "This job will inspect system_view_metadata and schedule a refresh of any " \
                   "materialised views that have a refresh_schedule by enqueuing a " \
                   "RefreshMaterializedViewWithMetadataJob job with a scheduled_at equal to " \
                   "the next datetime specified by the cron schedule. It avoids creating " \
                   "duplicated entries by looking for existing good_job entries, so could run " \
                   "e.g. each hour, but to play safe we are assuming here that no view will " \
                   "refresh >1 time per day, so we we run this job once in the evening. " \
                   "If we need mat views that refresh throughout the day then we can increase " \
                   "the frequency of this job so it will find and schedule those refreshes. " \
                   "Hope to replace this with pg_cron soon."
    },
    run_scheduled_function_ukrdc_update_send_to_renalreg: {
      cron: "every day at 5am",
      class: "Renalware::System::SqlFunctionJob",
      args: ["renalware_demo.ukrdc_update_send_to_renalreg()"],
      description: "This is a demo-only function serving as an example of how to update " \
                   "patients.send_to_renalreg column according to any changes e.g. if their " \
                   "eGFR drops below 30. To use this approach, copy the function to the hospital" \
                   "app and configure in config/initializers/good_job.rb there."
    }
  ).except(
    :ods_sync,
    :ukrdc_export,
    :reporting_send_daily_summary_email
  )
  config.good_job.smaller_number_is_higher_priority = true # refers to queue priority
end
