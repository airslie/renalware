class AddActiveJobIdToLetterMeshTransmissions < ActiveRecord::Migration[7.1]
  disable_ddl_transaction! # required for add_enum_value

  def change
    within_renalware_schema do
      safety_assured do
        add_column :letter_mesh_transmissions, :active_job_id, :uuid
        add_column :letter_mesh_transmissions, :cancelled_at, :datetime
        add_index :letter_mesh_transmissions, :active_job_id
        add_index :letter_mesh_transmissions, :status
      end

      reversible do |direction|
        direction.up    { add_enum_value :enum_mesh_transmission_status, "cancelled" }
        direction.down  { remove_enum_value :enum_mesh_transmission_status, "cancelled" }
      end
    end
  end
end
