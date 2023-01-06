class CreateEventVersions < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      # Because BLT already have this object, we check for its existence before creating
      create_table :event_versions, if_not_exists: true do |t|
        t.string   :item_type, null: false
        t.integer  :item_id,   null: false
        t.string   :event,     null: false
        t.string   :whodunnit
        t.jsonb    :object
        t.jsonb    :object_changes
        t.datetime :created_at
      end

      reversible do |dir|
        dir.up   {
          safety_assured do
            # Because BLT already have this object, we check for its existence before creating
            execute(<<-SQL.squish)
              CREATE INDEX CONCURRENTLY IF NOT EXISTS
                index_event_versions_on_item_type_and_item_id
                ON renalware.event_versions USING btree (item_type, item_id);
            SQL
          end
        }
        dir.down {
          # It is safer to leave the index intact because
          # - it was already extant at BLT and we do not want to remove it if rolling back
          # - it take a long time to create
        }
      end
    end
  end
end
