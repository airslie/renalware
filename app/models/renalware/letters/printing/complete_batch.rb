module Renalware
  module Letters
    module Printing
      # Marks as completed a Batch and all Letters within it.
      class CompleteBatch
        pattr_initialize [:batch!, :user!]

        # TOD: Avoid loading all letters into memory
        def call
          Batch.transaction do
            batch.letters.each do |letter|
              CompleteLetter.build(letter).broadcasting_to_configured_subscribers.call(by: user)
            end
            batch.update_by(user, status: :success)
            batch.reload
          end
        end
      end
    end
  end
end
