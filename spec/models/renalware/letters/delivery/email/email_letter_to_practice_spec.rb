module Renalware
  module Letters::Delivery::Email
    describe EmailLetterToPractice do
      let(:gp) { create(:letter_primary_care_physician) }
      let(:practice) { create(:practice, email: "practice@example.com") }
      let(:patient) do
        create(
          :letter_patient,
          primary_care_physician: gp,
          practice: practice,
          cc_on_all_letters: true
        )
      end
      let(:user) { create(:user) }
      let(:letter) do
        build(:approved_letter, patient: patient, by: user).tap do |lett|
          lett.type = lett.class.sti_name # TODO: remove hack caused by RSpec timing?
        end
      end

      before do
        ActiveJob::Base.queue_adapter = :test
        # Make sure we allow external email in these tests (though none will actually be sent)!
        # Otherwise some tests will fail because PracticeEmail.address will reslove the letter
        # updating user's address or fall-back test address used during testing.
        Renalware.configure { |config| config.allow_external_mail = true }
      end

      def make_gp_the_main_recipient
        gp_recipient = letter.build_main_recipient(person_role: :primary_care_physician)
        letter.save!
        gp_recipient
      end

      def add_gp_as_cc
        gp_recipient = letter.recipients.build(
          role: :cc,
          person_role: :primary_care_physician,
          addressee: gp
        )
        letter.save!
        gp_recipient
      end

      def add_patient_as_cc
        patient_recipient = letter.recipients.build(
          role: :cc,
          person_role: :patient,
          addressee: patient
        )
        letter.save!
        patient_recipient
      end

      def stub_practice_mailer(letter:, to:)
        message_delivery = instance_double(ActionMailer::MessageDelivery, deliver_later: nil)
        allow(PracticeMailer)
          .to receive(:patient_letter).with(letter: letter.becomes(Letters::Letter), to: to)
          .and_return(message_delivery)
        message_delivery
      end

      describe "#call" do
        context "when there are no recipients" do
          it "sends nothing out" do
            expect {
              described_class.new(letter: letter).call
            }.not_to have_enqueued_job.on_queue("mailers")
          end
        end

        context "when the gp is the main_recipient and the patient is cc'd" do
          it "emails the gp" do
            make_gp_the_main_recipient

            message_delivery = stub_practice_mailer(
              letter: letter,
              to: "practice@example.com"
            )

            described_class.new(letter: letter.becomes(Renalware::Letters::Letter)).call

            expect(message_delivery).to have_received(:deliver_later)
          end

          it "sets the emailed_at datetime on the recipient" do
            gp_recipient = make_gp_the_main_recipient

            date = Time.zone.parse("2017-11-24 01:04:44")
            travel_to(date) do
              described_class.new(letter: letter).call
              expect(gp_recipient.reload.emailed_at).to eq(date)
            end
          end
        end

        context "when the patient is the main_recipient and the gp is cc'd" do
          it "emails the gp and snail-mails the patient" do
            letter.build_main_recipient(person_role: :patient)
            add_gp_as_cc

            # Using a different way of testing the enqueueing here, to create extra coverage
            expect {
              described_class.new(letter: letter).call
            }.to have_enqueued_job
          end
        end
      end
    end
  end
end
