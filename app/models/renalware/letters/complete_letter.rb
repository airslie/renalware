module Renalware
  module Letters
    class CompleteLetter
      include Broadcasting
      pattr_initialize :letter

      class << self
        alias build new
      end

      def call(by:)
        Letter.transaction do
          @letter = letter.complete(by: by)
          letter.save!
          broadcast(:letter_completed, letter)
        end
      end
    end
  end
end
