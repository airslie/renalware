class CreatePathologyRequestsDrugsDrugCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :pathology_requests_drugs_drug_categories do |t|
      t.integer :drug_id, null: false
      t.integer :drug_category_id, null: false
    end

    add_foreign_key :pathology_requests_drugs_drug_categories, :drugs, column: :drug_id
    add_foreign_key :pathology_requests_drugs_drug_categories,
                    :pathology_requests_drug_categories, column: :drug_category_id
  end
end
