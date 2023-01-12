# frozen_string_literal: true

require "rubygems"
require "view_component"
require "active_type"
require "activerecord-import"
require "ahoy"
require "simple_form"
require "client_side_validations"
require "client_side_validations/simple_form"
require "clipboard/rails"
require "cocoon"
require "concurrent-ruby"
require "devise"
require "devise-security"
require "delayed_job_active_record"
require "diffy"
require "diff-lcs"
require "dotenv-rails"
require "dumb_delegator"
require "email_validator"
require "enumerize"
require "font-awesome-sass"
require "friendly_id"
require "groupdate"
require "hashdiff"
require "httparty"
require "inline_svg"
require "jbuilder"
require "jquery-rails"
require "jquery-ui-rails"
require "jquery-datatables-rails"
require "kaminari"
require "liquid"
require "naught"
require "nested_form"
require "nokogiri"
require "ox"
require "pagy"
require "paper_trail"
require "paranoia"
require "pg"
require "prawn"
require "puma"
require "pundit"
require "turbo-rails"
require "ransack"
require "record_tag_helper"
require "renalware/forms"
require "pandoc-ruby"
require "rack/attack"
require "ruby-hl7"
require "sass-rails"
require "scenic"
require "slim-rails"
require "store_model"
require "validates_timeliness"
require "virtus"
require "wicked_pdf"
require "wisper"
require "wisper/activejob"
require "byebug" if ENV.fetch("RAILS_ENV", nil) == "development"

module Renalware
  # Don't have prefix method return anything.
  # This will keep Rails Engine from generating all table prefixes with the engines name
  def self.table_name_prefix = nil

  class Engine < ::Rails::Engine
    isolate_namespace Renalware

    # Define a attr on the Engine's eigenclass so a host application
    # can set an exception handler instance. It must accept a .notify(excetion) method.
    # We use the exception handler when logging errors in background jobs only.
    # Errors in the UI are bubbled up and handled in the host app in the usual way.
    class << self
      attr_writer :exception_notifier

      def exception_notifier
        @exception_notifier ||= NullExceptionNotifier.new
      end
    end

    # Scheduled jobs; Compatible with GoodJob
    class << self
      def scheduled_jobs_config
        {
          ods_sync: {
            cron: "every day at 6am",
            class: "Renalware::Patients::SyncODSJob",
            kwargs: { dry_run: false },
            set: { priority: -10 },
            description: "Use the NHS Organisation Data Service (ODS) API to fetch updates to " \
                         "practices and GPs"
          },

          audit_patient_hd_statistics: {
            cron: "0 3 1 * *", # On the first of each month at 3am
            class: "Renalware::HD::GenerateMonthlyStatisticsAndRefreshMaterializedViewJob",
            description: "Queues delayed jobs to generate monthly HD audits for each patient
                          with a signed-off HD Session in the specified month and year. If
                          no year or month supplied, it will generate stats for last month
                          for each patient.".squish
          },

          hd_scheduling_diary_housekeeping: {
            cron: "every day at 1:00am",
            class: "Renalware::HD::Scheduling::DiaryHousekeepingJob"
          },

          reporting_send_daily_summary_email: {
            cron: "every day at 11:45pm",
            class: "Renalware::InvokeCommandJob",
            args: ["bundle exec rake reporting:send_daily_summary_email"],
            description: "Send an email report on the day's
                          activity (exluding sensitive data) to configured recipients".squish
          },

          ukrdc_export: {
            cron: "Mon-Fri 1am",
            class: "Renalware::InvokeCommandJob",
            args: ["bundle exec rake ukrdc:export"],
            description: "Export UKRDC xml - initially to /apps/current/"
          }
        }
      end
    end

    # config.view_component.test_controller = "Renalware::BaseController"

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths += %W(#{config.root}/app/validators/concerns)

    config.generators do |gens|
      gens.test_framework :rspec
      gens.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    initializer :add_locales do |app|
      app.config.i18n.load_path += Dir[config.root.join("config/locales/**/*.yml")]
      app.config.i18n.load_path += Dir[config.root.join("app/components/**/*.yml")]
      app.config.available_locales = [:en] # [:en, :pt]
      app.config.i18n.default_locale = :"en-GB"
      app.config.i18n.fallbacks = [:en]
    end

    # In production use lograge to help us tame a verbose logs/production.log.
    # Note that the timestamp will be added before the lograge output by whatever Rails
    # LogFormatter is being used (see the app's production.rb) e.g.
    #   config.log_formatter = ::Logger::Formatter.new
    # So bear in mind both log_formatter and lograge are involved in logging.
    # Note exceptions will still be logged including the stacktrace.
    initializer :use_lograge_in_production do |app|
      unless Rails.env.development?
        require "lograge"
        app.config.lograge.enabled = true

        # Ignore session expiry JS polling as these calls fill up the log and we don't
        # need to see them. 100 users with an active session polling every minute will add
        # up to fair number of log entries.
        app.config.lograge.ignore_actions = [
          "Renalware::SessionTimeoutController#check_session_expired",
          "Renalware::SessionTimeoutController#keep_session_alive"
        ]
      end
    end

    config.middleware.use Rack::Attack
    initializer :rack_attack do
      # Throttle login attempts for a given username parameter to 10 reqs/minute
      Rack::Attack.throttle("login attempts per username", limit: 10, period: 60.seconds) do |req|
        # Return the username as a discriminator on POST login requests
        req.params["user"]["username"] if req.path == "/users/sign_in" && req.post?
      end
    end

    initializer :assets do |app|
      # Add some extra paths so sprocket asset directives can locate dependent files
      vendor_js_path = Rails.root.join(config.root, "vendor", "assets", "javascripts", "renalware")
      app.config.assets.paths << vendor_js_path
      app.config.assets.paths << Engine.root.join("node_modules")
    end

    initializer :append_migrations do |app|
      # Prevent duplicate migrations if we are db:migrating at the engine level (eg when
      # running tests) rather than the host app
      running_in_dummy_app = Dir.pwd.ends_with?("dummy")
      running_outside_of_engine = app.root.to_s.match(root.to_s + File::SEPARATOR).nil?

      if running_in_dummy_app || running_outside_of_engine
        engine_migration_paths = config.paths["db/migrate"]
        app_migration_paths =  app.config.paths["db/migrate"]

        engine_migration_paths.expanded.each do |expanded_path|
          app_migration_paths << expanded_path
        end
      end
    end

    initializer :resolve_scenic_views_inside_engine do |app|
      # Set app.config.paths["db/views"] to the engine's db/views path so (our monkey-patched)
      # scenic will load views from the engine (otherwise not supported unless manually copies in
      # a rake task, which I am keen to avoid)
      # See lib/core_extensions/scenic.rb
      %w(views functions triggers).each do |db_thing|
        dir = Rails.root.join(config.root, "db", db_thing)
        app.config.paths.add("db/#{db_thing}", with: dir)
      end
    end

    initializer :general do |app|
      app.config.time_zone = "London"
      app.config.active_record.time_zone_aware_types = [:datetime]
      app.config.active_record.dump_schemas = :all
      app.config.exceptions_app = Engine.routes unless Rails.env.development?
      app.config.action_mailer.preview_path = Engine.root.join("app", "mailers", "renalware")
      app.config.action_mailer.deliver_later_queue_name = "mailers"
    end
  end
end
