class CreateEventIndexes1 < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      remove_index :events, :date_time, name: "index_events_on_date_time"
      add_index :events,
                "date_time desc nulls last",
                name: "index_events_on_date_time_desc_nulls_last",
                algorithm: :concurrently
    end
  end
end
