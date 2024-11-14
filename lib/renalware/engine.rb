# frozen_string_literal: true

require "rubygems"
require "dotenv-rails"
require "view_component"
require "activerecord-import"
require "ahoy"
require "acts_as_list"
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
require "dumb_delegator"
require "email_validator"
require "enumerize"
require "faraday"
require "fhir_models"
require "font-awesome-sass"
require "friendly_id"
require "fugit"
require "groupdate"
require "hashdiff"
require "httparty"
require "inline_svg"
require "jbuilder"
require "jquery-rails"
require "jquery-ui-rails"
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
require "tailwindcss-rails"
require "ransack"
require "renalware/forms"
require "pandoc-ruby"
require "rack/attack"
require "rqrcode"
require "ruby-hl7"
require "sassc-rails"
require "scenic"
require "slim-rails"
require "store_model"
require "validates_timeliness"
require "virtus"
require "wicked_pdf"
require "wisper"
require "wisper/activejob"
require "debug" if ENV.fetch("RAILS_ENV", nil) == "development"

# Require engines inside /packs
Dir["#{File.dirname(__FILE__)}/../../packs/*/lib/**/engine.rb"].each { |f| require f }
# # include packs
# require_relative "../../packs/reporting/lib/engine"
# require_relative "../../packs/nhs_letter_messaging/lib/engine"
# include packs
# require_relative "../../packs/reporting/lib/engine"

module Renalware
  # Don't have prefix method return anything.
  # This will keep Rails Engine from generating all table prefixes with the engines name
  def self.table_name_prefix = nil

  class Engine < ::Rails::Engine
    isolate_namespace Renalware

    # Define a attr on the Engine's eigenclass so a host application
    # can set an exception handler instance. It must accept a .notify(exception) method.
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
      # rubocop:disable Metrics/MethodLength
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
                          activity (excluding sensitive data) to configured recipients".squish
          },

          ukrdc_export: {
            cron: "Mon-Fri 1am",
            class: "Renalware::InvokeCommandJob",
            args: ["bundle exec rake ukrdc:export"],
            description: "Export UKRDC xml - initially to /apps/current/"
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
          },

          mesh_handshake: {
            cron: "every day at 2am",
            class: "Renalware::Letters::Transports::Mesh::HandshakeJob",
            description: "Lets ToC know to keep the inbox connection alive"
          },

          mesh_check_inbox_for_outstanding_responses: {
            cron: "every 2 minute",
            class: "Renalware::Letters::Transports::Mesh::CheckInboxJob",
            description: "Check our MESH inbox for incoming ToC messages"
          },

          reconcile_mesh_transmissions_job: {
            cron: "every 2 minutes",
            class: "Renalware::Letters::Transports::Mesh::ReconcileOperationsJob",
            description: ""
          }
        }.merge(good_job_config_to_enable_feed_import_via_raw_hl7_messages_table)
      end
      # rubocop:enable Metrics/MethodLength
    end

    def good_job_config_to_enable_feed_import_via_raw_hl7_messages_table
      return {} unless Renalware.config.process_hl7_via_raw_messages_table

      {
        mirth_raw_message_processor: {
          cron: "every 2 minutes",
          class: "Renalware::Feeds::ProcessRawHL7MessagesJob",
          description: "Process Mirth messages"
        }
      }
    end

    # config.view_component.test_controller = "Renalware::BaseController"

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths += %W(#{config.root}/app/validators/concerns)

    config.generators do |gens|
      gens.test_framework :rspec
      gens.fixture_replacement :factory_bot, dir: "spec/factories", suffix: "factory"
    end

    # rubocop:disable Layout/ClassStructure
    initializer :add_locales do |app|
      app.config.i18n.load_path += Dir[config.root.join("config/locales/**/*.yml")]
      app.config.i18n.load_path += Dir[config.root.join("app/components/**/*.yml")]
      app.config.available_locales = [:en] # [:en, :pt]
      app.config.i18n.default_locale = :"en-GB"
      app.config.i18n.fallbacks = [:en]
    end
    # rubocop:enable Layout/ClassStructure

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
      running_in_demo_app = Dir.pwd.ends_with?("demo")
      running_outside_of_engine = app.root.to_s.match(root.to_s + File::SEPARATOR).nil?

      if running_in_demo_app || running_outside_of_engine
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
      config.exceptions_app = lambda do |env|
        Renalware::System::ErrorsController.action(:show).call(env)
      end
      # app.config.action_mailer.preview_path = Engine.root.join("app", "mailers", "renalware")
      app.config.action_mailer.deliver_later_queue_name = "mailers"
    end

    config.before_initialize do
      # Load the config at this stage to make sure we
      # load from the demo/.env
      require "renalware/configuration"

      # In development don't ajax poll so often for a timeout as it can upset our byebug sessions.
      Renalware.configure do |config|
        config.session_timeout_polling_frequency = 1.hour
      end
    end

    config.to_prepare do
      Rails
        .application
        .config
        .active_job.custom_serializers << Renalware::UKRDC::ExportSummary::Serializer
    end
  end
end
