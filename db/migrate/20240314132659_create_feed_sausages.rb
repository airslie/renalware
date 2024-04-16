class CreateFeedSausages < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      # Experimental replacement for feed_messages based on upserts for ORU and inserts for ADT.
      # Strange name so we do not conflate with feed_messages..
      create_table :feed_sausages do |t|
        t.timestamp :sent_at, null: false
        t.integer :version, null: false, default: 1
        t.timestamp :processed_at
        t.enum :message_type, enum_type: :hl7_message_type, null: false
        t.enum :event_type, enum_type: :hl7_event_type, null: false
        t.string :orc_filler_order_number, null: true
        t.enum :orc_order_status, enum_type: :enum_hl7_orc_order_status
        t.string :header_id
        t.text :body, null: false
        t.string :nhs_number
        t.string :local_patient_id
        t.string :local_patient_id_2
        t.string :local_patient_id_3
        t.string :local_patient_id_4
        t.string :local_patient_id_5
        t.date :dob
        t.timestamps null: false
      end
      # This unique partial index is key to ensure that in feed_sausages_upsert_from_mirth()
      # - ADT messages never conflict as the unique index only applies where orc_filler_order_number
      #   is not '' or NULL, and ADTs do not have an orc_filler_order_number
      # - ORU messages, which always have a orc_filler_order_number, will conflict when updates
      #   arrive and the ON CONFLICT in the feed_sausages_upsert_from_mirth lets do an upsert
      add_index :feed_sausages,
                :orc_filler_order_number,
                unique: true,
                where: "orc_filler_order_number is not null and orc_filler_order_number != ''"
      add_index :feed_sausages, :sent_at

      create_table :feed_sausage_queue do |t|
        t.integer :feed_sausage_id, null: false
        t.timestamps null: false
      end
      add_index :feed_sausage_queue, :feed_sausage_id
    end
  end
end
