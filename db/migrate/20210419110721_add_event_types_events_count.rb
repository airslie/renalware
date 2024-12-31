class AddEventTypesEventsCount < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column(
        :event_types,
        :events_count,
        :integer,
        default: 0,
        null: false,
        comment: "Counter cache column which Rails will update and which stores the count of " \
                 "events created with this type"
      )
    end
  end
end
