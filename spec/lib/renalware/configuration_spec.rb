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

  describe "#defaults" do
    it do
      expect(config).to have_attributes(
        delay_after_which_a_finished_session_becomes_immutable: 6.hours,
        auto_terminate_hd_prescriptions_after_period: 6.months,
        auto_terminate_hd_stat_prescriptions_after_period: 14.days,
        patients_must_have_at_least_one_hosp_number: true,
        enable_expiring_prescriptions_list_component: true,
        enforce_user_prescriber_flag: false
      )
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

    # rubocop:disable Lint/SymbolConversion
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
    # rubocop:enable Lint/SymbolConversion
  end
end
