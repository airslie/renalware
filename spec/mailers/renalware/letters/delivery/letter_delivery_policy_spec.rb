# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Delivery::DeliveryPolicy do
      subject(:policy) { described_class.new(letter) }

      let(:user) { build_stubbed(:user) }
      let(:letter) { build_stubbed(:letter, patient: patient, by: user) }
      let(:patient) { build_stubbed(:letter_patient) }
      let(:gp) { build_stubbed(:letter_primary_care_physician) }

      # Make sure we allow external email in these tests (though none will actually be sent)!
      # Otherwise some tests will fail because PracticeEmail.address will reslove the letter
      # updating user's address or fallback test address used during testing.
      before { Renalware.configure { |config| config.allow_external_mail = true } }

      describe ".email_letter_to_practice?" do
        subject{ policy.email_letter_to_practice? }

        context "when the gp is not a recipient" do
          before { letter.recipients = [] }

          it { is_expected.to be_falsey }
        end

        context "when the gp is a recipient" do
          before { letter.recipients.build(person_role: :primary_care_physician) }

          it "sanity check" do
            expect(letter.recipients.find(&:primary_care_physician?)).not_to be_nil
          end

          context "when the patient has no practice" do
            let(:patient) { build_stubbed(:letter_patient) }

            it { is_expected.to be_falsey }
          end

          context "when the patient has a gp but no practice" do
            let(:patient) { build_stubbed(:letter_patient, primary_care_physician: gp) }

            it { is_expected.to be_falsey }
          end

          context "when the patient has a practice without an email address" do
            let(:practice) { build_stubbed(:practice, email: "") }
            let(:patient) { build_stubbed(:letter_patient, practice: practice) }

            it { is_expected.to be_falsey }
          end

          context "when the patient has a practice with an email address" do
            let(:practice) { build_stubbed(:practice, email: "practice@example.com") }
            let(:patient) { build_stubbed(:letter_patient, practice: practice) }

            it { is_expected.to eq(true) }
          end
        end
      end

      # describe ".other_recipients" do
      #   context "when the gp is a recipient but we are not sending the practice an email" do
      #     before { letter.recipients.build(person_role: :primary_care_physician) }
      #     before { allow(policy).to receive(:email_letter_to_practice?).and_return(false) }

      #     it "includes the gp in other_recipients" do
      #       expect(policy.other_recipients.find(&:primary_care_physician?)).to eq(true)
      #     end
      #   end

      #   context "when the gp is a recipient and we are sending the practice an email" do
      #     before { letter.recipients.build(person_role: :primary_care_physician) }
      #     before { allow(policy).to receive(:email_letter_to_practice?).and_return(true) }

      #     it "does not include the gp in other_recipients" do
      #       expect(policy.other_recipients.find(&:primary_care_physician?)).to be_falsey
      #     end
      #   end
      # end
    end
  end
end
