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
module Renalware
  class Configuration
    include ActiveSupport::Configurable

    # Force dotenv to load the .env file at this stage so we can read in the config defaults
    Dotenv::Railtie.load

    config_accessor(:site_name) { "Renalware" }
    config_accessor(:hospital_name) { ENV.fetch("HOSPITAL_NAME", "KINGS COLLEGE HOSPITAL") }
    config_accessor(:hospital_address) { ENV.fetch("HOSPITAL_ADDRESS", "") } # comma-delimited
    config_accessor(:delay_after_which_a_finished_session_becomes_immutable) { 6.hours }
    config_accessor(:new_clinic_visit_deletion_window) { 24.hours }
    config_accessor(:new_clinic_visit_edit_window) { 7.days }
    config_accessor(:salutation_prefix) { "Dear" }
    config_accessor(:page_title_spearator) { " : " }
    config_accessor(:patient_hospital_identifiers) { {} }
    config_accessor(:session_timeout_polling_frequency) { 1.minute }
    config_accessor(:duration_of_last_url_memory_after_session_expiry) { 30.minutes }
    config_accessor(:broadcast_subscription_map) { {} }
    config_accessor(:include_sunday_on_hd_diaries) { false }
    config_accessor(:clinical_summary_max_events_to_display) { 10 }
    config_accessor(:clinical_summary_max_letters_to_display) { 10 }
    # These settings are used in the construction of the IDENT metadata in letters
    config_accessor(:letter_system_name) { "Renalware" }
    config_accessor(:letter_default_care_group_name) { "RenalCareGroup" }
    config_accessor(:default_from_email) { "dev@airslie.com" }
    config_accessor(:display_feedback_banner) { ENV.key?("DISPLAY_FEEDBACK_BANNER") }
    config_accessor(:display_feedback_button_in_navbar) do
      ENV.key?("DISPLAY_FEEDBACK_BUTTON_IN_NAVBAR")
    end
    config_accessor(:default_from_email_address) { ENV["DEFAULT_FROM_EMAIL_ADDRESS"] }
    config_accessor(:phone_number_on_letters) { ENV["PHONE_NUMBER_ON_LETTERS"] }
    config_accessor(:renal_unit_on_letters) { ENV["RENAL_UNIT_ON_LETTERS"] }
    # Unless an ALLOW_EXTERNAL_MAIL key is present in .env or .env.production, mail (other than
    # password reset emails etc) will be redirected to last user to update the relevant record
    # eg the use how approved the letter.
    config_accessor(:allow_external_mail) { ENV.key?("ALLOW_EXTERNAL_MAIL") }
    config_accessor(:fallback_email_address_for_test_messages) do
      ENV["FALLBACK_EMAIL_ADDRESS_FOR_TEST_MESSAGES"]
    end
    config_accessor(:ukrdc_sending_facility_name) { ENV["UKRDC_SENDING_FACILITY_NAME"] }
    config_accessor(:ukrdc_default_changes_since_date) {
      Date.parse(ENV.fetch("UKRDC_DEFAULT_CHANGES_SINCE_DATE", "2018-01-01"))
    }
    config_accessor(:ukrdc_gpg_recipient) { ENV.fetch("UKRDC_GPG_RECIPIENT", "renalware_test") }
    config_accessor(:ukrdc_gpg_homedir) { ENV["UKRDC_GPG_HOMEDIR"] }
    config_accessor(:ukrdc_gpg_keyring) do
      ENV.fetch("UKRDC_GPG_KEYRING", Engine.root.join("config", "gpg", "renalware_test.gpg"))
    end
    config_accessor(:ukrdc_working_path) do
      ENV.fetch("UKRDC_WORKING_PATH", File.join("/var", "ukrdc"))
    end
    config_accessor(:ukrdc_site_code) { ENV.fetch("UKRDC_PREFIX", "RJZ") }
    config_accessor(:ukrdc_number_of_archived_folders_to_keep) do
      ENV.fetch("UKRDC_NUMBER_OF_ARCHIVED_FOLDERS_TO_KEEP", "3")
    end

    # To use a date other that the default changes_since date when
    # compiling pathology to send to UKRDC, you can set an ENV var as follows:
    #   UKRDC_PATHOLOGY_START_DATE=01-01-2011
    # in the .env file (or e.g. .env.production) and we will always fetch pathology
    # from this date on. It only affects pathology and not medications, letters etc.
    # It is not indented to keep this date set, but its useful if UKRDC ask for
    # a dump of historical pathology.
    config_accessor(:ukrdc_pathology_start_date) { ENV["UKRDC_PATHOLOGY_START_DATE"] }

    # We override this in some tests as a means of getting wicked_pdf to generate an HTML version
    # of the PDF so we can examine its content
    config_accessor(:render_pdf_as_html_for_debugging) { false }

    config_accessor(:hd_session_prescriptions_require_signoff) { true }
    config_accessor(:batch_printing_enabled) { true }

    # A host app can override this to add/remove/re-order the clinical summary display
    # Note these have to be strings - they mapped to constants in ClinicalSummaryPresenter.
    config_accessor(:page_layouts) {
      {
        clinical_summary: %w(
          Renalware::Problems::SummaryPart
          Renalware::Medications::SummaryPart
          Renalware::Letters::SummaryPart
          Renalware::Events::SummaryPart
          Renalware::Admissions::SummaryPart
          Renalware::Admissions::ConsultSummaryPart
          Renalware::Patients::SummaryPart
          Renalware::Patients::EQ5DSummaryPart
        )
      }
    }
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield config
  end
end
