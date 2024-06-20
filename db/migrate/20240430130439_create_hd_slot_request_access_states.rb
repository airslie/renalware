class CreateHDSlotRequestAccessStates < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      create_table :hd_slot_request_access_states do |t|
        t.text :name, null: false
        t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
        t.integer :position, null: false, default: 0
        t.index "lower((name)::text)",
                unique: true,
                name: "index_hd_slot_request_access_states_on_name"
      end
      safety_assured do
        add_reference(
          :hd_slot_requests,
          :access_state,
          foreign_key: { to_table: "hd_slot_request_access_states" },
          index: true
        )
      end
    end
  end
end
