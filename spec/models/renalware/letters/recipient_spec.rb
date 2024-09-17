# frozen_string_literal: true

module Renalware
  module Letters
    describe Recipient do
      it :aggregate_failures do
        is_expected.to respond_to(:emailed_at)
        is_expected.to respond_to(:printed_at)
      end

      describe ".printable_recipients_for" do
        it "excludes the gp if gp_send_status = success" do
          letter = Letter::Approved.new(gp_send_status: :success)
          patient = build(:letter_recipient, person_role: :patient)
          gp = build(:letter_recipient, person_role: :primary_care_physician)
          letter.main_recipient = patient
          letter.cc_recipients = [gp]

          expect(
            described_class.printable_recipients_for(letter).map(&:person_role)
          ).to eq([:patient])
        end

        Renalware::Letters::Letter.gp_send_statuses.keys
          .map(&:to_sym)
          .reject { |status| status == :success }
          .each do |status|
          it "includes the gp when gp_send_status = #{status}" do
            letter = Letter::Approved.new(gp_send_status: status)
            patient = build(:letter_recipient, person_role: :patient, letter: letter)
            gp = build(:letter_recipient, person_role: :primary_care_physician, letter: letter)
            letter.main_recipient = patient
            letter.cc_recipients = [gp]

            expect(
              described_class.printable_recipients_for(letter).map(&:person_role)
            ).to eq([:patient, :primary_care_physician])
          end
        end
      end

      describe "primary_care_physician?" do
        context "when person_role = primary_care_physician" do
          subject do
            described_class.new(person_role: :primary_care_physician).primary_care_physician?
          end

          it { is_expected.to be(true) }
        end

        context "when person_role = patient" do
          subject { described_class.new(person_role: :patient).primary_care_physician? }

          it { is_expected.to be(false) }
        end

        context "when person_role = contact" do
          subject { described_class.new(person_role: :contact).primary_care_physician? }

          it { is_expected.to be(false) }
        end
      end

      describe "#addressee_id" do
        describe "validation" do
          it "validates presence if person is a contact" do
            recipient = described_class.new(person_role: "contact")
            expect(recipient).to validate_presence_of(:addressee_id)
          end

          it "validates presence of person_role" do
            recipient = described_class.new(person_role: nil)

            recipient.save

            expect(recipient.errors[:base]).to include("Please select a main recipient")
          end
        end
      end
    end
  end
end
