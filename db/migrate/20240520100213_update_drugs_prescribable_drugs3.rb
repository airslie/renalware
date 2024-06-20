class UpdateDrugsPrescribableDrugs3 < ActiveRecord::Migration[7.1]
  def up
    within_renalware_schema do
      safety_assured do
        drop_view :drug_prescribable_drugs, materialized: true
        create_view :drug_prescribable_drugs, version: 3, materialized: true
        add_index :drug_prescribable_drugs,
                  :compound_name,
                  using: :gist,
                  opclass: { name: :gist_trgm_ops }
        add_index :drug_prescribable_drugs, :drug_id
      end
    end
  end

  def down
    drop_view :drug_prescribable_drugs, materialized: true
    create_view :drug_prescribable_drugs, version: 2, materialized: true
  end
end
