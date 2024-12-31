module Renalware
  module Letters
    class ReviseLetter
      include Wisper::Publisher
      include LetterPathology

      def self.build
        new
      end

      def call(patient, letter_id, params = {})
        letter = patient.letters.pending.find(letter_id)
        Letter.transaction do
          # See e.g. Letter::Draft.revise
          letter.revise(params.except(:update_sections))

          if letter.changes.key?(:pathology_timestamp)
            letter.pathology_snapshot = build_pathology_snapshot(patient)
          end
          letter.save!

          create_snapshots_for_letter_sections_if_topic_has_changed(letter, params)
          update_section_snapshots(letter, params)
        end
        broadcast(:revise_letter_successful, letter)
      rescue ActiveRecord::RecordInvalid
        broadcast(:revise_letter_failed, letter)
      end

      private

      def create_snapshots_for_letter_sections_if_topic_has_changed(letter, _params)
        return unless letter.topic
        return unless letter.topic_id_previously_changed?

        Letters::SectionSnapshot.create_all(letter)
      end

      def update_section_snapshots(letter, params)
        return if params[:update_sections].nil?

        params[:update_sections].select { |_section, should_update|
          ActiveModel::Type::Boolean.new.cast(should_update)
        }.keys.each do |section_identifier|
          Letters::SectionSnapshot.update_or_create_one(letter, section_identifier)
        end
      end
    end
  end
end
