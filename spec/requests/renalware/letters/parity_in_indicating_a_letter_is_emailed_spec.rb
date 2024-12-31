module Renalware
  module Letters
    # This is an attempt to explore the two ways we have of determining if the practice will
    # get emailed - we can converge into one once the behaviour understood.
    describe "Check parity of letter displaying as emailed to GP vs the (GP) recipient " \
             "being marked having an updated emailed_at once approved." do
      include LettersSpecHelper

      around do |example|
        old_value = Renalware.config.allow_external_mail
        Renalware.config.allow_external_mail = true
        example.run
        Renalware.config.allow_external_mail = old_value
      end

      let(:email) { "x@y.com" }

      let(:practice) { create(:practice, email: email) }
      let(:primary_care_physician) { create(:letter_primary_care_physician) }
      let(:patient) do
        create(
          :letter_patient,
          primary_care_physician: primary_care_physician,
          practice: practice
        )
      end

      context "when the gp is the main recipient" do
        let(:letter) do
          create_letter(state: :pending_review, to: :primary_care_physician, patient: patient)
        end

        it "sanity checks" do
          expect(letter).to be_present
          expect(letter.patient).to be_present
          expect(patient.practice).to eq(practice)
          expect(practice.email).to eq(email)
          expect(patient.primary_care_physician).to be_present
          expect(letter.main_recipient.person_role).to eq(:primary_care_physician)
          expect(letter.state).to eq("pending_review")
          expect(letter).to be_persisted
        end

        it "PracticeEmail.address returns the practice email" do
          practice_email_address = Delivery::Email::PracticeEmail.new(letter).address

          expect(practice_email_address).to eq(email)
        end

        it "DeliveryPolicy#email_letter_to_practice? returns true" do
          policy = Delivery::Email::DeliveryPolicy.new(letter)

          expect(policy.email_letter_to_practice?).to be(true)
        end
      end

      context "when the gp is a cc" do
        let(:letter) do
          create_letter(state: :pending_review, to: :patient, patient: patient).tap do |letter|
            create(
              :letter_recipient,
              :cc,
              person_role: :primary_care_physician,
              addressee: primary_care_physician,
              letter: letter
            )
          end
        end

        it "sanity check" do
          expect(letter.main_recipient.person_role).to eq(:patient)
          expect(letter.cc_recipients.count).to eq(1)
          expect(letter.cc_recipients.first.person_role).to eq(:primary_care_physician)
        end

        it "PracticeEmail.address returns the practice email" do
          practice_email_address = Delivery::Email::PracticeEmail.new(letter).address

          expect(practice_email_address).to eq(email)
        end

        it "DeliveryPolicy#email_letter_to_practice? returns true" do
          policy = Delivery::Email::DeliveryPolicy.new(letter)

          expect(policy.email_letter_to_practice?).to be(true)
        end
      end

      context "when approved" do
        let(:user) { create(:user) }
        let(:letter) do
          let = create_letter(state: :pending_review, to: :primary_care_physician, patient: patient)
          ApproveLetter.new(let).call(by: user)
          Letter::Approved.find(let.id)
        end

        it "sanity check" do
          expect(letter).to be_approved
        end

        it "PracticeEmail.address returns the practice email" do
          practice_email_address = Delivery::Email::PracticeEmail.new(letter).address

          expect(practice_email_address).to eq(email)
        end

        it "DeliveryPolicy#email_letter_to_practice? returns true" do
          policy = Delivery::Email::DeliveryPolicy.new(letter)

          expect(policy.email_letter_to_practice?).to be(true)
        end
      end

      context "when practice email is blank" do
        let(:email) { nil }

        context "when approved" do
          let(:user) { create(:user) }
          let(:letter) do
            let = create_letter(
              state: :pending_review,
              to: :primary_care_physician,
              patient: patient
            )
            ApproveLetter.new(let).call(by: user)
            Letter::Approved.find(let.id)
          end

          it "sanity check" do
            expect(letter).to be_approved
          end

          it "PracticeEmail.address returns the practice email" do
            practice_email_address = Delivery::Email::PracticeEmail.new(letter).address

            expect(practice_email_address).to be_nil
          end

          it "DeliveryPolicy#email_letter_to_practice? returns true" do
            policy = Delivery::Email::DeliveryPolicy.new(letter)

            expect(policy.email_letter_to_practice?).to be(false)
          end
        end
      end
    end
  end
end
