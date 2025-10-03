# frozen_string_literal: true

module Renalware
  RSpec.describe RemoteMonitoring::RegistrationDetail do
    subject { described_class.new(record) }

    let(:record) { build(:remote_monitoring_registration) }

    it "renders component" do
      expect(fragment.text).to include("Referral reason:Not specified")
      expect(fragment.text).to include("Monitoring frequency:4 months")
      expect(fragment.text).to include("Baseline creatinine:Not specified")
    end
  end
end
