module Renalware
  module Letters
    class LettersInProgressComponent < ApplicationComponent
      pattr_initialize [:current_user!]

      # Note we want oldest letters ordered first here - elsewhere letters are newest first
      def letters_in_progress
        @letters_in_progress ||= present_letters(
          Letters::Letter
            .reversed
            .where("author_id = ? or created_by_id = ?", current_user.id, current_user.id)
            .in_progress
            .includes(:author, :patient, :letterhead)
        )
      end

      private

      def present_letters(letters)
        CollectionPresenter.new(letters, Letters::LetterPresenterFactory)
      end
    end
  end
end
