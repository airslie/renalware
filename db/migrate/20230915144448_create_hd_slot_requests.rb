class CreateHDSlotRequests < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      # rubocop:disable Rails/CreateTableWithTimestamps
      create_table :hd_slot_request_deletion_reasons do |t|
        t.string :reason, unique: true
        t.datetime :deleted_at, index: true
      end
      # rubocop:enable Rails/CreateTableWithTimestamps

      create_enum :enum_hd_slot_request_urgency, %w(routine urgent highly_urgent)

      create_table :hd_slot_requests do |t|
        t.references :patient, null: false, foreign_key: true, index: true
        t.references :created_by, index: true, null: false, foreign_key: { to_table: :users }
        t.references :updated_by, index: true, null: false, foreign_key: { to_table: :users }
        t.enum :urgency, enum_type: :enum_hd_slot_request_urgency, null: false
        t.boolean :inpatient, null: false, default: false
        t.boolean :late_presenter,
                  :boolean,
                  null: false,
                  default: false,
                  comment: "known to service <90 days"
        t.boolean :suitable_for_twilight_slots, null: false, default: false
        t.text :specific_requirements, comment: "transport requirements, blood borne viruses etc"
        t.text :notes
        t.datetime :allocated_at, index: true
        t.datetime :deleted_at, index: true
        t.timestamps null: false
      end
    end
  end
end
