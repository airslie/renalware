class AddUuidToEvents < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column :events,
                 :uuid,
                 :uuid,
                 comment: "A unique identifier for this event, used for external references eg HL7",
                 null: true
      change_column_default :events, :uuid, from: nil, to: "gen_random_uuid()"
    end
  end
end
