module Renalware
  module Letters
    class SectionSnapshot < ApplicationRecord
      belongs_to :letter

      def self.create_all(letter)
        letter.sections.each do |section_class|
          snapshot = letter.section_snapshots
            .where(section_identifier: section_class.identifier)
            .first_or_initialize

          next if snapshot.persisted?

          snapshot.content = section_class.new(letter: letter).build_snapshot
          snapshot.save!
        end
      end

      def self.update_or_create_one(letter, section_identifier)
        snapshot = letter.section_snapshots
          .where(section_identifier: section_identifier)
          .first_or_initialize

        section_class = Letters::Topic.sections_by_identifier[section_identifier.to_sym]
        snapshot.content = section_class.new(letter: letter).build_snapshot
        snapshot.save!
      end
    end
  end
end
