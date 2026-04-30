class CreateFeedMessageHousekeeping < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      create_table :feed_message_housekeeping_runs, if_not_exists: true do |t|
        t.string :function_name, null: false
        t.datetime :started_at, null: false
        t.datetime :finished_at
        t.enum :message_type, enum_type: :hl7_message_type
        t.interval :retention_period
        t.integer :batch_size, null: false
        t.datetime :cutoff_sent_at, null: false
        t.integer :deleted_count, default: 0, null: false
        t.datetime :oldest_deleted_sent_at
        t.datetime :newest_deleted_sent_at
        t.text :error_message
        t.timestamps null: false
      end

      change_column_null :feed_message_replays, :message_id, true
    end
  end
end
