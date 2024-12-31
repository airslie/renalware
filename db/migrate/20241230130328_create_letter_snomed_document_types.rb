class CreateLetterSnomedDocumentTypes < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      comment = <<-COMMENT.squish
        SNOMED codes and their description that are attached to a letter description (aka
        letter topic) and used as the FHIR Composition.document_type in GP Connect messages.
        There can be only one default type, and this is used wherever a letter description has no
        associated SNOMED document type.
      COMMENT
      create_table :letter_snomed_document_types, comment: comment do |t|
        t.text :title, null: false, index: { unique: true }
        t.text :code, null: false, index: { unique: true }
        t.boolean :default_type,
                  default: false,
                  null: false,
                  index: { unique: true, where: "default_type = true" }
        t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
      end

      safety_assured do
        add_reference :letter_descriptions,
                      :snomed_document_type,
                      foreign_key: { to_table: :letter_snomed_document_types },
                      index: true
      end
    end
  end
end
