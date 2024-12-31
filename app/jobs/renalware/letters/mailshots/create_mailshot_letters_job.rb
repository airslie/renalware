module Renalware
  module Letters
    module Mailshots
      # A background job to create letter records for a mailshot.
      # More than 1000 letters in a mailshot could cause a timeout if executed
      # while the user waits, which is why processing is done in the background.
      class CreateMailshotLettersJob < ApplicationJob
        def perform(mailshot)
          mailshot.update_column(:status, :processing)
          mailshot.create_letters
          mailshot.update_columns(status: :success, last_error: nil)
        rescue StandardError => e
          mailshot.update_columns(
            last_error: "#{$ERROR_INFO}\nBacktrace:\n\t#{e.backtrace.join("\n\t")}",
            status: :failure
          )
          raise e
        end
      end
    end
  end
end
