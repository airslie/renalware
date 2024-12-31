class CreateDrugTypesDrugs < ActiveRecord::Migration[4.2]
  def change
    create_table :drug_types_drugs, primary_key: [:drug_id, :drug_type_id] do |t|
      t.references :drug,      foreign_key: true
      t.references :drug_type, foreign_key: true
    end
    # add_index(:drug_types_drugs, [:drug_id, :drug_type_id], unique: true)
  end
end
