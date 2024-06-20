class UpdateDrugsPrescribableDrugs < ActiveRecord::Migration[7.1]
  def up
    within_renalware_schema do
      drop_view :drug_prescribable_drugs, materialized: true
      create_view :drug_prescribable_drugs, version: 2, materialized: true
    end
  end

  def down
    drop_view :drug_prescribable_drugs, materialized: true
    create_view :drug_prescribable_drugs, version: 1, materialized: true
  end
end
