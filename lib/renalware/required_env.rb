module Renalware
  # Since Renalware is totally ENV-driven, it becomes important to test that,
  # if we really are running in a production environment,
  # key configuration values (like the map that determines which
  # local_patient_id* maps to which assigning authority) are present,
  # otherwise we should refuse to boot because there is the possibility for
  # example that we might fail to ingest incoming if that mapping is
  # missing.
  # Note we only validate ENV vars if RENALWARE_STAGE is set to production.
  # We don't use RAILS_ENV=production because that could be in true
  # in UAT and demo environments, or anytime the docker image is started.
  module RequiredEnv
    PRODUCTION_STAGE = "production".freeze
    REQUIRED_IN_PRODUCTION = %w(
      PATIENT_HOSPITAL_IDENTIFIERS
      SECRET_KEY_BASE
      HL7_PID_SEX_MAP
    ).freeze

    module_function

    def validate!
      return unless production_stage?

      missing_keys = REQUIRED_IN_PRODUCTION.select { |key| ENV[key].blank? }
      return if missing_keys.empty?

      raise(
        KeyError,
        "Missing required ENV vars for RENALWARE_STAGE=production: #{missing_keys.join(', ')}"
      )
    end

    def production_stage?
      Renalware.stage.production?
    end
  end
end
