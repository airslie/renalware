class AddEditableWindowColumnsToEventTypes < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      change_table :event_types do |t|
        t.boolean :superadmin_can_always_change, default: true, null: false
        t.integer(
          :author_change_window_hours,
          default: 0,
          null: false,
          comment: "Period post-creation within which an event of this type " \
                   "can be edited by the author"
        )
        t.integer(
          :admin_change_window_hours,
          default: 0,
          null: false,
          comment: "Period post-creation within which an event of this type " \
                   "can be edited by an admin (or superadmin if superadmin_can_always_change " \
                   "is false"
        )
      end
    end
  end
end
