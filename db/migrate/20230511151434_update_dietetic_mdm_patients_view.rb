class UpdateDieteticMDMPatientsView < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        update_view :dietetic_mdm_patients, version: 4, revert_to_version: 3
      end
    end
  end
end
