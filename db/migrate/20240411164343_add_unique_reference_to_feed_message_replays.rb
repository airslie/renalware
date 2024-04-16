class AddUniqueReferenceToFeedMessageReplays < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      within_renalware_schema do
        add_column :feed_message_replays, :urn, :string
        add_index :feed_message_replays, :urn
      end
    end
  end
end
