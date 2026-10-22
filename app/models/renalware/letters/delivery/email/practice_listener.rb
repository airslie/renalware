module Renalware
  module Letters
    module Delivery
      module Email
        # Subscribed to Letters::ApproveLetter when config.email_approved_letters_to_practice
        # is true. See config/initializers/renalware.rb
        class PracticeListener
          def letter_approved(letter)
            EmailLetterToPractice.call(letter)
          end
        end
      end
    end
  end
end
