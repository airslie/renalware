# frozen_string_literal: true

require "rubygems"
require "active_type"
require "activerecord-import"
require "ahoy"
require "autoprefixer-rails"
require "chosen-rails"
require "simple_form"
require "client_side_validations"
require "client_side_validations/simple_form"
require "clipboard/rails"
require "cocoon"
require "devise"
require "delayed_job_active_record"
require "delayed_job_web"
require "dotenv-rails"
require "dumb_delegator"
require "email_validator"
require "enumerize"
require "font-awesome-sass"
require "foundation-rails"
require "friendly_id"
require "hashdiff"
require "httparty"
require "jbuilder"
require "jquery-rails"
require "jquery-ui-rails"
require "jquery-datatables-rails"
require "kaminari"
require "liquid"
require "naught"
require "nested_form"
require "nokogiri"
require "paper_trail"
require "paranoia"
require "pg"
require "puma"
require "pundit"
require "ransack"
require "record_tag_helper"
require "pandoc-ruby"
require "rack/attack"
require "ruby-hl7"
require "sass-rails"
require "scenic"
require "slim-rails"
require "trix"
require "underscore-rails"
require "validates_timeliness"
require "virtus"
require "wicked_pdf"
require "wisper"
require "wisper/activejob"
require "rails-assets-foundation-datepicker"
require "rails-assets-select2"
require "rails-assets-moment"
require "rails-assets-mousetrap"
require "document/base"
require "byebug" if ENV["RAILS_ENV"] == "development"

module Renalware
  # Don't have prefix method return anything.
  # This will keep Rails Engine from generating all table prefixes with the engines name
  def self.table_name_prefix; end

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

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths += %W(#{config.root}/app/validators/concerns)

    config.generators do |gens|
      gens.test_framework :rspec
      gens.fixture_replacement :factory_girl, dir: "../../spec/factories"
    end

    initializer :add_locales do |app|
      app.config.i18n.load_path += Dir[config.root.join("config", "locales", "**", "*.{rb,yml}")]
      app.config.i18n.default_locale = "en-GB"
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
          "Renalware::SessionTimeoutController#has_user_timed_out"
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
      app.config.assets.precompile += %w(renalware/print/pathology_request_forms.css)
      app.config.assets.precompile += %w(renalware/modernizr.js)
      app.config.assets.precompile += %w(renalware/iframeResizer.contentWindow.js)
      app.config.assets.precompile += %w(renalware/pdf.css renalware/watermark.css)
      app.config.assets.precompile += %w(renalware/protocol_pdf.css)
      app.config.assets.precompile += %w(renalware/hd_diary_pdf.css)
      app.config.assets.precompile += %w(renalware/table_pdf.css)
      app.config.assets.precompile += %w(
        renalware/nhs_a4_letter_logo_blue.png
        renalware/nhs_a4_letter_logo_black.png
        renalware/NHS-Black.jpg
        renalware/favicon/manifest.json
        renalware/favicon/apple-touch-icon.png
        renalware/favicon/favicon-32x32.png
        renalware/favicon/favicon-16x16.png
        renalware/favicon/favicon.ico
        renalware/favicon/android-chrome-192x192.png
        renalware/favicon/android-chrome-512x512.png
        renalware/favicon/mstile-150x150.png
        renalware/favicon/safari-pinned-tab.svg
        renalware/clippy.svg
        renalware/print-button-example.png
      )
      app.config.assets.paths <<
        Rails.root.join(config.root, "vendor", "assets", "javascripts", "renalware")
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
      app.config.active_job.queue_adapter = :delayed_job
    end
  end
end
