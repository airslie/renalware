class AddColumnsToHDSlotRequests < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      within_renalware_schema do
        add_column(
          :hd_slot_requests,
          :medically_fit_for_discharge,
          :boolean,
          default: false,
          null: false,
          comment: "The datetime the MFFD checkbox was checked"
        )
        add_column(
          :hd_slot_requests,
          :medically_fit_for_discharge_at,
          :datetime,
          comment: "The datetime the MFFD checkbox was checked"
        )
        add_reference(
          :hd_slot_requests,
          :medically_fit_for_discharge_by,
          references: :users,
          index: true,
          comment: "The id of the user show checked the MFFD checkbox on the HD Slot Request form"
        )
      end
    end
  end
end
