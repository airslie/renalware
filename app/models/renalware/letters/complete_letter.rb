# frozen_string_literal: true

require_dependency "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    class CompleteLetter
      include Broadcasting
      pattr_initialize :letter

      class << self
        alias_method :build, :new
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
