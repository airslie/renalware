module Renalware
  module Letters
    module Delivery
      module Email
        # This is a utility class that a host app might want to use to send an approved letter
        # to the patient's practice.
        class EmailLetterToPractice
          pattr_initialize [:letter!]
          delegate :email_letter_to_practice?, :gp_recipient, to: :policy

          def self.call(letter)
            new(letter: letter).call
          end

          # Returns
          #   true: we have sent an email to the patient's practice
          #   false: the patient does not have a practice or the practice has no email address
          def call
            return false unless email_letter_to_practice?

            email_letter_to_the_patients_practice
            true
          end

          private

          # Note we are already in a tx here from the letter_listener, so for safety we call
          # call #deliver_later and not #deliver; its possible we could get a
          # LetterIsNotApprovedOrCompletedError error in the mailer we and we don't want that to
          # roll back the txn. We could possibly use an async Listener and remove the
          # deliver_later here.
          def email_letter_to_the_patients_practice
            Letter.transaction do
              PracticeMailer.patient_letter(
                letter: letter,
                to: practice_email_address
              ).deliver_later # ! see comment

              # Flag as sent
              gp_recipient.update(emailed_at: Time.zone.now)
            end
          end

          def practice_email_address
            PracticeEmail.new(letter).address
          end

          def policy
            @policy ||= DeliveryPolicy.new(letter)
          end
        end
      end
    end
  end
end
