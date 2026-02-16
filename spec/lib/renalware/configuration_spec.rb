describe Renalware::Configuration do
  subject(:config) { described_class.new }

  around do |example|
    # Ensure ENV vars in .env and demo/.env do not upset testing the defaults
    env_keys_that_override_defaults = %w(
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
end
