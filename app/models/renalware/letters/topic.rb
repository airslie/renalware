module Renalware
  module Letters
    class Topic < ApplicationRecord
      # TODO: Rename table to `letter_topics`
      self.table_name = "letter_descriptions"

      include Sortable

      self.ignored_columns += [:section_identifiers]

      enum :section_identifier, {
        hd: "hd",
        pd: "pd",
        transplants: "transplants",
        akcc: "akcc"
      }

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
