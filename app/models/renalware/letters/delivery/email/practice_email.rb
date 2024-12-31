module Renalware
  module Letters
    module Delivery
      module Email
        # Utility class to help us resolve the correct email address when sending to the practice.
        # If we allow_external_mail then we use the practice email, other wise we use the email
        # of the last user to update the letter (useful for testing, ie you get the GP email if you
        # approve the letter) or a system default for testing if the user has no email address.
        class PracticeEmail
          pattr_initialize :letter
          delegate :patient, to: :letter
          delegate :practice, to: :patient
          delegate :config, to: :Renalware

          def address
            if config.allow_external_mail
              practice&.email # nil is acceptable
            else
              config.fallback_email_address_for_test_messages
            end
          end
        end
      end
    end
  end
end
