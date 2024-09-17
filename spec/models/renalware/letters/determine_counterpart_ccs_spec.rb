# frozen_string_literal: true

module Renalware
  module Letters
    describe DetermineCounterpartCCs do
      include LettersSpecHelper

      subject(:service) { described_class.new(letter) }

      let(:patient) { build(:letter_patient) }

      describe "#call" do
        context "when the recipient is the patient" do
          let(:letter) { build_letter(to: :patient, patient: patient) }

          it "determines the primary_care_physician as a CC recipient" do
            cc_recipients = service.call
            expect(cc_recipients.size).to eq(1)
            expect(cc_recipients.first.person_role).to eq("primary_care_physician")
          end
        end

        context "when the recipient is the Primary Care Physician" do
          let(:letter) { build_letter(to: :primary_care_physician, patient: patient) }

          context "when the patient opted to be CCd on all letters" do
            before do
              allow(letter.patient).to receive(:cc_on_letter?).and_return(true)
            end

            it "determines the patient as a CC recipient" do
              cc_recipients = service.call

              expect(cc_recipients.size).to eq(1)
              expect(cc_recipients.first.person_role).to eq("patient")
            end
          end

          context "when the patient did not opt to be CCd on all letters" do
            before do
              allow(letter.patient).to receive(:cc_on_letter?).and_return(false)
            end

            it "does not determine the patient as a CC recipient" do
              cc_recipients = service.call

              expect(cc_recipients).to be_empty
            end
          end
        end

        context "when the recipient is someone else" do
          let(:letter) { build_letter(to: :contact, patient: patient) }

          context "when the patient opted to be CCd on all letters" do
            before do
              letter.patient.cc_on_all_letters = true
            end

            it "determines the patient and the Primary Care Physician as CC recipients" do
              cc_recipients = service.call

              expect(cc_recipients.size).to eq(2)
              person_roles = cc_recipients.map(&:person_role)
              expect(person_roles).to include("patient")
              expect(person_roles).to include("primary_care_physician")
            end
          end
        end
      end
    end
  end
end
