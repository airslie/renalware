class CreatePrescribableDrugsView < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      within_renalware_schema do
        create_view :drug_prescribable_drugs, materialized: true
        # Add a trigram index which will be used when a search term is > 4 characters long.
        enable_extension "pg_trgm"
        add_index :drug_prescribable_drugs,
                  :name,
                  using: :gist,
                  opclass: { name: :gist_trgm_ops }
      end
    end
  end
end
