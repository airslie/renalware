class FeedOutgoingDocumentExternalUuidDefaultValue < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      change_column_default :feed_outgoing_documents,
                            :external_uuid,
                            from: nil,
                            to: "gen_random_uuid()"
    end
  end
end
