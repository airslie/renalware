class CreateFeedReplays < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      create_table :feed_replay_requests do |t|
        # t.enum :message_type, enum_type: :hl7_message_type
        # t.enum :event_type, enum_type: :hl7_event_type
        # t.enum :orc_order_status, enum_type: :enum_hl7_orc_order_status
        t.jsonb :criteria, default: {}, index: { using: :gin }
        t.datetime :started_at, null: false
        t.datetime :finished_at, null: true
        t.integer :total_messages, null: false, default: 0
        t.integer :failed_messages, null: false, default: 0
        t.timestamps null: false
      end

      create_table :feed_message_replays do |t|
        t.references(
          :replay_request,
          index: true,
          null: false,
          foreign_key: { to_table: :feed_replay_requests }
        )
        t.references(
          :message,
          index: true,
          null: false,
          foreign_key: { to_table: :feed_messages }
        )
        t.boolean :success, null: false, default: false
        t.text :error_message
        t.timestamps null: false
      end
    end
  end
end
