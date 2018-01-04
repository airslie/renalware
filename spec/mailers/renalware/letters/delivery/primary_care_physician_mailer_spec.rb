require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Delivery::PrimaryCarePhysicianMailer, type: :mailer do
      subject(:mail) { described_class.patient_letter(letter, letter.main_recipient) }

      describe "patient_letter" do
        let(:practice) { create(:practice, email: "#{SecureRandom.hex(10)}@example.com") }
        let(:gp) { create(:letter_primary_care_physician, practices: [practice]) }
        let(:patient) do
          create(
            :letter_patient,
            primary_care_physician: gp,
            practice: practice
          )
        end
        let(:user) { create(:user) }
        let(:letter) do
          build(:approved_letter, patient: patient, by: user).tap do |letter|
            letter.build_main_recipient(person_role: :primary_care_physician, addressee: gp)
            letter.save!
          end
        end
        let(:fake_pdf){ "%PDF-1.4\n1" }

        before do
          allow(PdfLetterCache).to receive(:fetch).and_return(fake_pdf)
        end

        describe "error checking" do
          it "raises an error if no recipient object is missing the addressee (ie has not been "\
             "assigned the primary_care_physician)" do
            letter.main_recipient.update!(addressee: nil)

            expect{
              mail.subject
            }.to raise_error(Delivery::LetterRecipientMissingAddresseeError)
          end

          it "raises an error if the recipient is not a primary_care_physician" do
            letter.main_recipient.update!(addressee: patient)

            expect{
              mail.subject
            }.to raise_error(Delivery::AddresseeIsNotAPrimaryCarePhysicianError)
          end

          it "raises an error if primary_care_physician does not belong to patient's practice" do
            patient.update!(practice: create(:practice), by: user)

            expect{
              mail.subject
            }.to raise_error(Delivery::PrimaryCarePhysicianDoesNotBelongToPatientsPracticeError)
          end
        end

        it "renders the headers" do
          expect(mail.subject).to eq("Test")
          expect(mail.to).to eq([practice.email])
          expect(mail.from).to eq([Renalware.config.default_from_email])
        end

        it "renders the body" do
          expect(mail.body.encoded).to match("<IDENT>")
        end

        it "has a pdf letter attachment" do
          expect(mail.attachments.count).to eq(1)
          attachment = mail.attachments.first
          expect(attachment).to be_a_kind_of(Mail::Part)
          expect(attachment.content_type).to match("application/pdf")
          expect(attachment.filename).to eq("letter.pdf")
        end
      end
    end
  end
end
