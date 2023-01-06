class CreateFeedOutgoingDocuments < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_enum :feed_outgoing_document_state, %w(queued errored processed)

      table_comment = <<-COMMENT.squish
        A queue of documents (letters, events) that require processing by an external
        system e.g. Mirth. For example when a letter is approved, a hospital's Renalware host app
        may listener for that event and write a row to this table, including
        the (polymorphic) details of the document (in this case the class name and id
        of the letter). When Mirth or the external system queries the Renalware API for for
        waiting queued documents, it will return documents referenced here that have a state of
        'queued'. The renderable relation must implement the expected methods
        required to render to the requested format e.g. HL7 (and in the future FHIR).
      COMMENT

      create_table :feed_outgoing_documents, comment: table_comment do |t|
        t.references(
          :renderable,
          polymorphic: true,
          null: false,
          index: false,
          comment: "The letter/event/etc to be processed"
        )
        t.enum :state, enum_type: :feed_outgoing_document_state, null: false, default: :queued
        t.json :printing_options, default: {}
        t.uuid :external_uuid, index: { unique: true }, comment: "E.g. the Mirth message id"
        t.text :error
        t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
        t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
        t.timestamps null: false
      end
      add_index(
        :feed_outgoing_documents,
        [:renderable_type, :renderable_id],
        name: :index_feed_outgoing_documents_on_renderable
      )
    end
  end
end
