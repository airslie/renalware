class MakeDieteticMDMViewMaterialised < ActiveRecord::Migration[6.0]
  # Some dancing here as, from version 5 on, the view is materialised
  def up
    within_renalware_schema do
      drop_view :dietetic_mdm_patients
      create_view :dietetic_mdm_patients, version: 5, materialized: true
    end
  end

  def down
    within_renalware_schema do
      drop_view :dietetic_mdm_patients, materialized: true
      create_view :dietetic_mdm_patients, version: 4, materialized: false
    end
  end
end
