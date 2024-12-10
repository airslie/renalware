# frozen_string_literal: true

# Class for configuring the Renalware::Core engine
# http://stackoverflow.com/questions/24104246/how-to-use-activesupportconfigurable-with-rails-engine
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
# rubocop:disable Layout/LineLength
module Renalware
  class Configuration # rubocop:disable Metrics/ClassLength
    include ActiveSupport::Configurable

    # Force dotenv to load the .env file at this stage so we can read in the config defaults
    Dotenv::Rails.load

    config_accessor(:disable_dmd_synchroniser_job) { ENV["DISABLE_DMD_SYNCHRONISER_JOB"].to_i > 0 }

    config_accessor(:report_filter_cache_expiry_seconds) {
      ENV.fetch("REPORT_FILTER_CACHE_EXPIRY_SECONDS", "60").to_i
    }
    config_accessor(:letters_render_pdfs_with_prawn) {
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("LETTERS_RENDER_PDFS_WITH_PRAWN", "false"))
    }
    config_accessor(:letters_mesh_workflow) { :gp_connect } # or :transfer_of_care
    config_accessor(:allow_qr_codes_in_letters) do
      ENV.fetch("ALLOW_QR_CODES_IN_LETTERS", "false") == "true"
    end
    config_accessor(:site_name) { "Renalware" }
    config_accessor(:hospital_name) { ENV.fetch("HOSPITAL_NAME", "KINGS COLLEGE HOSPITAL") }
    config_accessor(:hospital_address) { ENV.fetch("HOSPITAL_ADDRESS", "") } # comma-delimited
    config_accessor(:telephone_on_homecare_delivery_forms) {
      ENV.fetch("TELEPHONE_ON_HOMECARE_DELIVERY_FORMS", "")
    }
    config_accessor(:hospital_department) { ENV.fetch("HOSPITAL_DEPARTMENT", "Renal") }
    config_accessor(:delay_after_which_a_finished_session_becomes_immutable) { 6.hours }
    config_accessor(:new_clinic_visit_deletion_window) { 24.hours }
    config_accessor(:new_clinic_visit_edit_window) { 7.days }
    config_accessor(:salutation_prefix) { "Dear" }
    config_accessor(:page_title_spearator) { " : " }
    config_accessor(:patient_hospital_identifiers) { {} }
    config_accessor(:session_timeout_polling_frequency) { 1.minute }
    config_accessor(:session_timeout) {
      ActiveModel::Type::Integer.new.cast(ENV.fetch("SESSION_TIMEOUT", 20)) # use eg 10080 in dev
    }
    config_accessor(:session_register_user_user_activity_after) { 2.minutes }
    config_accessor(:duration_of_last_url_memory_after_session_expiry) { 30.minutes }
    config_accessor(:broadcast_subscription_map) { {} }
    config_accessor(:include_sunday_on_hd_diaries) { false }
    config_accessor(:clinical_summary_max_events_to_display) { 10 }
    config_accessor(:clinical_summary_max_letters_to_display) { 10 }
    config_accessor(:max_batch_print_size) { ENV.fetch("MAX_BATCH_PRINT_SIZE", 100).to_i }
    # These settings are used in the construction of the IDENT metadata in letters
    config_accessor(:letter_system_name) { "Renalware" }
    config_accessor(:letter_default_care_group_name) { "RenalCareGroup" }
    config_accessor(:clinic_name_code_separator) { ENV.fetch("CLINIC_NAME_CODE_SEPARATOR", " ") }
    config_accessor(:default_from_email) { "dev@airslie.com" }
    config_accessor(:display_feedback_banner) { ENV.key?("DISPLAY_FEEDBACK_BANNER") }
    config_accessor(:display_feedback_button_in_navbar) do
      ENV.key?("DISPLAY_FEEDBACK_BUTTON_IN_NAVBAR")
    end
    config_accessor(:default_from_email_address) { ENV.fetch("DEFAULT_FROM_EMAIL_ADDRESS", nil) }
    config_accessor(:phone_number_on_letters) { ENV.fetch("PHONE_NUMBER_ON_LETTERS", nil) }
    config_accessor(:renal_unit_on_letters) { ENV.fetch("RENAL_UNIT_ON_LETTERS", nil) }
    # Unless an ALLOW_EXTERNAL_MAIL key is present in .env or .env.production, mail (other than
    # password reset emails etc) will be redirected to e.g. the user who approved the letter.
    config_accessor(:allow_external_mail) { ENV.key?("ALLOW_EXTERNAL_MAIL") }
    config_accessor(:fallback_email_address_for_test_messages) do
      ENV.fetch("FALLBACK_EMAIL_ADDRESS_FOR_TEST_MESSAGES", nil)
    end
    config_accessor(:ukrdc_include_letters) do
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("UKRDC_INCLUDE_LETTERS", "true"))
    end
    config_accessor(:ukrdc_sending_facility_name) { ENV.fetch("UKRDC_SENDING_FACILITY_NAME", nil) }
    config_accessor(:ukrdc_schema_version) { ENV.fetch("UKRDC_SCHEMA_VERSION", "3.3.1") }
    config_accessor(:ukrdc_default_changes_since_date) {
      Date.parse(ENV.fetch("UKRDC_DEFAULT_CHANGES_SINCE_DATE", "2018-01-01"))
    }
    config_accessor(:ukrdc_gpg_recipient) do
      ENV.fetch("UKRDC_GPG_RECIPIENT", "Patient View (Renal)") # or "UKRDC"
    end
    config_accessor(:ukrdc_public_key_name) do
      ENV.fetch("UKRDC_PUBLIC_KEY_NAME", "patientview.asc") # might become ukrdc.asc
    end
    config_accessor(:ukrdc_working_path) do
      ENV.fetch("UKRDC_WORKING_PATH", File.join("/var", "ukrdc"))
    end
    config_accessor(:ukrdc_site_code) { ENV.fetch("UKRDC_PREFIX", "RJZ") }
    config_accessor(:ukrdc_number_of_archived_folders_to_keep) do
      ENV.fetch("UKRDC_NUMBER_OF_ARCHIVED_FOLDERS_TO_KEEP", "7")
    end
    config_accessor(:ukrdc_remove_stale_outgoing_files) do
      ENV.fetch("UKRDC_REMOVE_STALE_OUTGOING_FILES", "true") == "true"
    end
    config_accessor(:ukrdc_sftp_host)         { ENV.fetch("UKRDC_SFTP_HOST", nil) }
    config_accessor(:ukrdc_sftp_user)         { ENV.fetch("UKRDC_SFTP_USER", nil) }
    config_accessor(:ukrdc_sftp_password)     { ENV.fetch("UKRDC_SFTP_PASSWORD", nil) }
    config_accessor(:ukrdc_sftp_port)         { ENV.fetch("UKRDC_SFTP_PORT", 22) }
    config_accessor(:ukrdc_sftp_remote_path)  { ENV.fetch("UKRDC_SFTP_REMOTE_PATH", "") }

    # To use a date other that the default changes_since date when
    # compiling pathology to send to UKRDC, you can set an ENV var as follows:
    #   UKRDC_PATHOLOGY_START_DATE=01-01-2011
    # in the .env file (or e.g. .env.production) and we will always fetch pathology
    # from this date on. It only affects pathology and not medications, letters etc.
    # It is not indented to keep this date set, but its useful if UKRDC ask for
    # a dump of historical pathology.
    config_accessor(:ukrdc_pathology_start_date) { ENV.fetch("UKRDC_PATHOLOGY_START_DATE", nil) }

    config_accessor(:ukrdc_send_rpv_patients) {
      ENV.fetch("UKRDC_SEND_RPV_PATIENTS", "true") == "true"
    }

    config_accessor(:ukrdc_send_rreg_patients) {
      ENV.fetch("UKRDC_SEND_RREG_PATIENTS", "true") == "true"
    }

    config_accessor(:nhs_client_id)     { ENV.fetch("NHS_CLIENT_ID",      Rails.application.credentials.nhs_client_id) }
    config_accessor(:nhs_client_secret) { ENV.fetch("NHS_CLIENT_SECRET",  Rails.application.credentials.nhs_client_secret) }
    config_accessor(:nhs_trud_api_key)  { ENV.fetch("NHS_TRUD_API_KEY",   Rails.application.credentials.nhs_trud_api_key) }

    # MESHAPI
    # Introduce an optional delay between letter approval and letter send, in order to allow
    # any human errors to be resolved (letter rescinded etc)
    #
    config_accessor(:send_gp_letters_over_mesh) do
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("SEND_GP_LETTERS_OVER_MESH", "false"))
    end
    config_accessor(:mesh_timeout_transmissions_with_no_response_after) do
      # Duration#parse uses the ISO8601 duration format
      ActiveSupport::Duration.parse(
        ENV.fetch("MESH_TIMEOUT_TRANSMISSIONS_WITH_NO_RESPONSE_AFTER", "PT24H")
      )
    end
    config_accessor(:mesh_delay_seconds_between_letter_approval_and_mesh_send) do
      ActiveModel::Type::Integer.new.cast(
        ENV.fetch("MESH_DELAY_SECONDS_BETWEEN_LETTER_APPROVAL_AND_MESH_SEND", "15")
      ).seconds
    end
    config_accessor(:mesh_mailbox_id) { ENV.fetch("MESH_MAILBOX_ID", "?") }
    config_accessor(:mesh_mailbox_password) { ENV.fetch("MESH_MAILBOX_PASSWORD", "?") }
    config_accessor(:mesh_api_base_url) {
      # This default is the Integration environment
      ENV.fetch("MESH_API_BASE_URL", "https://msg.intspineservices.nhs.uk/messageexchange")
    }
    config_accessor(:mesh_api_secret) { ENV.fetch("MESH_API_SECRET", "?") }
    config_accessor(:mesh_use_endpoint_lookup) {
      ActiveModel::Type::Boolean.new.cast(
        ENV.fetch("MESH_USE_ENDPOINT_LOOKUP", "false")
      )
    }
    config_accessor(:mesh_recipient_mailbox_id) {
      ENV.fetch("MESH_RECIPIENT_MAILBOX", "X26OT112") # X26OT112 is in the NHS INT env
    }
    config_accessor(:mesh_workflow_id) {
      {
        gp_connect: "GPCONNECT_SEND_DOCUMENT",
        transfer_of_care: "TOC_FHIR_OP_ATTEN"
      }[letters_mesh_workflow]
    }
    config_accessor(:mesh_path_to_nhs_ca_file)    { ENV.fetch("MESH_PATH_TO_NHS_CA_FILE", "??") }
    config_accessor(:mesh_nhs_ca_cert)            { ENV.fetch("MESH_NHS_CA_CERT", "??") }
    config_accessor(:mesh_path_to_client_cert)    { ENV.fetch("MESH_PATH_TO_CLIENT_CERT", "??") }
    config_accessor(:mesh_client_cert)            { ENV.fetch("MESH_CLIENT_CERT", "") }
    config_accessor(:mesh_path_to_client_key)     { ENV.fetch("MESH_PATH_TO_CLIENT_KEY", "??") }
    config_accessor(:mesh_client_key)             { ENV.fetch("MESH_CLIENT_KEY", "") }
    config_accessor(:mesh_organisation_uuid)      { ENV.fetch("MESH_ORGANISATION_UUID", "??") }
    config_accessor(:mesh_itk_organisation_uuid)  { ENV.fetch("MESH_ORGANISATION_UUID", "??") }
    config_accessor(:mesh_organisation_ods_code)  { ENV.fetch("MESH_ORGANISATION_ODS_CODE", "??") }
    config_accessor(:mesh_practitioner_phone)     { ENV.fetch("MESH_PRACTITIONER_PHONE", "??") }
    config_accessor(:mesh_organisation_phone)     { ENV.fetch("MESH_ORGANISATION_PHONE", "??") }
    config_accessor(:mesh_organisation_email)     { ENV.fetch("MESH_ORGANISATION_EMAIL", "??") }
    config_accessor(:mesh_organisation_name)      { ENV.fetch("MESH_ORGANISATION_NAME", "??") }

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

    # If true, we use a cron-scheduled good_job to poll the renalware.feed_raw_hl7_messages table
    # for new incoming messages (most likely inserted by Mirth) and spin each off as a new
    # active job. Because we currently load the good_job cron config in engine.rb,
    # the host app cannot seem to override this config setting in eg a renalware_core.rb initializer
    # and instead we use an ENV var here. This might be solvable by using an after
    # hook during initialisation etc; it is likely I do not understand the nuances of initialisation
    # order sufficiently, but I been unable so far to get GoodJob to honour cron config
    # unless it is set in the early stagings of app initialisation.
    # We default to false because this is an opt-in approach we want sites to migrate to.
    config_accessor(:process_hl7_via_raw_messages_table) {
      ENV.fetch("PROCESS_HL7_VIA_RAW_MESSAGES_TABLE", "false") == "true"
    }

    config_accessor(:replay_historical_pathology_when_new_patient_added) {
      ActiveModel::Type::Boolean.new.cast(
        ENV.fetch("REPLAY_HISTORICAL_PATHOLOGY_WHEN_NEW_PATIENT_ADDED", "true")
      )
    }

    config_accessor(:hd_session_prescriptions_require_signoff) { true }
    config_accessor(:hd_session_require_patient_group_directions) {
      ActiveModel::Type::Boolean.new.cast(
        ENV.fetch("HD_SESSION_REQUIRE_PATIENT_GROUP_DIRECTIONS", "false")
      )
    }

    # How many days ahead to look for prescriptions having a future prescribed_on date when
    # determining which 'give on hd' prescriptions to show on the HD session form. Could be eg 10
    # if session forms are printed on a Friday for the following week, in which case 10 days
    # would find future HD prescriptions due to be given and time until a week Sunday.
    # However if printing HD session forms each day, then a value of eg 3 would be better.
    config_accessor(:hd_session_form_prescription_days_lookahead) {
      ActiveModel::Type::Integer.new.cast(
        ENV.fetch("HD_SESSION_FORM_PRESCRIPTION_DAYS_LOOKAHEAD", 10)
      ) || 10
    }
    config_accessor(:batch_printing_enabled) { true }
    config_accessor(:allow_uploading_patient_attachments) { true }
    config_accessor(:generate_pathology_request_forms_from_hd_mdm_listing) { true }
    config_accessor(:disable_inputs_controlled_by_tissue_typing_feed) { false }
    config_accessor(:disable_inputs_controlled_by_demographics_feed) { false }
    config_accessor(:enforce_user_prescriber_flag) {
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("ENFORCE_USER_PRESCRIBER_FLAG", "false"))
    }
    config_accessor(:allow_modality_history_amendments) {
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("ALLOW_MODALITY_HISTORY_AMENDMENTS", "false"))
    }
    config_accessor(:auto_terminate_hd_prescriptions_after_period) { 6.months }
    config_accessor(:auto_terminate_hd_stat_prescriptions_after_period) { 14.days }
    config_accessor(:medication_delivery_purchase_order_prefix) { "R" }
    config_accessor(:medication_homecare_pdf_forms) do
      # esa: { provider: :generic, version: 1 },
      {
        immunosuppressant: { provider: :generic, version: 1 }
      }
    end

    config_accessor(:user_dashboard_display_named_patients) { true }
    config_accessor(:medication_review_max_age_in_months) { 24 }

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
    # Note
    # - NS = Not Stated
    # - NK = Not Known
    config_accessor(:hl7_pid_sex_map) do
      {
        "MALE" => "M",
        "FEMALE" => "F",
        "OTHER" => "NS",
        "UNKNOWN" => "NK",
        "NOTKNOWN" => "NK",
        "INDETERMINATE" => "NK",
        "AMBIGUOUS" => "NS",
        "NOT APPLICABLE" => "NS",
        "BOTH" => "NS"
      }.freeze
    end
    config_accessor(:max_file_upload_size) { ENV.fetch("MAX_FILE_UPLOAD_SIZE", "10_000_000").to_i }

    # Sentry configuration
    config_accessor(:sentry_dsn) { ENV.fetch("SENTRY_DSN", "") }
    config_accessor(:sentry_for_js_enabled) { false }
    config_accessor(:sentry_profiles_sample_rate) do
      ActiveModel::Type::Integer.new.cast(ENV.fetch("SENTRY_PROFILES_SAMPLE_RATE", 1.0))
    end
    config_accessor(:sentry_traces_sample_rate) do
      ActiveModel::Type::Integer.new.cast(ENV.fetch("SENTRY_TRACES_SAMPLE_RATE", 1.0))
    end

    # :simple or :dob_and_any_nhs_or_assigning_auth_number or nhs_or_any_assigning_auth_number
    config_accessor(:hl7_patient_locator_strategy) {
      {
        oru: :simple,
        adt: :simple
      }
    }
    config_accessor(:demo_password) { "renalware" }
    config_accessor(:password_policy_description) { "Passwords must be at least 8 characters" }

    # The warning to display to IE users, because we want to dissuade users from
    # using IE11. If you set this to nil the warning will not be shown
    config_accessor(:ie_deprecation_warning) {
      "Internet Explorer is no longer fully supported. Please use Edge, Chrome or Firefox"
    }

    config_accessor(:patients_must_have_at_least_one_hosp_number) { true }
    config_accessor(:only_admins_can_update_pkb_renalreg_preferences) { false }

    config_accessor(:pathology_hep_b_antibody_status_obx_code) {
      ENV.fetch("PATHOLOGY_HEP_B_ANTIBODY_STATUS_OBX_CODE", "BHBS")
    }
    config_accessor(:pathology_post_hd_urea_code) { "P_URE" }
    config_accessor(:pathology_hours_to_search_behind_for_pre_ure_result) {
      ENV.fetch("PATHOLOGY_HOURS_TO_SEARCH_BEHIND_FOR_PRE_URE_RESULT", "6").to_i
    }
    config_accessor(:pathology_hours_to_search_ahead_for_pre_ure_result) {
      ENV.fetch("PATHOLOGY_HOURS_TO_SEARCH_AHEAD_FOR_PRE_URE_RESULT", "4").to_i
    }
    config_accessor(:pathology_acr_obx_code_for_kfre_calculation) { "ACR" }
    config_accessor(:pathology_kfre_2y_obx_code) { "KFRE2" }
    config_accessor(:pathology_kfre_5y_obx_code) { "KFRE5" }
    config_accessor(:pathology_kfre_obr_code) { "KFRE" }

    config_accessor(:igan_prediction_tool_title) {
      ENV.fetch("IGAN_PREDICTION_TOOL_TITLE", "IgAN Prediction Tool")
    }
    config_accessor(:igan_prediction_tool_url) {
      ENV.fetch(
        "IGAN_PREDICTION_TOOL_URL",
        "https://qxmd.com/calculate/calculator_499/international-igan-prediction-tool-at-biopsy-adults"
      )
    }

    config_accessor(:patient_visibility_restrictions) { :none }

    #
    # Microsoft OAuth email authentication config
    #
    config_accessor(:mail_oauth_client_id) { ENV.fetch("MAIL_OAUTH_CLIENT_ID", nil) }
    config_accessor(:mail_oauth_client_secret) { ENV.fetch("MAIL_OAUTH_CLIENT_SECRET", nil) }
    config_accessor(:mail_oauth_tenant_id) { ENV.fetch("MAIL_OAUTH_TENANT_ID", nil) }
    config_accessor(:mail_oauth_email_address) { ENV.fetch("MAIL_OAUTH_EMAIL_ADDRESS", nil) }

    def restrict_patient_visibility_by_user_site?
      [:by_site, :by_site_and_research_study].include?(patient_visibility_restrictions)
    end

    def restrict_patient_visibility_by_research_study?
      patient_visibility_restrictions == :by_site_and_research_study
    end
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield config
  end
end
# rubocop:enable Layout/LineLength
