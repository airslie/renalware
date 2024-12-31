class CreateFeedLogs < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      create_enum :enum_feed_log_type, %w(close_match)
      create_enum :enum_feed_log_reason, %w(number_hit_dob_miss)

      create_table(
        :feed_logs,
        comment: "Stores links to a feed_message and a candidate/close-matched patient where " \
                 "eg a patient with the incoming nhs_number is found but their DOB " \
                 "differs. This allows an admin to review the log and diagnose the issue."
      ) do |t|
        t.enum :log_type, enum_type: :enum_feed_log_type, null: false, index: true
        t.enum :log_reason, enum_type: :enum_feed_log_reason, null: false, index: true
        t.references :patient, null: true, foreign_key: true, index: true
        t.references :message, null: true, foreign_key: { to_table: :feed_messages }, index: true
        t.enum :message_type, enum_type: :hl7_message_type, null: true
        t.enum :event_type, enum_type: :hl7_event_type, null: true
        t.text :note
        t.timestamps null: false
      end
    end
  end
end
