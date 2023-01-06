class UpdatePDMDMPatientsView07 < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      update_view :pd_mdm_patients, version: 7, revert_to_version: 6
    end
  end
end
