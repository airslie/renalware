class AddAllocatedToHDSlotRequestUrgencyEnum < ActiveRecord::Migration[7.1]
  disable_ddl_transaction! # required for add_enum_value

  def up
    within_renalware_schema do
      add_enum_value :enum_hd_slot_request_urgency, "allocated", if_not_exists: true
    end
  end

  def down
    # noop
  end
end
