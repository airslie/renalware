class AddSentAtToFeedMessages < ActiveRecord::Migration[7.0]
  def up
    within_renalware_schema do
      add_column :feed_messages, :sent_at, :datetime, if_not_exists: true
    end
  end

  def down
    # noop - do not want to risk losing data populated in sent_at as is expensive to recreate
  end
end
