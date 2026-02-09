require_relative "boot"
require "rails/all"
require "rack/attack"

Bundler.require(*Rails.groups)
require "renalware"

module RenalwareApp
  class Application < Rails::Application
    config.load_defaults 8.1

    config.cache_store = :file_store, Rails.root.join("tmp/cache")
    config.active_record.time_zone_aware_types = [:datetime]
    config.active_storage.service = :local
    config.autoloader = :zeitwerk
    config.active_record.belongs_to_required_by_default = false
    config.active_record.collection_cache_versioning = false
    config.active_record.dump_schemas = :all
    config.active_record.schema_format = :sql
    # TODO: remove this once we have fixed all queries that require an explicit order.
    config.active_record.raise_on_missing_required_finder_order_columns = false

    if config.respond_to?(:view_component)
      config.view_component.view_component_path = "app/view_components"
      config.view_component.preview_paths << Rails.root.join("spec/view_components/previews")
    end

    config.autoload_paths << Rails.root.join("lib")
    config.autoload_paths << Rails.root.join("app/validators/concerns")
    config.autoload_paths << Rails.root.join("app/view_components")

    # Not loading all files in lib until we resolve the issue
    # uninitialized constant CoreExtensions::DumbDelegator (NameError)
    # config.eager_load_paths << Rails.root.join("lib")
    config.eager_load_paths << Rails.root.join("app/view_components")
    config.eager_load_paths << Rails.root.join("app/validators/concerns")
    config.eager_load_paths << Rails.root.join("app/services")
    config.eager_load_paths << Rails.root.join("app/forms")
    config.eager_load_paths << Rails.root.join("app/queries")

    config.generators do |gens|
      gens.test_framework :rspec
      gens.fixture_replacement :factory_bot, dir: "spec/factories", suffix: "factory"
    end

    config.exceptions_app = lambda do |env|
      Renalware::System::ErrorsController.action(:show).call(env)
    end
    config.action_mailer.default_url_options = { host: ENV.fetch("HOST", "localhost") }
    config.action_mailer.deliver_later_queue_name = "mailers"

    config.time_zone = "London"
    config.active_support.escape_html_entities_in_json = false
    config.active_job.queue_adapter = :good_job

    # Required for loading route fragments from config/routes/*.rb
    config.paths.add "config/routes", glob: "*.rb"

    config.middleware.use Rack::Attack

    initializer :add_locales do
      config.i18n.load_path += Rails.root.glob("config/locales/**/*.{rb,yml}")
      config.i18n.load_path += Rails.root.glob("app/view_components/**/*.yml")
      config.available_locales = [:en]
      config.i18n.default_locale = :"en-GB"
      config.i18n.fallbacks = [:en]
    end

    initializer :use_lograge_in_production do |app|
      next if Rails.env.development?

      require "lograge"
      app.config.lograge.enabled = true
      app.config.lograge.ignore_actions = [
        "Renalware::SessionTimeoutController#check_session_expired",
        "Renalware::SessionTimeoutController#keep_session_alive"
      ]
    end

    initializer :rack_attack do
      # Throttle login attempts for a given username to 10 reqs/minute.
      Rack::Attack.throttle("login attempts per username", limit: 10, period: 60.seconds) do |req|
        req.params["user"]["username"] if req.path == "/users/sign_in" && req.post?
      end
    end

    initializer :assets do |app|
      # Add extra paths so sprockets directives can locate dependent files.
      app.config.assets.paths << Rails.root.join("vendor/assets/javascripts/renalware")
      app.config.assets.paths << Rails.root.join("node_modules")
    end

    initializer :resolve_scenic_paths do |app|
      %w(views functions triggers).each do |db_thing|
        app.config.paths.add("db/#{db_thing}", with: Rails.root.join("db", db_thing))
      end
    end

    config.before_initialize do
      require "renalware/config_accessors"
      require "renalware/configuration"
    end

    config.to_prepare do
      # Register custom LDAP module with Devise for devise() usage.
      #::Devise.add_module(:ldap_authenticatable, strategy: true, model: true)

      # These files register Warden strategies and must be loaded during init.
      require "devise/models/ldap_authenticatable"
      require "devise/strategies/renalware_database_authenticatable"
      #require "devise/strategies/ldap_authenticatable"

      Rails
        .application
        .config
        .active_job
        .custom_serializers << Renalware::UKRDC::ExportSummary::Serializer
    end

    console do
      ARGV.push "-r", Rails.root.join("config/initializers/console_prompt.rb")
    end

    if defined?(InlineSvg)
      InlineSvg.configure do |cfg|
        cfg.raise_on_file_not_found = true
      end
    end

    # Copied from demo/config/initializers/renalware.rb
    # Wire up extra listener to handle letter events
    # TODO: Consider moving this to a Railtie within Renalware::Letters
    # map = config.broadcast_subscription_map
    # map["Renalware::Letters::ApproveLetter"] << "LetterListener"
    # map["Renalware::Letters::DeleteLetter"] << "LetterListener"
    # map["Renalware::Events::CreateEvent"] << "EventListener"
    # map["Renalware::Pathology::CreateObservationRequests"] << "PathologyListener"

    # config.ukrdc_sending_facility_name = "Test"
    # config.site_name = "Renalware"

    # # config.enable_allergies = false # Control display of allergies in UI
    # (Imperial sets to false)
    # config.hl7_patient_locator_strategy[:oru] = :dob_and_any_nhs_or_assigning_auth_number
    # config.hl7_patient_locator_strategy[:adt] = :dynamic

    # # leave patient_visibility_restrictions as :none as demo setting is used on the demo site.
    # config.patient_visibility_restrictions = :none # or :by_site_and_research_study or :by_site

    # config.mesh_organisation_ods_code = "RAJ01"
    # config.mesh_organisation_uuid = "36944886-8c9b-4ada-b15d-500bff58e018"
    # config.mesh_itk_organisation_uuid = "36944886-8c9b-4ada-b15d-500bff58e018"
  end
end
