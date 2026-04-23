RSpec.describe Renalware do
  around do |example|
    original_stage = ENV.fetch("RENALWARE_STAGE", nil)
    ENV.delete("RENALWARE_STAGE")

    example.run
  ensure
    original_stage.nil? ? ENV.delete("RENALWARE_STAGE") : ENV["RENALWARE_STAGE"] = original_stage
  end

  describe ".stage" do
    it "returns a string inquirer for the current renalware stage" do
      ENV["RENALWARE_STAGE"] = "UAT"

      expect(described_class.stage).to be_a(ActiveSupport::StringInquirer)
      expect(described_class.stage).to eq("uat")
      expect(described_class.stage).to be_uat
    end

    it "strips surrounding whitespace" do
      ENV["RENALWARE_STAGE"] = " demo "

      expect(described_class.stage).to be_demo
    end

    it "returns a blank stage when unset" do
      expect(described_class.stage).to eq("")
      expect(described_class.stage).not_to be_production
    end
  end

  describe ".stage?" do
    it "matches one of several candidate stages" do
      ENV["RENALWARE_STAGE"] = "uat"

      expect(described_class.stage?(:production, :uat, :demo)).to be(true)
    end

    it "returns false when the current stage is not included" do
      ENV["RENALWARE_STAGE"] = "demo"

      expect(described_class.stage?(:production, :uat)).to be(false)
    end
  end
end
