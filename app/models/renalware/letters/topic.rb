# frozen_string_literal: true

module Renalware
  module Letters
    class Topic < ApplicationRecord
      # TODO: Rename table to `letter_topics`
      self.table_name = "letter_descriptions"

      include Sortable
      acts_as_paranoid
      validates :text, presence: true, uniqueness: true

      scope :ordered, -> { order(deleted_at: :desc, position: :asc, text: :asc) }

      concerning :Sections do
        included do
          cattr_accessor :letter_extension_sections, default: [
            Renalware::HD::LetterExtensions::HDSection
          ]
        end

        def sections
          section_identifiers.map { |identifier|
            self.class.sections_by_identifier[identifier.to_sym]
          }
        end

        class_methods do
          def sections_by_identifier
            letter_extension_sections.index_by(&:identifier)
          end
        end
      end
    end
  end
end
