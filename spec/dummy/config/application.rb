# frozen_string_literal: true

require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

require "renalware"

module Dummy
  class Application < Rails::Application
    config.cache_store = :file_store, Rails.root.join("tmp/cache") # capistrano symmlinked
    config.active_record.time_zone_aware_types = [:datetime]
    config.active_storage.service = :local
    config.autoloader = :zeitwerk
    # config.load_defaults Rails::VERSION::STRING.to_f

    config.good_job.execution_mode = :external # :async = executes jobs in separate threads within the Rails web server process
    config.good_job.poll_interval = 30 # number of seconds between polls for jobs when execution_mode is set to :async

    config.good_job.cron = Renalware::Engine.scheduled_jobs_config
    config.good_job.enable_cron = false # Switch to true to enable cron jobs

    # Important!!
    # Unless set to :all, pg extensions are not put into structure.sql so certain
    # functions will not exist.
    config.active_record.dump_schemas = :all

    unless Rails.env.development?
      config.exceptions_app = Renalware::Engine.routes
    end

    config.action_mailer.default_url_options = { host: ENV.fetch("HOST", "localhost") }
    config.time_zone = "London"
    config.active_record.schema_format = :sql
    config.active_support.escape_html_entities_in_json = false

    initializer :add_locales do
      config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.{rb,yml}")]
    end

    console do
      ARGV.push "-r", Renalware::Engine.root.join("config/initializers/console_prompt.rb")
    end

    # We want to start being agnostic about ActiveJob backend rather than being attached to
    # DelayedJob so am using good_job in the dummy.
    # At the time of writing there are still a couple DelayedJob references in core eg using a
    # Struct for the job class in order to overrde the max_tries - which does not seem to be
    # possible in delayed_job when inheriting from ActiveJob::Base - but I might be wrong
    config.active_job.queue_adapter = :good_job
  end
end
