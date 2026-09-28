describe Renalware::Configuration do
  subject(:config) { described_class.new }

  around do |example|
    # Ensure ENV vars in .env and demo/.env do not upset testing the defaults
    env_keys_that_override_defaults = %w(
      AUTHENTICATION_PROVIDERS
      DELAY_AFTER_WHICH_A_FINISHED_SESSION_BECOMES_IMMUTABLE_HOURS
      AUTO_TERMINATE_HD_PRESCRIPTIONS_AFTER_PERIOD
      AUTO_TERMINATE_HD_STAT_PRESCRIPTIONS_AFTER_PERIOD
      PATIENTS_MUST_HAVE_AT_LEAST_ONE_HOSP_NUMBER
      ENABLE_EXPIRING_PRESCRIPTIONS_LIST_COMPONENT
      ENFORCE_USER_PRESCRIBER_FLAG
      DEVISE_EXTRA_MODULES
      PATIENT_HOSPITAL_IDENTIFIERS
      PATIENT_VISIBILITY_RESTRICTIONS
      URR_GENERATION_ENABLED
      DISPLAY_NHSBT_WAIT_LIST_UPLOAD
      BYPASS_RAW_HL7_PROCESSING_ADVISORY_LOCK
      FEEDS_OUTGOING_DOCUMENTS_SENDING_FACILITY
      MESH_CARE_SETTING_SNOMED_CODE
      MESH_CARE_SETTING_DESCRIPTION
      LETTERS_EXTERNAL_DOCUMENT_TYPE_CODE
      LETTERS_EXTERNAL_DOCUMENT_TYPE_DESCRIPTION
      OUTPATIENT_PRESCRIPTION_ADMINISTRATION_ENABLED
      HEIDI_ENABLED
      HEIDI_API_BASE_URL
      HEIDI_SCRIBE_SESSION_BASE_URL
      HEIDI_LINK_ACCOUNT_URL
      HEIDI_REGION
      HELP_USER_GUIDE_LINK
    )
    original_values = env_keys_that_override_defaults.index_with { |key| ENV.fetch(key, nil) }
    env_keys_that_override_defaults.each { |key| ENV.delete(key) }

    example.run
  ensure
    original_values.each do |key, value|
      value.nil? ? ENV.delete(key) : ENV[key] = value
    end
  end

  it "raises an error if a certain config value is not defined" do
    expect { config.missing_value }.to raise_error(NoMethodError)
  end

  describe ".config_defaults" do
    it "includes accessors registered by split configuration modules" do
      expect(described_class.config_defaults.keys).to include(
        :authentication_providers,
        :clinical_duke_activity_status_index_url,
        :clinical_summary_max_events_to_display,
        :clinic_name_code_separator,
        :bypass_raw_hl7_processing_advisory_lock,
        :devise_extra_modules,
        :feeds_outgoing_documents_enabled,
        :feeds_outgoing_documents_sending_facility,
        :hd_session_form_prescription_days_lookahead,
        :hd_session_prescriptions_require_signoff,
        :help_user_guide_link,
        :letters_external_document_type_code,
        :letters_external_document_type_description,
        :letters_render_pdfs_with_prawn,
        :mail_delivery_method,
        :medication_delivery_purchase_order_prefix,
        :medication_review_max_age_in_months,
        :messaging_recipient_warn_if_not_signed_in_for_days,
        :mesh_care_setting_description,
        :mesh_care_setting_snomed_code,
        :mesh_mailbox_id,
        :new_clinic_visit_deletion_window,
        :new_clinic_visit_edit_window,
        :pathology_post_hd_urea_code,
        :process_hl7_via_raw_messages_table,
        :replay_historical_pathology_when_new_patient_added,
        :sendgrid_api_key,
        :ukrdc_enabled
      )
    end
  end

  describe "#defaults" do
    it do
      expect(config).to have_attributes(
        delay_after_which_a_finished_session_becomes_immutable: 6.hours,
        auto_terminate_hd_prescriptions_after_period: 6.months,
        auto_terminate_hd_stat_prescriptions_after_period: 14.days,
        patients_must_have_at_least_one_hosp_number: true,
        enable_expiring_prescriptions_list_component: true,
        display_nhsbt_wait_list_upload: true,
        enforce_user_prescriber_flag: false,
        letters_external_document_type_code: nil,
        letters_external_document_type_description: nil,
        outpatient_prescription_administration_enabled: true,
        heidi_enabled: true,
        heidi_api_base_url: "https://registrar.api.heidihealth.com/api/v2/ml-scribe/open-api/",
        heidi_scribe_session_base_url: "https://registrar.scribe.heidihealth.com/scribe/session/",
        heidi_link_account_url: "https://registrar.scribe.heidihealth.com/integration/widget/auth",
        heidi_region: "AU",
        help_user_guide_link: "https://docs.renalware.com/user-guide",
        mesh_care_setting_snomed_code: "788003006",
        mesh_care_setting_description: "Nephrology service"
      )
    end

    it "can override the user guide URL from ENV" do
      ENV["HELP_USER_GUIDE_LINK"] = "https://example.test/user-guide"

      expect(config.help_user_guide_link).to eq("https://example.test/user-guide")
    end

    it "can enable Heidi from ENV" do
      ENV["HEIDI_ENABLED"] = "true"

      expect(config.heidi_enabled).to be(true)
    end

    it "can configure Heidi URLs from ENV" do
      ENV["HEIDI_API_BASE_URL"] = "https://example.test/api/"
      ENV["HEIDI_SCRIBE_SESSION_BASE_URL"] = "https://scribe.example.test/session/"
      ENV["HEIDI_LINK_ACCOUNT_URL"] = "https://scribe.example.test/auth"
      ENV["HEIDI_REGION"] = "UK"

      expect(config).to have_attributes(
        heidi_api_base_url: "https://example.test/api/",
        heidi_scribe_session_base_url: "https://scribe.example.test/session/",
        heidi_link_account_url: "https://scribe.example.test/auth",
        heidi_region: "UK"
      )
    end

    it "can disable outpatient prescription administration from ENV" do
      ENV["OUTPATIENT_PRESCRIPTION_ADMINISTRATION_ENABLED"] = "false"

      expect(config.outpatient_prescription_administration_enabled).to be(false)
    end
  end

  describe "#letters_external_document_type_code" do
    it "can be configured via ENV" do
      ENV["LETTERS_EXTERNAL_DOCUMENT_TYPE_CODE"] = "CL"

      expect(config.letters_external_document_type_code).to eq("CL")
    end

    it "treats a blank ENV value as unconfigured" do
      ENV["LETTERS_EXTERNAL_DOCUMENT_TYPE_CODE"] = ""

      expect(config.letters_external_document_type_code).to be_nil
    end
  end

  describe "#letters_external_document_type_description" do
    it "can be configured via ENV" do
      ENV["LETTERS_EXTERNAL_DOCUMENT_TYPE_DESCRIPTION"] = "Clinical Letter"

      expect(config.letters_external_document_type_description).to eq("Clinical Letter")
    end

    it "treats a blank ENV value as unconfigured" do
      ENV["LETTERS_EXTERNAL_DOCUMENT_TYPE_DESCRIPTION"] = ""

      expect(config.letters_external_document_type_description).to be_nil
    end
  end

  describe "#auto_terminate_hd_prescriptions_after_period" do
    it "can be disabled via ENV with a zero duration" do
      ENV["AUTO_TERMINATE_HD_PRESCRIPTIONS_AFTER_PERIOD"] = "P0D"

      expect(config.auto_terminate_hd_prescriptions_after_period).to be_nil
    end

    it "can be disabled via ENV with a blank value" do
      ENV["AUTO_TERMINATE_HD_PRESCRIPTIONS_AFTER_PERIOD"] = ""

      expect(config.auto_terminate_hd_prescriptions_after_period).to be_nil
    end
  end

  describe "#auto_terminate_hd_stat_prescriptions_after_period" do
    it "can be disabled via ENV with a zero duration" do
      ENV["AUTO_TERMINATE_HD_STAT_PRESCRIPTIONS_AFTER_PERIOD"] = "P0D"

      expect(config.auto_terminate_hd_stat_prescriptions_after_period).to be_nil
    end

    it "can be disabled via ENV with a blank value" do
      ENV["AUTO_TERMINATE_HD_STAT_PRESCRIPTIONS_AFTER_PERIOD"] = ""

      expect(config.auto_terminate_hd_stat_prescriptions_after_period).to be_nil
    end
  end

  describe "#devise_extra_modules" do
    it "defaults to empty" do
      expect(config.devise_extra_modules).to eq([])
    end

    it "can be set via ENV" do
      ENV["DEVISE_EXTRA_MODULES"] = "module1,module2"
      expect(config.devise_extra_modules).to eq([:module1, :module2])
    end
  end

  describe "#authentication_providers" do
    it "defaults to database authentication when no auth ENV is set" do
      expect(config.authentication_providers).to eq([:database])
      expect(config.database_authentication_enabled?).to be(true)
      expect(config.ldap_authentication_enabled?).to be(false)
      expect(config.entra_authentication_enabled?).to be(false)
    end

    it "allows multiple providers to be configured explicitly" do
      ENV["AUTHENTICATION_PROVIDERS"] = "database, ldap, entra_id"

      expect(config.authentication_providers).to eq([:database, :ldap, :entra_id])
      expect(config.database_authentication_enabled?).to be(true)
      expect(config.ldap_authentication_enabled?).to be(true)
      expect(config.entra_authentication_enabled?).to be(true)
    end
  end

  describe "#patient_hospital_identifiers" do
    it "uses defaults when ENV is not present" do
      expect(config.patient_hospital_identifiers).to include(
        Dover: :local_patient_id,
        White: :local_patient_id_2
      )
    end

    it "parses a double-encoded JSON value from ENV" do
      ENV["PATIENT_HOSPITAL_IDENTIFIERS"] =
        "{\"Dover\": \"local_patient_id\",\"White\": \"local_patient_id_2\"}".to_json

      expect(config.patient_hospital_identifiers).to eq(
        Dover: :local_patient_id,
        White: :local_patient_id_2
      )
    end
  end

  describe "#hl7_pid_sex_map" do
    context "when ENV variable is not set" do
      it "defaults to the expected map" do
        ENV["HL7_PID_SEX_MAP"] = ""

        expect(config.hl7_pid_sex_map).to eq(
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
        )
      end
    end

    # rubocop:disable-next Lint/SymbolConversion
    context "when ENV variable is set" do
      it "uses the JSON-parsed ENV var" do
        ENV["HL7_PID_SEX_MAP"] = { "MALE": "M", "FEMALE": "F" }.to_json

        expect(config.hl7_pid_sex_map).to eq("MALE" => "M", "FEMALE" => "F")
      end

      it "handles double encoded JSON" do
        ENV["HL7_PID_SEX_MAP"] = "{\"MALE\": \"M\", \"FEMALE\": \"F\" }".to_json

        expect(config.hl7_pid_sex_map).to eq("MALE" => "M", "FEMALE" => "F")
      end
    end
  end

  describe "#urr_generation_enabled" do
    it "defaults to false" do
      expect(config.urr_generation_enabled).to be(false)
    end

    it "casts truthy ENV values to true" do
      ENV["URR_GENERATION_ENABLED"] = "1"

      expect(config.urr_generation_enabled).to be(true)
    end
  end

  describe "#display_nhsbt_wait_list_upload" do
    it "defaults to true" do
      expect(config.display_nhsbt_wait_list_upload).to be(true)
    end

    it "can be disabled via ENV" do
      ENV["DISPLAY_NHSBT_WAIT_LIST_UPLOAD"] = "false"

      expect(config.display_nhsbt_wait_list_upload).to be(false)
    end
  end

  describe "#bypass_raw_hl7_processing_advisory_lock" do
    it "defaults to false" do
      expect(config.bypass_raw_hl7_processing_advisory_lock).to be(false)
    end

    it "casts truthy ENV values to true" do
      ENV["BYPASS_RAW_HL7_PROCESSING_ADVISORY_LOCK"] = "1"

      expect(config.bypass_raw_hl7_processing_advisory_lock).to be(true)
    end
  end

  describe "#feeds_outgoing_documents_sending_facility" do
    it "defaults to MSE" do
      expect(config.feeds_outgoing_documents_sending_facility).to eq("MSE")
    end

    it "can be set via ENV" do
      ENV["FEEDS_OUTGOING_DOCUMENTS_SENDING_FACILITY"] = "RJZ"

      expect(config.feeds_outgoing_documents_sending_facility).to eq("RJZ")
    end
  end

  describe "#patient_visibility_restrictions" do
    it "defaults to :none" do
      expect(config.patient_visibility_restrictions).to eq(:none)
      expect(config.restrict_patient_visibility_by_user_site?).to be(false)
      expect(config.restrict_patient_visibility_by_research_study?).to be(false)
    end

    it "can restrict patient visibility by site" do
      ENV["PATIENT_VISIBILITY_RESTRICTIONS"] = "by_site"

      expect(config.patient_visibility_restrictions).to eq(:by_site)
      expect(config.restrict_patient_visibility_by_user_site?).to be(true)
      expect(config.restrict_patient_visibility_by_research_study?).to be(false)
    end

    it "can restrict patient visibility by site and research study" do
      ENV["PATIENT_VISIBILITY_RESTRICTIONS"] = "by_site_and_research_study"

      expect(config.patient_visibility_restrictions).to eq(:by_site_and_research_study)
      expect(config.restrict_patient_visibility_by_user_site?).to be(true)
      expect(config.restrict_patient_visibility_by_research_study?).to be(true)
    end

    it "accepts values with a leading colon" do
      ENV["PATIENT_VISIBILITY_RESTRICTIONS"] = ":by_site"

      expect(config.patient_visibility_restrictions).to eq(:by_site)
    end

    it "raises an error for unsupported values" do
      ENV["PATIENT_VISIBILITY_RESTRICTIONS"] = "unsupported"

      expect {
        config.patient_visibility_restrictions
      }.to raise_error(ArgumentError, /Invalid PATIENT_VISIBILITY_RESTRICTIONS/)
    end
  end
end
