# Class for configuring the Renalware app
#
# To override default config values, create an initializer in the host application
# e.g. config/initializers/renalware_core.rb, and use e.g.:
#
#   Renalware.configure do |config|
#    config.x = y
#    ...
#   end
#
# To access configuration settings use e.g.
#   Renalware.config.x
#
require_relative "configuration/hl7_patient_locator_strategy"
require_relative "configuration/clinical"
require_relative "configuration/clinics"
require_relative "configuration/feeds"
require_relative "configuration/hd"
require_relative "configuration/help"
require_relative "configuration/letters"
require_relative "configuration/mail"
require_relative "configuration/medications"
require_relative "configuration/messaging"
require_relative "configuration/pathology"
require_relative "configuration/ukrdc"
require_relative "configuration/users"

# rubocop:disable-next Layout/LineLength
module Renalware
  class Configuration # rubocop:disable Metrics/ClassLength
    include Renalware::ConfigAccessors
    include Clinical
    include Clinics
    include Feeds
    include HD
    include Help
    include Letters
    include Mail
    include Medications
    include Messaging
    include Pathology
    include UKRDC
    include Users

    PATIENT_VISIBILITY_RESTRICTIONS = %i(none by_site_and_research_study by_site).freeze

    # Force dotenv to load the .env file at this stage so we can read in the config defaults.
    # Dotenv 3.x no longer provides Dotenv::Rails, so support both APIs.
    if defined?(Dotenv::Rails)
      Dotenv::Rails.load
    elsif defined?(Dotenv)
      Dotenv.load
    end

    # Links to eg Power BI or Qlick Sense that you might like to display on the login page
    # and on the user's Dashboard when you log in.
    # Needs to be a 2d array [[title,url],[title,url]] loaded from an ENV var in the format
    #  title^url|title^url
    # Or the ENV var can be "" if there are no links to display
    config_accessor(:external_links) do
      links = ENV.fetch("EXTERNAL_LINKS", "")
      pairs = links.split("|").map { |pair| pair.split("^") }
      # Return [] unless its a 2d array each element has a size of 2 (title and url)
      pairs.map(&:size).uniq == [2] ? pairs : []
    end

    config_accessor(:disable_dmd_synchroniser_job) { ENV["DISABLE_DMD_SYNCHRONISER_JOB"].to_i > 0 }
    config_accessor(:enable_dmd_match) { ENV.fetch("ENABLE_DMD_MATCH", "false") == "true" }

    config_accessor(:report_filter_cache_expiry_seconds)    { ENV.fetch("REPORT_FILTER_CACHE_EXPIRY_SECONDS", "60").to_i }
    config_accessor(:allow_qr_codes_in_letters)             { ENV.fetch("ALLOW_QR_CODES_IN_LETTERS", "false") == "true" }
    config_accessor(:enable_allergies)                      { ENV.fetch("ENABLE_ALLERGIES", "true") == "true" }

    config_accessor(:site_name)             { "Renalware" }
    config_accessor(:hospital_department)   { ENV.fetch("HOSPITAL_DEPARTMENT", "Renal") }
    config_accessor(:hospital_name)         { ENV.fetch("HOSPITAL_NAME", "KINGS COLLEGE HOSPITAL") }
    config_accessor(:hospital_address)      { ENV.fetch("HOSPITAL_ADDRESS", "") } # comma-delimited
    config_accessor(:telephone_on_homecare_delivery_forms) {
      ENV.fetch("TELEPHONE_ON_HOMECARE_DELIVERY_FORMS", "")
    }
    config_accessor(:delay_after_which_a_finished_session_becomes_immutable) {
      ActiveModel::Type::Integer.new.cast(
        ENV.fetch("DELAY_AFTER_WHICH_A_FINISHED_SESSION_BECOMES_IMMUTABLE_HOURS", 6)
      ).hours
    }
    config_accessor(:salutation_prefix) { "Dear" }
    config_accessor(:page_title_spearator) { " : " }
    # The mapping of hospital identifiers to local_patient_id columns/fields
    # can be done in the client using an initializer, but we can also load it from
    # an ENV var as a JSON string for convenience.
    config_accessor(:patient_hospital_identifiers) {
      defaults = <<~IDENTIFIERS
        {
          "Dover": "local_patient_id",
          "White": "local_patient_id_2",
          "Sole": "local_patient_id_3",
          "Lundy": "local_patient_id_4",
          "Malin": "local_patient_id_5"
        }
      IDENTIFIERS

      raw = ENV.fetch("PATIENT_HOSPITAL_IDENTIFIERS", defaults)
      parsed = JSON.parse(raw)
      parsed = JSON.parse(parsed) if parsed.is_a?(String) # Handle double-encoded JSON in ENV.

      parsed.each_with_object({}) { |(k, v), h| h[k.to_sym] = v.to_sym }
    }
    config_accessor(:session_timeout) {
      ActiveModel::Type::Integer.new.cast(ENV.fetch("SESSION_TIMEOUT", 20)) # use eg 10080 in dev
    }
    config_accessor(:session_register_user_user_activity_after) {
      # Duration#parse uses the ISO8601 duration format
      ActiveSupport::Duration.parse(
        ENV.fetch("SESSION_REGISTER_USER_USER_ACTIVITY_AFTER", "PT2M") # 2 mins
      )
    }
    config_accessor(:duration_of_last_url_memory_after_session_expiry) {
      ActiveSupport::Duration.parse(
        ENV.fetch("DURATION_OF_LAST_URL_MEMORY_AFTER_SESSION_EXPIRY", "PT30M")
      )
    }
    config_accessor(:broadcast_subscription_map) { {} }
    config_accessor(:aki_alerts_enabled) do
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("AKI_ALERTS_ENABLED", "true"))
    end
    config_accessor(:include_sunday_on_hd_diaries) { false }
    config_accessor(:research_anyone_can_manage_participations) do
      ActiveModel::Type::Boolean.new.cast(
        ENV.fetch("RESEARCH_ANYONE_CAN_MANAGE_PARTICIPATIONS", "false")
      )
    end
    config_accessor(:max_batch_print_size) { ENV.fetch("MAX_BATCH_PRINT_SIZE", 100).to_i }
    # These settings are used in the construction of the IDENT metadata in letters
    config_accessor(:letter_system_name) { "Renalware" }
    config_accessor(:letter_default_care_group_name) { "RenalCareGroup" }
    config_accessor(:default_from_email) { "dev@airslie.com" }
    config_accessor(:display_feedback_banner) { ENV.key?("DISPLAY_FEEDBACK_BANNER") }
    config_accessor(:display_feedback_button_in_navbar) { ENV.key?("DISPLAY_FEEDBACK_BUTTON_IN_NAVBAR") }
    config_accessor(:default_from_email_address) { ENV.fetch("DEFAULT_FROM_EMAIL_ADDRESS", nil) }
    config_accessor(:phone_number_on_letters) { ENV.fetch("PHONE_NUMBER_ON_LETTERS", nil) }
    config_accessor(:renal_unit_on_letters) { ENV.fetch("RENAL_UNIT_ON_LETTERS", nil) }
    config_accessor(:nhs_client_id)     { ENV.fetch("NHS_CLIENT_ID", "") }
    config_accessor(:nhs_client_secret) { ENV.fetch("NHS_CLIENT_SECRET", "") }
    config_accessor(:nhs_trud_api_key)  { ENV.fetch("NHS_TRUD_API_KEY", "") }
    config_accessor(:heidi_api_base_url) {
      ENV.fetch(
        "HEIDI_API_BASE_URL",
        "https://registrar.api.heidihealth.com/api/v2/ml-scribe/open-api/"
      )
    }
    config_accessor(:heidi_scribe_session_base_url) {
      ENV.fetch(
        "HEIDI_SCRIBE_SESSION_BASE_URL",
        "https://registrar.scribe.heidihealth.com/scribe/session/"
      )
    }
    config_accessor(:heidi_link_account_url) {
      ENV.fetch(
        "HEIDI_LINK_ACCOUNT_URL",
        "https://registrar.scribe.heidihealth.com/integration/widget/auth"
      )
    }
    config_accessor(:heidi_region) { ENV.fetch("HEIDI_REGION", "AU") }
    config_accessor(:heidi_api_key) { ENV.fetch("HEIDI_API_KEY", "") }
    config_accessor(:heidi_enabled) do
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("HEIDI_ENABLED", "true"))
    end

    # MESHAPI
    # Introduce an optional delay between letter approval and letter send, in order to allow
    # any human errors to be resolved (letter rescinded etc)
    #
    config_accessor(:send_gp_letters_over_mesh) do
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("SEND_GP_LETTERS_OVER_MESH", "false"))
    end
    # On Azure we use a mapped path otherwise we will use Rails.root.join("tmp")
    # However Rails.root is not yet defined so we need we use a proc to load the config
    # setting JIT when accessed, and rely on the code calling #base_working_folder
    # instead.
    config_accessor(:working_folder) {
      -> { Pathname(ENV["WORKING_FOLDER"] || Rails.root.join("tmp")) }
    }

    def base_working_folder
      @base_working_folder ||= working_folder.call
    end

    config_accessor(:use_rolling_comorbidities) {
      ENV.fetch("USE_ROLLING_COMORBIDITIES", "true") == "true"
    }

    # We override this in some tests as a means of getting wicked_pdf to generate an HTML version
    # of the PDF so we can examine its content
    config_accessor(:render_pdf_as_html_for_debugging) { false }
    config_accessor(:enable_new_mdms) { true }

    # If the NHS number is in the PID-3 segment along with other identifiers, we need to know
    # the assigning authority code for the NHS number so we can extract it.
    config_accessor(:nhs_number_assigning_authority) { :NHSNBR }

    config_accessor(:days_ahead_to_warn_named_consultant_about_expiring_hd_prescriptions) do
      ENV.fetch("DAYS_AHEAD_TO_WARN_NAMED_CONSULTANT_ABOUT_EXPIRING_HD_PRESCRIPTIONS", "14").to_i
    end

    config_accessor(:days_behind_to_warn_named_consultant_about_expired_hd_prescriptions) do
      ENV.fetch("DAYS_BEHIND_TO_WARN_NAMED_CONSULTANT_ABOUT_EXPIRED_HD_PRESCRIPTIONS", "14").to_i
    end

    config_accessor(:batch_printing_enabled) {
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("BATCH_PRINTING_ENABLED", "true"))
    }
    config_accessor(:legacy_letters_enabled) {
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("RENALWARE_LEGACY_LETTERS_ENABLED", nil))
    }
    config_accessor(:legacy_letters_body_selector) {
      ENV.fetch("RENALWARE_LEGACY_LETTERS_BODY_SELECTOR", "#letter_text_body")
    }
    config_accessor(:allow_uploading_patient_attachments) {
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("ALLOW_UPLOADING_PATIENT_ATTACHMENTS", "true"))
    }
    config_accessor(:active_storage_malware_scanning_enabled) {
      ActiveModel::Type::Boolean.new.cast(
        ENV.fetch("ACTIVE_STORAGE_MALWARE_SCANNING_ENABLED", "false")
      )
    }
    config_accessor(:active_storage_malware_scanning_service_names) {
      ENV.fetch("ACTIVE_STORAGE_MALWARE_SCANNING_SERVICE_NAMES", "azure_blob")
        .split(",")
        .map(&:strip)
        .compact_blank
    }
    config_accessor(:active_storage_malware_scan_poll_interval_seconds) {
      ENV.fetch("ACTIVE_STORAGE_MALWARE_SCAN_POLL_INTERVAL_SECONDS", "30").to_i
    }
    config_accessor(:active_storage_malware_scan_poll_batch_size) {
      ENV.fetch("ACTIVE_STORAGE_MALWARE_SCAN_POLL_BATCH_SIZE", "10").to_i
    }
    config_accessor(:active_storage_malware_scan_service_bus_client_class_name) {
      ENV.fetch(
        "ACTIVE_STORAGE_MALWARE_SCAN_SERVICE_BUS_CLIENT_CLASS_NAME",
        "Renalware::FileStorage::AzureServiceBusMalwareScanResultsClient"
      )
    }
    config_accessor(:active_storage_malware_scan_service_bus_namespace) {
      ENV.fetch("ACTIVE_STORAGE_MALWARE_SCAN_SERVICE_BUS_NAMESPACE", nil)
    }
    config_accessor(:active_storage_malware_scan_service_bus_queue_name) {
      ENV.fetch("ACTIVE_STORAGE_MALWARE_SCAN_SERVICE_BUS_QUEUE_NAME", nil)
    }
    config_accessor(:active_storage_malware_scan_service_bus_sas_key_name) {
      ENV.fetch("ACTIVE_STORAGE_MALWARE_SCAN_SERVICE_BUS_SAS_KEY_NAME", nil)
    }
    config_accessor(:active_storage_malware_scan_service_bus_sas_key) {
      ENV.fetch("ACTIVE_STORAGE_MALWARE_SCAN_SERVICE_BUS_SAS_KEY", nil)
    }
    config_accessor(:active_storage_malware_scan_service_bus_receive_timeout_seconds) {
      ENV.fetch("ACTIVE_STORAGE_MALWARE_SCAN_SERVICE_BUS_RECEIVE_TIMEOUT_SECONDS", "5").to_i
    }
    config_accessor(:azure_blob_storage_account_name) {
      ENV.fetch("AZURE_STORAGE_ACCOUNT_NAME", nil)
    }
    config_accessor(:azure_blob_storage_container) {
      ENV.fetch("AZURE_STORAGE_CONTAINER", nil)
    }
    config_accessor(:generate_pathology_request_forms_from_hd_mdm_listing) {
      ActiveModel::Type::Boolean.new.cast(
        ENV.fetch("GENERATE_PATHOLOGY_REQUEST_FORMS_FROM_HD_MDM_LISTING", "true")
      )
    }
    config_accessor(:disable_inputs_controlled_by_tissue_typing_feed) {
      ActiveModel::Type::Boolean.new.cast(
        ENV.fetch("DISABLE_INPUTS_CONTROLLED_BY_TISSUE_TYPING_FEED", "false")
      )
    }
    config_accessor(:disable_inputs_controlled_by_demographics_feed) {
      ActiveModel::Type::Boolean.new.cast(
        ENV.fetch("DISABLE_INPUTS_CONTROLLED_BY_DEMOGRAPHICS_FEED", "false")
      )
    }
    config_accessor(:enforce_user_prescriber_flag) {
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("ENFORCE_USER_PRESCRIBER_FLAG", "false"))
    }
    config_accessor(:allow_modality_history_amendments) {
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("ALLOW_MODALITY_HISTORY_AMENDMENTS", "true"))
    }
    config_accessor(:auto_terminate_hd_prescriptions_after_period) {
      optional_duration_from_env("AUTO_TERMINATE_HD_PRESCRIPTIONS_AFTER_PERIOD", "P6M")
    }
    config_accessor(:auto_terminate_hd_stat_prescriptions_after_period) {
      optional_duration_from_env("AUTO_TERMINATE_HD_STAT_PRESCRIPTIONS_AFTER_PERIOD", "P14D")
    }
    config_accessor(:enable_expiring_prescriptions_list_component) {
      ActiveModel::Type::Boolean.new.cast(
        ENV.fetch("ENABLE_EXPIRING_PRESCRIPTIONS_LIST_COMPONENT", "true")
      )
    }
    config_accessor(:display_nhsbt_wait_list_upload) {
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("DISPLAY_NHSBT_WAIT_LIST_UPLOAD", "true"))
    }
    config_accessor(:good_job_execution_mode) do
      ENV.fetch("GOOD_JOB_EXECUTION_MODE", "external").to_sym
    end

    config_accessor(:user_dashboard_display_named_patients) { true }
    config_accessor(:users_expire_after) {
      ActiveModel::Type::Integer.new.cast(ENV.fetch("USERS_EXPIRE_AFTER", 90))
    }
    config_accessor(:aki_alerts_daily_period_start_time) {
      ENV.fetch("AKI_ALERTS_DAILY_PERIOD_START_TIME", "09:45")
    }

    # A host app can override this to add/remove/re-order the clinical summary display
    # Note these have to be strings - they mapped to constants in ClinicalSummaryPresenter.
    # At some point we might make page layouts and dashboards data-driven.
    config_accessor(:page_layouts) {
      {
        clinical_summary: %w(
          Renalware::Problems::SummaryComponent
          Renalware::Medications::SummaryPart
          Renalware::Patients::TimelineComponent
          Renalware::Letters::SummaryPart
          Renalware::Events::SummaryPart
          Renalware::Admissions::SummaryPart
          Renalware::Admissions::ConsultSummaryPart
          Renalware::Patients::SummaryPart
          Renalware::Patients::MessagesComponent
        )
      }
    }

    # This the default mapping from possible HL7 PID 'administrative sex' values that we
    # might see in a message, to their Renalware equivalent. A hospital can override this
    # mapping if they have different values in their HL7 messages.
    # Note that the standard HL7 PID admin sex values are not adhered to here. For reference
    # they are:
    # F Female, M Male, O Other, U Unknown, A Ambiguous, N Not applicable
    # Some hospitals use the numeric NHS Person Gender code.
    # Note
    # - NS = Not Stated
    # - NK = Not Known
    config_accessor(:hl7_pid_sex_map) do
      default_sex_map = {
        "MALE" => "M",
        "FEMALE" => "F",
        "OTHER" => "NS",
        "UNKNOWN" => "NK",
        "NOTKNOWN" => "NK",
        "INDETERMINATE" => "NK",
        "AMBIGUOUS" => "NS",
        "NOT APPLICABLE" => "NS",
        "BOTH" => "NS",
        "0" => "NK",
        "1" => "M",
        "2" => "F",
        "9" => "NS"
      }.to_json

      raw = ENV.fetch("HL7_PID_SEX_MAP", default_sex_map)
      raw = default_sex_map if raw.strip.empty?

      parsed = JSON.parse(raw)
      parsed = JSON.parse(parsed) if parsed.is_a?(String) # Handle double-encoded JSON in ENV.
      parsed
    end
    config_accessor(:max_file_upload_size) { ENV.fetch("MAX_FILE_UPLOAD_SIZE", "10_000_000").to_i }

    # Options are:
    #   :simple
    #   :dob_and_any_nhs_or_assigning_auth_number
    #   :nhs_or_any_assigning_auth_number
    #   :dynamic
    #   :dynamic2
    config_accessor(:hl7_patient_locator_strategy) do
      Configuration::HL7PatientLocatorStrategy.load_from_env
    end
    config_accessor(:demo_password) { "renalware" }
    config_accessor(:password_policy_description) {
      ENV.fetch(
        "PASSWORD_POLICY_DESCRIPTION",
        "Passwords must be at least 8 characters"
      )
    }

    config_accessor(:patients_must_have_at_least_one_hosp_number) {
      ActiveModel::Type::Boolean.new.cast(
        ENV.fetch("PATIENTS_MUST_HAVE_AT_LEAST_ONE_HOSP_NUMBER", "true")
      )
    }

    config_accessor(:only_admins_can_update_pkb_renalreg_preferences) {
      ActiveModel::Type::Boolean.new.cast(
        ENV.fetch("ONLY_ADMINS_CAN_UPDATE_PKB_RENALREG_PREFERENCES", "false")
      )
    }

    config_accessor(:igan_prediction_tool_title) {
      ENV.fetch("IGAN_PREDICTION_TOOL_TITLE", "IgAN Prediction Tool")
    }
    config_accessor(:igan_prediction_tool_url) {
      ENV.fetch(
        "IGAN_PREDICTION_TOOL_URL",
        "https://qxmd.com/calculate/calculator_499/international-igan-prediction-tool-at-biopsy-adults"
      )
    }

    config_accessor(:patient_visibility_restrictions) { patient_visibility_restrictions_from_env }

    config_accessor(:urr_generation_enabled) do
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("URR_GENERATION_ENABLED", "false"))
    end

    config_accessor(:legacy_api_query_authentication_enabled) do
      ActiveModel::Type::Boolean.new.cast(
        ENV.fetch("LEGACY_API_QUERY_AUTHENTICATION_ENABLED", "true")
      )
    end

    #
    # Monitoring::Mirth
    # Default to out-of-the-box development settings
    #
    config_accessor(:monitoring_mirth_enabled) { # but see good_job schedule also
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("MONITORING_MIRTH_ENABLED", "false"))
    }
    config_accessor(:monitoring_mirth_polling_enabled) {
      ActiveModel::Type::Boolean.new.cast(
        ENV.fetch("MONITORING_MIRTH_POLLING_ENABLED", monitoring_mirth_enabled)
      )
    }
    config_accessor(:monitoring_mirth_api_base_url) {
      ENV.fetch("MONITORING_MIRTH_API_BASE_URL", "https://localhost:8443/api")
    }
    config_accessor(:monitoring_mirth_api_username) {
      ENV.fetch("MONITORING_MIRTH_API_USERNAME", "admin")
    }
    config_accessor(:monitoring_mirth_api_password) {
      ENV.fetch("MONITORING_MIRTH_API_PASSWORD", "admin")
    }

    config_accessor(:housekeeping_jobs_enabled) {
      ActiveModel::Type::Boolean.new.cast(
        ENV.fetch("HOUSEKEEPING_JOBS_ENABLED", "true")
      )
    }

    def restrict_patient_visibility_by_user_site?
      %i(by_site by_site_and_research_study).include?(patient_visibility_restrictions)
    end

    def restrict_patient_visibility_by_research_study?
      patient_visibility_restrictions == :by_site_and_research_study
    end

    private

    def optional_duration_from_env(key, default)
      value = ENV.fetch(key, default)
      return if value.blank?

      duration = ActiveSupport::Duration.parse(value)
      duration.zero? ? nil : duration
    end

    def patient_visibility_restrictions_from_env
      value = ENV.fetch("PATIENT_VISIBILITY_RESTRICTIONS", "none").to_s.strip.delete_prefix(":")
      value = "none" if value.blank?

      value.to_sym.tap do |restriction|
        unless PATIENT_VISIBILITY_RESTRICTIONS.include?(restriction)
          raise ArgumentError,
                "Invalid PATIENT_VISIBILITY_RESTRICTIONS: #{value.inspect}. " \
                "Expected one of: #{PATIENT_VISIBILITY_RESTRICTIONS.map { |item| ":#{item}" }.join(', ')}"
        end
      end
    end
  end

  class << self
    def config        = Configuration.config # rubocop:disable Rails/Delegate
    def configure(&)  = Configuration.configure(&)
  end
end
