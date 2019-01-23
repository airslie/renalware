# frozen_string_literal: true

# Delayed::Worker.logger = Logger.new(Rails.root.join("log", "delayed_job.log"))
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_attempts = 10 # overridden e.g. in FeedJob
Delayed::Worker.max_run_time = 2.hours
Delayed::Worker.read_ahead = 10
Delayed::Worker.sleep_delay = 15 # Also affects how long it takes delayed_job to stop on Crl+C
Delayed::Worker.default_priority = 5 # use a lower number to get preferential treatment
# Will only raise an exception on TERM signals but INT will wait for the current job to finish.
Delayed::Worker.raise_signal_exceptions = :term
