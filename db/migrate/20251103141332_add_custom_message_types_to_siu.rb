class AddCustomMessageTypesToSiu < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      # Z01 and Z02 are custom SIU message types used by eg Imperial
      add_enum_value :hl7_event_type, "Z01", before: "Z73"
      add_enum_value :hl7_event_type, "Z02", before: "Z73"
    end
  end
end
