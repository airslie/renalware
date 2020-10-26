class UpdatePDMDMPatientsView < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      update_view :pd_mdm_patients, version: 2, revert_to_version: 1
    end
  end
end
