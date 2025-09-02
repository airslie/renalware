class CreateHL7RawMessageErrors < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      create_table :feed_raw_hl7_message_errors do |t|
        t.text :body, null: false
        t.text :error_message
        t.text :error_message_backtrace
        t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
        t.datetime :sent_at, null: false
      end
      add_index :feed_raw_hl7_message_errors, :sent_at
    end
  end
end
