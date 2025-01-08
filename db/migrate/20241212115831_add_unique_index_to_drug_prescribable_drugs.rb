class AddUniqueIndexToDrugPrescribableDrugs < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      safety_assured do
        add_index :drug_prescribable_drugs,
                  :compound_id,
                  unique: true,
                  comment: "Unique idx on this materialized view enables us to refresh concurrently"
      end
    end
  end
end
