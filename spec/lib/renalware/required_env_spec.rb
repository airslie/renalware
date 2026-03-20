RSpec.describe Renalware::RequiredEnv do
  around do |example|
    keys = described_class::REQUIRED_IN_PRODUCTION + ["RENALWARE_STAGE"]
    original_values = keys.index_with { |key| ENV.fetch(key, nil) }

    keys.each { |key| ENV.delete(key) }

    example.run
  ensure
    original_values.each do |key, value|
      value.nil? ? ENV.delete(key) : ENV[key] = value
    end
  end

  describe ".validate!" do
    it "does nothing outside the production stage" do
      expect { described_class.validate! }.not_to raise_error
    end

    it "does nothing when all required env vars are present in production stage" do
      ENV["RENALWARE_STAGE"] = "production"
      described_class::REQUIRED_IN_PRODUCTION.each { |key| ENV[key] = "configured" }

      expect { described_class.validate! }.not_to raise_error
    end

    it "raises when required env vars are missing in production stage" do
      ENV["RENALWARE_STAGE"] = "production"
      ENV["SECRET_KEY_BASE"] = "configured"

      expect { described_class.validate! }
        .to raise_error(
          KeyError,
          "Missing required ENV vars for RENALWARE_STAGE=production: " \
          "PATIENT_HOSPITAL_IDENTIFIERS, HL7_PID_SEX_MAP"
        )
    end

    it "treats blank env vars as missing in production stage" do
      ENV["RENALWARE_STAGE"] = "production"
      described_class::REQUIRED_IN_PRODUCTION.each { |key| ENV[key] = "configured" }
      ENV["HL7_PID_SEX_MAP"] = " "

      expect { described_class.validate! }
        .to raise_error(
          KeyError,
          "Missing required ENV vars for RENALWARE_STAGE=production: HL7_PID_SEX_MAP"
        )
    end
  end
end
