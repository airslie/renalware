class AddAccessPlanToAKCCMDM < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      update_view :akcc_mdm_patients, version: 5, revert_to_version: 4
    end
  end
end
