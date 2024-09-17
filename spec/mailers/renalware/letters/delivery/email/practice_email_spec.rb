# frozen_string_literal: true

module Renalware
  module Letters
    describe Delivery::Email::PracticeEmail do
      subject(:email) { described_class.new(letter) }

      let(:user) { build_stubbed(:user) }
      let(:practice) { build_stubbed(:practice, email: "practice@example.com") }
      let(:patient) { build_stubbed(:letter_patient, practice: practice) }
      let(:letter) { build_stubbed(:letter, patient: patient, by: user) }

      describe ".address" do
        subject { email.address }

        context "when we are permitted to send external emails" do
          before { Renalware.configure { |config| config.allow_external_mail = true } }

          it { is_expected.to eq("practice@example.com") }
        end

        context "when we are not permitted to send external emails" do
          before { Renalware.configure { |config| config.allow_external_mail = false } }

          context "when there is a fallback test email address" do
            before do
              Renalware.configure do |config|
                config.fallback_email_address_for_test_messages = "fallback@example.com"
              end
            end

            it { is_expected.to eq("fallback@example.com") }
          end
        end
      end
    end
  end
end
