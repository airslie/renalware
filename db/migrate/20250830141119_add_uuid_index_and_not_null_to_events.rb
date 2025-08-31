class AddUuidIndexAndNotNullToEvents < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      safety_assured do
        # We can now make the uuid column not null and add a unique index to it
        change_column_default :events, :uuid, from: nil, to: "gen_random_uuid()"
        change_column_null :events, :uuid, false
        add_index :events, :uuid, unique: true
      end
    end
  end
end
