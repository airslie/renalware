module Renalware
  module Letters
    class LetterPresenterFactory
      def self.new(letter)
        LetterPresenter.const_get(letter.class.name.demodulize).new(letter)
      end
    end
  end
end
