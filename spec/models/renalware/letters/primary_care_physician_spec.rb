# frozen_string_literal: true

module Renalware
  module Letters
    describe PrimaryCarePhysician do
      include LettersSpecHelper

      subject(:primary_care_physician) { build(:letter_primary_care_physician) }

      it { is_expected.not_to validate_presence_of(:given_name) }

      describe "#cc_on_letter?" do
        context "when the Primary Care Physician is assigned to the patient" do
          let(:patient) { build(:letter_patient, primary_care_physician: primary_care_physician) }

          context "when the patient is the main recipient" do
            let(:letter) { build_letter(to: :patient, patient: patient) }

            it { expect(primary_care_physician).to be_cc_on_letter(letter) }
          end

          context "when the Primary Care Physician is the main recipient" do
            let(:letter) { build_letter(to: :primary_care_physician, patient: patient) }

            it { expect(primary_care_physician).not_to be_cc_on_letter(letter) }
          end

          context "when someone else is the main recipient" do
            let(:letter) { build_letter(to: :contact, patient: patient) }

            it { expect(primary_care_physician).to be_cc_on_letter(letter) }
          end
        end

        context "when the patient is assigned to another Primary Care Physician" do
          let(:other_primary_care_physician) { build(:letter_primary_care_physician) }
          let(:patient) do
            build(:letter_patient, primary_care_physician: other_primary_care_physician)
          end
          let(:letter) { build_letter(to: :patient, patient: patient) }

          it { expect(primary_care_physician).not_to be_cc_on_letter(letter) }
        end
      end
    end
  end
end
