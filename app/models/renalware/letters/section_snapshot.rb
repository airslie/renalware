module Renalware
  module Letters
    class SectionSnapshot < ApplicationRecord
      belongs_to :letter

      def self.create_or_update(letter, section_identifier = nil, only_create: false)
        section_identifier ||= letter.topic&.section_identifier
        snapshot = find_or_initialize_by(letter:, section_identifier:)
        return if snapshot.persisted? && only_create

        snapshot.update!(content: Section.new(letter:, section_identifier:).build_snapshot)
      end
    end
  end
end
