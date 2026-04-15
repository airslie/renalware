class UpdateHDMDMPatientsView8 < ActiveRecord::Migration[8.1]
  def change
    within_renalware_schema do
      safety_assured do
        update_view :hd_mdm_patients, version: 8, revert_to_version: 7
      end
    end
  end
end
