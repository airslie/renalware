class CreateEventIndexes < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      add_index :events,
                :date_time,
                order: { date_time: :desc },
                algorithm: :concurrently
      add_index :events,
                "date(created_at) desc nulls last",
                name: "index_events_on_created_at_as_date",
                algorithm: :concurrently
      add_index :events,
                :created_at,
                order: { updated_at: :desc },
                algorithm: :concurrently
      add_index :events,
                :updated_at,
                order: { updated_at: :desc },
                algorithm: :concurrently
    end
  end
end
