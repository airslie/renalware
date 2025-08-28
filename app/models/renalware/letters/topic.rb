module Renalware
  module Letters
    class Topic < ApplicationRecord
      include Letters::SectionIdentifier
      include Sortable

      # DATABASE: Rename table to `letter_topics`
      self.table_name = "letter_descriptions"

      self.ignored_columns += [:section_identifiers]

      acts_as_paranoid
      validates :text, presence: true, uniqueness: true

      scope :ordered, -> { order(deleted_at: :desc, position: :asc, text: :asc) }

      belongs_to :snomed_document_type

      def snomed_document_type
        super || default_snomed_document_type
      end

      def default_snomed_document_type
        @default_snomed_document_type ||= SnomedDocumentType.find_by(default_type: true)
      end
    end
  end
end
