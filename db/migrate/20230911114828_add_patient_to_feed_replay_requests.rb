class AddPatientToFeedReplayRequests < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        add_reference :feed_replay_requests,
                      :patient,
                      foreign_key: { to_table: :patients },
                      index: true,
                      null: false
        add_column :feed_replay_requests,
                   :error_message,
                   :text
      end
    end
  end
end
