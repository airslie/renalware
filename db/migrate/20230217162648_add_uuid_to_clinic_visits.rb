class AddUuidToClinicVisits < ActiveRecord::Migration[6.0]
  def up
    within_renalware_schema do
      add_column :clinic_visits, :uuid, :uuid
      change_column_default :clinic_visits, :uuid, 'uuid_generate_v4()'
    end
  end

  def down
    within_renalware_schema do
      drop_column :clinic_visits, :uuid
    end
  end
end
