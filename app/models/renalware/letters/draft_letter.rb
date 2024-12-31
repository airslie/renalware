module Renalware
  module Letters
    class DraftLetter
      include Wisper::Publisher
      include LetterPathology

      def self.build
        new
      end

      def call(patient, params = {})
        letter = LetterFactory.new(patient, params).build
        letter.pathology_snapshot = build_pathology_snapshot(patient)
        letter.save!
        create_snapshots_for_letter_sections(letter)
        letter.reload
        broadcast(:draft_letter_successful, letter)
        letter
      rescue ActiveRecord::RecordInvalid
        broadcast(:draft_letter_failed, letter)
      end

      private

      def create_snapshots_for_letter_sections(letter)
        return unless letter.topic

        Letters::SectionSnapshot.create_all(letter)
      end
    end
  end
end
