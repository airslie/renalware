require "collection_presenter"

module Renalware
  module Letters
    class SummaryPart < Renalware::SummaryPart
      def letters
        present_letters(find_letters)
      end

      def letters_count
        title_friendly_collection_count(
          actual: letters.size,
          total: patient.summary.letters_count
        )
      end

      def to_partial_path
        "renalware/letters/summary_part"
      end

      # Disabling cache until we can work out why caching works in AZ MSE UAT but not prod
      # where updating the patient or their letters does not invalidate the cache key
      # def cache_key
      #   [
      #     letters_patient.cache_key_with_version,
      #     letters_patient.letters.cache_key_with_version
      #   ].join("~")
      # end

      private

      def find_letters
        letters_patient
          .letters
          .ordered
          .with_main_recipient
          .with_letterhead
          .with_author
          .limit(Renalware.config.clinical_summary_max_letters_to_display)
      end

      def present_letters(letters)
        CollectionPresenter.new(letters, Renalware::Letters::LetterPresenterFactory)
      end

      def letters_patient
        @letters_patient ||= Renalware::Letters.cast_patient(patient)
      end
    end
  end
end
