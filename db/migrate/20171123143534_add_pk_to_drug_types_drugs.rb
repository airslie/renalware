class AddPkToDrugTypesDrugs < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      # Remove the old PK
      reversible do |direction|
        direction.up do
          execute "ALTER TABLE drug_types_drugs DROP CONSTRAINT IF EXISTS drug_types_drugs_pkey"
        end
        direction.down do
          # noop
          # ok was on drug_type_id, which is incorrect (duplicates will be found) so leaving
        end
      end
      add_column :drug_types_drugs, :id, :primary_key
      add_index :drug_types_drugs, [:drug_id, :drug_type_id], unique: true
      add_timestamps :drug_types_drugs, null: true
    end
  end
end
