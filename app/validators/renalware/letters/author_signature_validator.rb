module Renalware
  module Letters
    class AuthorSignatureValidator < ActiveModel::Validator
      def validate(letter)
        return if letter.death_notification?

        if letter.author&.signature.blank?
          errors.add(:signature, "Author must have a signature")
        end
      end
    end
  end
end
