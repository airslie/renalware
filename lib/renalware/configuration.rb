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
# rubocop:disable Metrics/ClassLength
module Renalware
  class Configuration
    include ActiveSupport::Configurable

    # Force dotenv to load the .env file at this stage so we can read in the config defaults
    Dotenv::Railtie.load

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
    config_accessor(:ukrdc_sending_facility_name) { ENV.fetch("UKRDC_SENDING_FACILITY_NAME", nil) }
    config_accessor(:ukrdc_default_changes_since_date) {
      Date.parse(ENV.fetch("UKRDC_DEFAULT_CHANGES_SINCE_DATE", "2018-01-01"))
    }
    config_accessor(:ukrdc_gpg_recipient) do
      ENV.fetch("UKRDC_GPG_RECIPIENT", "Patient View (Renal)") # or "UKRDC"
    end
    config_accessor(:ukrdc_public_key_name) do
      ENV.fetch("UKRDC_PUBLIC_KEY_NAME", "patientview.asc") # migfhtr become ukrdc.asc
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
    config_accessor(:ukrdc_sftp_host) { ENV.fetch("UKRDC_SFTP_HOST", nil) }
    config_accessor(:ukrdc_sftp_user) { ENV.fetch("UKRDC_SFTP_USER", nil) }
    config_accessor(:ukrdc_sftp_password) { ENV.fetch("UKRDC_SFTP_PASSWORD", nil) }
    config_accessor(:ukrdc_sftp_port) { ENV.fetch("UKRDC_SFTP_PORT", 2222) }
    config_accessor(:ukrdc_sftp_remote_path) { ENV.fetch("UKRDC_SFTP_REMOTE_PATH", "") }

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

    config_accessor(:hd_session_prescriptions_require_signoff) { true }
    config_accessor(:batch_printing_enabled) { true }
    config_accessor(:allow_uploading_patient_attachments) { true }
    config_accessor(:generate_pathology_request_forms_from_hd_mdm_listing) { true }
    config_accessor(:disable_inputs_controlled_by_tissue_typing_feed) { false }
    config_accessor(:disable_inputs_controlled_by_demographics_feed) { false }
    config_accessor(:enforce_user_prescriber_flag) { false }
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
    config_accessor(:sentry_sample_rate) { 1.0 }
    config_accessor(:sentry_for_js_enabled) { false }

    # :simple or :dob_and_any_nhs_or_assigning_auth_number
    config_accessor(:hl7_patient_locator_strategy) { :simple }
    config_accessor(:demo_password) { "renalware" }
    config_accessor(:password_policy_description) { "Passwords must be at least 8 characters" }

    # The warning to display to IE users, because we want to disuade users from
    # using IE11. If you set this to nil the warning will not be shown
    config_accessor(:ie_deprecation_warning) {
      "Internet Explorer is no longer fully supported. Please use Edge, Chrome or Firefox"
    }

    config_accessor(:patients_must_have_at_least_one_hosp_number) { true }

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

    # patient_visilbility_restriction_options = %i(none by_site by_site_and_research_study)

    config_accessor(:patient_visibility_restrictions) { :none }

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
# rubocop:enable Metrics/ClassLength
