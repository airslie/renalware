class AddUuidToHospitalCentres < ActiveRecord::Migration[7.0]
  def up
    within_renalware_schema do
      add_column :hospital_centres, :uuid, :uuid
      change_column_default :hospital_centres, :uuid, "uuid_generate_v4()"
    end
  end

  def down
    within_renalware_schema do
      remove_column :hospital_centres, :uuid
    end
  end
end
