class AddReasonToFeedReplayRequests < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column :feed_replay_requests, :reason, :text
    end
  end
end
