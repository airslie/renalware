require "renalware/scheduled_jobs"

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

  # NB: good_job.execution_mode is set per environment in config/environments/*.
  config.good_job.poll_interval = 30

  log_file = Rails.root.join("log", "good_job_#{Rails.env}.log")
  custom_logger = ActiveSupport::Logger.new(log_file)
  custom_logger.formatter = Rails.logger.formatter
  custom_logger.level = Rails.logger.level
  config.good_job.logger = custom_logger

  config.good_job.enable_cron = true
  config.good_job.cron = Renalware::ScheduledJobs.config
  config.good_job.smaller_number_is_higher_priority = true
end
